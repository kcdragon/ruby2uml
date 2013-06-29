require_relative 'method_relation'

module Exploration
  # TODO implement 1-n aggregation, punting on it for now
  class AggregationRelation < MethodRelation

    # Yields aggregation relationships in +sexp+
    def get_method_explorers context, &block
      yielded = []
      {
        [:iasgn, :cvasgn] => lambda do |sexp| # search inside instance and class assignment variables
          rhs = sexp.rest.rest # right-hand-side of assignment
          explore_sexp_with_namespace rhs, :aggregation, context, yielded, &block
          explore_sexp_without_namespace rhs, :aggregation, context, yielded, &block # by exploring :colon2 first, we won't pick up any :const that was inside a :colon2
        end
      }
    end
  end
end
