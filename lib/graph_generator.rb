require_relative 'graph/digraph'
require_relative 'graph/edge_factory'
require_relative 'graph/vertex_factory'

class GraphGenerator
  attr_reader :graph

  def initialize
    @graph = Graph::Digraph.new
  end

  def process_sexp explorer, sexp
    explorer.each(sexp) do |name, type, relation, o_name, o_type|
      vertex = get_or_create_vertex @graph, name, type
      if not relation.nil?
        o_vertex = get_or_create_vertex @graph, o_name, o_type
        edge = get_edge relation
        vertex.add_edge edge, o_vertex
      end
    end
  end
  
private
  def get_or_create_vertex graph, name, type
    vertex = nil
    if graph.has_vertex? name
      vertex = graph.get_vertex name
    else
      vertex = graph.add_vertex create_vertex(name, type)
    end
    return vertex
  end

  def create_vertex name, type
    Graph::VertexFactory.instance.get_vertex name, type
  end

  def get_edge type
    Graph::EdgeFactory.instance.get_edge type
  end
end
