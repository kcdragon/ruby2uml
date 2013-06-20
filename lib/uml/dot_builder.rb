require_relative 'uml_builder'

class DotBuilder
  include UmlBuilder

  def initialize
    @id_counter = 0
    @vertex_to_id = Hash.new

    @dot_mappings = Hash.new
    @dot_mappings[:module] = lambda do |m|
      return "..."
    end
    @dot_mappings[:class] = lambda do |c|
      return "...|..."
    end
  end

  def build_entity vertex
    @id_counter += 1
    @vertex_to_id[vertex] = @counter
    ns = vertex.namespace.to_s
    ns << '::' if ns != '' # TODO don't hard code seperator
    "#{@id_counter}[label = \"{#{ns + vertex.name}|" +
      @dot_mappings[vertex.type].call(vertex) +
      "}\"]"
  end

  def build_relation vertex, edge, o_vertex
  end
end
