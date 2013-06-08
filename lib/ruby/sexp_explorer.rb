require_relative '../graph/edge'
require_relative '../graph/vertex'
require_relative 'aggregation_relationship'
require_relative 'dependency_relationship'
require_relative 'implements_relationship'
require_relative 'parent_relationship'
require_relative 'relationship'

module Ruby
  # NOTE: "head" and "rest" (aliased from "sexp_type" and "sexp_body") method calls on Sexp objects are simliar to Lisp's functions "car" and "cdr"
  # contains information to tell where in the sexp everything is for ruby
  class SexpExplorer
    def initialize
      # REFACTOR VIOLATES open-close principle, need to have relationships register with SexpExplorer
      @ef = Graph::EdgeFactory.instance
      @rels = Array.new
      @rels << ParentRelationship.new
      @rels << DependencyRelationship.new
      @rels << AggregationRelationship.new
    end

    def get_subject
      return :class, lambda { |sexp| sexp.rest.head }, Graph::ClassVertex
    end
    
    def each sexp, &block
      @rels.each do |rel|
        rel.each sexp, &block
      end
    end
  end
end
