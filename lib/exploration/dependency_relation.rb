require_relative 'relation'

module Exploration
  class DependencyRelation < Relation

    # Yields dependency relationships in +sexp+
    def each sexp, context=nil, &block
      yielded = []
      callbacks = {
        [:call] => lambda do |sexp| # search for call statements
          call_body = sexp.rest
          explore_sexp_with_namespace call_body, :dependency, context, yielded, &block
          explore_sexp_without_namespace call_body, :dependency, context, yielded, &block # by exploring :colon2 first, we won't pick up any :const that was inside a :colon2
        end
      }
      # REFACTOR extract to superclass, possibly use template method to get the callbacks and have the each in a superclass
      each_of_type :defn, sexp, context, callbacks, &block # defn is instance method
      each_of_type :defs, sexp, context, callbacks, &block # defs is class method
    end
  end
end
