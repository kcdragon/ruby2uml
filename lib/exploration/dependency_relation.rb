require_relative 'method_relation'

module Exploration
  class DependencyRelation < MethodRelation

    # Yields dependency relationships in +sexp+
    def get_method_explorers context, &block
      already_explored = []
      {
        [:call] => lambda do |sexp| # search for call statements
          call_body = sexp.rest

          # by exploring :colon2 first, we won't pick up any :const that was inside a :colon2
          explore_entity_sexp :colon2, sexp, :dependency, context, already_explored, &block
          explore_entity_sexp :const, sexp, :dependency, context, already_explored, &block
        end
      }
    end
  end
end
