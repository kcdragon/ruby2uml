require_relative 'relation'

module Exploration
  # TODO implement 1-n aggregation, punting on it for now
  class AggregationRelation < Relation

    # Yields aggregation relationships in +sexp+
    def each sexp, context=nil, &block
      yielded = []
      callbacks = {
        [:iasgn, :cvasgn] => lambda do |sexp| # search inside instance and class assignment variables
          rhs = sexp.rest.rest # right-hand-side of assignment
          explore_sexp_with_namespace rhs, :aggregation, context, yielded, &block
          explore_sexp_without_namespace rhs, :aggregation, context, yielded, &block # by exploring :colon2 first, we won't pick up any :const that was inside a :colon2
        end
      }
      # REFACTOR extract to superclass, possibly use template method to get the callbacks and have the each in a superclass
      each_of_type :defn, sexp, context, callbacks, &block # defn is instance method
      each_of_type :defs, sexp, context, callbacks, &block # defs is class method
    end
  end
end
