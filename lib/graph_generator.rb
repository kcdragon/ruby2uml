require_relative 'exploration/resolve/simple_resolve_strategy'

require_relative 'graph/digraph'
require_relative 'graph/edge_factory'
require_relative 'graph/namespace'
require_relative 'graph/vertex_factory'

class GraphGenerator
  attr_reader :graph
  attr_writer :resolve_strategy

  def initialize
    @graph = Graph::Digraph.new
    @resolve_strategy = Exploration::SimpleResolveStrategy.new
  end

  def process_sexp explorer, sexp
    explorer.each(sexp) do |entity, relation, other_entity|
      name = entity[:name]
      namespace = entity[:namespace]
      type = entity[:type]
      vertex = get_or_create_vertex @graph, name, namespace, type
      if not relation.nil?
        o_name = other_entity[:name]
        o_namespace = other_entity[:namespace]
        o_type = other_entity[:type]
        o_vertex = get_or_create_vertex @graph, o_name, o_namespace, o_type
        edge = get_edge relation
        vertex.add_edge edge, o_vertex
      end
    end
  end
  
private
  # TODO clean this method up
  def get_or_create_vertex graph, name, namespace, type
    vertex = nil
    if graph.has_vertex? name
      vertices = graph.find_vertex(name)
      old_vertex = vertices.first.dup
      new_vertex = create_vertex(name, namespace, type)
      vertex = @resolve_strategy.merge_vertices(old_vertex, new_vertex) if @resolve_strategy.is_same?(old_vertex, new_vertex) # TODO change for greater than 2
      graph.remove_vertex old_vertex
      graph.remove_vertex new_vertex
      graph.add_vertex vertex
    else
      vertex = graph.add_vertex create_vertex(name, namespace, type)
    end
    return vertex
  end

  # REFACTOR inject VertexFactory
  def create_vertex name, namespace, type
    v = Graph::VertexFactory.instance.get_vertex name, type
    v.namespace = Graph::Namespace.new(namespace)
    return v
  end

  # REFACTOR inject EdgeFactory
  def get_edge type
    Graph::EdgeFactory.instance.get_edge type
  end
end
