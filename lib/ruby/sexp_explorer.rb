require_relative '../graph/edge'
require_relative '../graph/vertex'

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

  # REFACTOR extract class into file(s)
  class Relationship
    def initialize
      @ef = Graph::EdgeFactory.instance
    end
  end

  class ParentRelationship < Relationship
    def each sexp, &block
      parent = nil
      parent_node = sexp.rest.rest.head
      if parent_node != nil # class has a parent
        parent = parent_node.rest.head
      end
 
      # REFACTOR out edge factory into instance variable     
      yield_wrapper = lambda { return parent, Graph::ClassVertex, @ef.get_edge(:generalization) }
      if block_given?
        block.call yield_wrapper.call
      else
        yield yield_wrapper.call
      end
    end
  end

  # TODO implement implements, will take implements to mean "class Foo include Bar ; end"
  class ImplementsRelationship
    def each sexp, &block
    end
  end

  # TODO implement 1-n aggregation, punting on it for now
  class AggregationRelationship < Relationship
    def each sexp, &block
      each_of_type :defn, sexp, &block # defn is instance method
      each_of_type :defs, sexp, &block # defs is class method
    end
    
  private
    def each_of_type type, sexp, &block
      sexp.each_of_type(type) do |method_node|
        get_method_body(method_node).each_sexp do |sub_sexp|
          case sub_sexp.first
          when :iasgn, :cvasgn
            rhs = sub_sexp.rest.rest #right-hand-side of assignment
            rhs.each_of_type(:const) do |node|
              name = node.rest.head
              # REFACTOR extract method to superclass
              yield_wrapper = lambda { return name, Graph::ClassVertex, @ef.get_edge(:aggregation) }
              if block_given?
                block.call yield_wrapper.call
              else
                yield yield_wrapper.call
              end
            end
          end
        end
      end
    end
    
    # precondition: sexp is a method node
    def get_method_body sexp
      sexp.rest.rest.rest
    end
  end

  class DependencyRelationship < Relationship
    def each sexp, &block
      sexp.each_of_type(:call) do |call_node|
        call_node.rest.each_of_type(:const) do |dependency_node|
          dependency_name = dependency_node.rest.head
           yield_wrapper = lambda { return dependency_name, Graph::ClassVertex, @ef.get_edge(:dependency) }
          if block_given?
            block.call yield_wrapper.call
          else
            yield yield_wrapper.call
          end
        end
      end
    end
  end
end
