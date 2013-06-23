require_relative 'uml_builder'

class DotBuilder
  include UmlBuilder

  def initialize
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
    "digraph hierarchy {\n" +
      "size=\"5,5\"\n" +
      "node[shape=record, style=filled, fillcolor=gray95]\n"
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
