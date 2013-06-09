require_relative '../graph/digraph'
require_relative '../graph/edge'
require_relative '../graph/vertex'

module Exploration
  # The Explorable mixin provides implementing classes with methods to extract relationships from an +sexp+ object. The class must implement Explorable#each(sexp, context=nil, &block) which yields entities (classes, modules, etc.) and their relationships among each other.
  #
  # == Explorable#each
  # [arguments] - +sexp+ an Sexp object
  #             - +context+ a String representing the Entity that is calling each (default: nil)
  #
  # [yields] - name of entity
  #          - type of entity
  #          - relation (can be +nil+)
  #          - name of entity receiving relation (can be +nil+)
  #          - type of entity receiving relation (can be +nil+)
  module Explorable
    def generate_graph sexp
      graph = Graph::Digraph.new
      self.each(sexp) do |name, type, relation, o_name, o_type|
        vertex = get_or_create_vertex graph, name, type
        if not relation.nil?
          o_vertex = get_or_create_vertex graph, o_name, o_type
          edge = get_edge relation
          vertex.add_edge edge, o_vertex
        end
      end
      return graph
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
end
