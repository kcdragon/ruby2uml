require_relative 'uml_builder'

class DotBuilder
  include UmlBuilder

  def initialize config={}, dot_config={}
    super(config)
    @dot_config = dot_config

    @id_counter = 0
    @vertex_to_id = Hash.new

    @vertex_mappings = Hash.new
    @vertex_mappings[:module] = lambda do |m|
      return "..."
    end
    @vertex_mappings[:class] = lambda do |c|
      return "...|..."
    end

    @edge_mappings = Hash.new
    @edge_mappings[:generalization] = lambda do |child, parent|
      return "#{parent}->#{child}[arrowtail=empty, dir=back]"
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
    name = vertex.fully_qualified_name(@config["delimiter"])
    "#{@id_counter}[label = \"{#{name}|" +
      @vertex_mappings[vertex.type].call(vertex) +
      "}\"]\n"
  end

  def build_relation vertex, edge, o_vertex
    @edge_mappings[edge].call(@vertex_to_id[vertex], @vertex_to_id[o_vertex]) + "\n"
  end

  def build_footer
    "}"
  end
end
