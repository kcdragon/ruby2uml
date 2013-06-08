require_relative '../graph/edge'
require_relative '../graph/vertex'

require_relative 'relationship'

module Ruby
  # TODO implement 1-n aggregation, punting on it for now
  class AggregationRelationship < Relationship
    def each sexp, &block
      each_of_type :defn, sexp, &block # defn is instance method
      each_of_type :defs, sexp, &block # defs is class method
    end
    
  private
    # REFACTOR extract class method to superclass
    def each_of_type type, sexp, &block
      sexp.each_of_type(type) do |method_node|
        get_method_body(method_node).each_sexp do |sub_sexp|
          case sub_sexp.first
          when :iasgn, :cvasgn
            rhs = sub_sexp.rest.rest #right-hand-side of assignment
            rhs.each_of_type(:const) do |node|
              name = node.rest.head.to_s
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
end
