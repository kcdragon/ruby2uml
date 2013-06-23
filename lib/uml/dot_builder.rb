require_relative 'uml_builder'

class DotBuilder
  include UmlBuilder

  def initialize config={}
    @config = config

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
    size = "size=#{@config["size"]}\n" if @config.has_key? "size"
    if @config.has_key? "node"
      node = "node["
      @config["node"].each do |k, v|
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
    ns = vertex.namespace.to_s
    ns << '::' if ns != '' # TODO don't hard code seperator
    "#{@id_counter}[label = \"{#{ns + vertex.name}|" +
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
