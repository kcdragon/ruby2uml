require_relative 'method_relation'

module Exploration
  class DependencyRelation < MethodRelation

    # Yields dependency relationships in +sexp+
    def get_method_explorers context, &block
      yielded = []
      {
        [:call] => lambda do |sexp| # search for call statements
          call_body = sexp.rest
          explore_sexp_with_namespace call_body, :dependency, context, yielded, &block
          explore_sexp_without_namespace call_body, :dependency, context, yielded, &block # by exploring :colon2 first, we won't pick up any :const that was inside a :colon2
        end
      }
    end
  end
end
