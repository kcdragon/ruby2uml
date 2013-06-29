require_relative 'method_relation'

module Exploration
  # TODO implement 1-n aggregation, punting on it for now
  class AggregationRelation < MethodRelation

    # Yields aggregation relationships in +sexp+
    def get_method_explorers context, &block
      already_explored = []
      {
        [:iasgn, :cvasgn] => lambda do |sexp| # search inside instance and class assignment variables
          rhs = sexp.rest.rest # right-hand-side of assignment
          # by exploring :colon2 first, we won't pick up any :const that was inside a :colon2
          explore_entity_sexp :colon2, sexp, :aggregation, context, already_explored, &block
          explore_entity_sexp :const, sexp, :aggregation, context, already_explored, &block
        end
      }
    end
  end
end
