require_relative 'uml_builder'

class DotBuilder
  include UmlBuilder

  def node_header v
    id = @vertex_to_id[v]
    name = v.fully_qualified_name(@config["delimiter"])
    "#{id}[label = \"{#{name}|"
  end

  def node_footer v
    "}\"]\n"
  end

  def initialize config={}, dot_config={}
    super(config)
    @dot_config = dot_config

    @id_counter = 0
    @vertex_to_id = Hash.new

    @vertex_mappings = Hash.new lambda { |*| '' }
    @vertex_mappings[:module] = lambda do |m|
      node_header(m) +
        "..." +
        node_footer(m)
    end
    @vertex_mappings[:class] = lambda do |c|
      node_header(c) +
        "...|..." +
        node_footer(c)
    end

    @edge_mappings = Hash.new lambda { |*| '' }
    @edge_mappings[:generalization] = lambda do |child, parent|
      return "#{parent}->#{child}[arrowtail=empty, dir=back]"
    end
    @edge_mappings[:implements] = lambda do |impl, type|
      return "#{type}->#{impl}[arrowtail=empty, dir=back, style=dashed]"
    end
    @edge_mappings[:aggregation] = lambda do |aggregator, aggregate|
      return "#{aggregator}->#{aggregate}[arrowtail=odiamond, constraint=false, dir=back]"
    end
    @edge_mappings[:dependency] = lambda do |vertex, depends_on|
      return "#{vertex}->#{depends_on}[dir=forward, style=dashed]"
    end
  end

  def build_header
    top = "digraph hierarchy {\n"
    size = ""
    size = "size=#{@dot_config["size"]}\n" if @dot_config.has_key? "size"
    if @dot_config.has_key? "node"
      node = "node["
      @dot_config["node"].each do |k, v|
        node << "#{k}=#{v}, "
      end
      node.chomp!(", ")
      node << "]\n"
    else
      node = ""
    end
    top + size + node
  end

  def build_entity vertex
    @id_counter += 1
    @vertex_to_id[vertex] = @id_counter
    @vertex_mappings[vertex.type].call(vertex)
  end

  def build_relation vertex, edge, o_vertex
    @edge_mappings[edge].call(@vertex_to_id[vertex], @vertex_to_id[o_vertex]) + "\n"
  end

  def build_footer
    "}"
  end
end
