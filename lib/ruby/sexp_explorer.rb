require_relative '../graph/edge'
require_relative '../graph/vertex'

module Ruby
  # NOTE: "head" and "rest" (aliased from "sexp_type" and "sexp_body") method calls on Sexp objects are simliar to Lisp's functions "car" and "cdr"
  # contains information to tell where in the sexp everything is for ruby
  class SexpExplorer

    def initialize
      @parent_relationship = ParentRelationship.new
    end

    def get_subject
      return :class, lambda { |sexp| sexp.rest.head }, Graph::ClassVertex
    end
    
    def each sexp, &block
      @parent_relationship.each sexp, &block
    end
  end

  # REFACTOR extract class into file(s)
  class Relationship
    
  end

  class ParentRelationship < Relationship
    def each sexp, &block
      parent = nil
      parent_node = sexp.rest.rest.head
      if parent_node != nil # class has a parent
        parent = parent_node.rest.head
      end
      
      # REFACTOR out edge factory into instance variable
      if block_given?
        block.call(parent, Graph::ClassVertex, Graph::EdgeFactory.instance.get_edge(:generalization))
      else
        yield parent, Graph::ClassVertex, Graph::EdgeFactory.instance.get_edge(:generalization)
      end
    end
  end

  # TODO implement aggregation
  class AggregationRelationship < Relationship
  end

  # TODO implement dependency
  #  class_node.each_of_type(:call) do |call_node|
  #    call_node.sexp_body.each_of_type(:const) do |dependency_node|
  #      dependency_name = dependency_node.rest.head.to_s
  #      depends_on << dependency_name
  #    end
  #  end
  # depends_on.each do |d|
  #   klass.add_edge @edge_factory.get_edge(:dependency), d
  # end
  class DependencyRelationship < Relationship
  end
end
