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
  class ClassSexpExplorer
    def self.instance
      @@instance ||= ClassSexpExplorer.new
    end
    
    def initialize
      @ef = Graph::EdgeFactory.instance
      @rels = Array.new
    end

    def register_relationship rel
      rel.explorer = self
      @rels << rel
    end

    # TODO prefix class name with module name (if there is one) that the class is nested in
    # not sure how to do this, easisest way would be for class_sexp to reach "up" into parent element, but not sure if that is possible
    # could also explore modules first and then pass a reference to module name to each embedded class
    def get_subject module_name=''
      return :class, lambda { |sexp| module_name + sexp.rest.head.to_s }, Graph::ClassVertex
    end
    
    def each sexp, &block
      @rels.each do |rel|
        rel.each sexp, &block
      end
    end
  end
end
