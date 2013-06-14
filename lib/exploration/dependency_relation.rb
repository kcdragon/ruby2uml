require_relative 'relation'

module Exploration

  # Yields dependency relationships in +sexp+
  class DependencyRelation < Relation
    def each sexp, context=nil, &block
      callbacks = {
        [:call] => lambda do |sexp| # search for call statements
          sexp.rest.each_of_type(:const) do |dependency_node|
            dependency_name = dependency_node.rest.head.to_s # name of the dependenct class
            block.call context[:name], context[:type], :dependency, dependency_name, :class
          end
        end
      }
      # REFACTOR extract to superclass, possibly use template method to get the callbacks and have the each in a superclass
      each_of_type :defn, sexp, context, callbacks, &block # defn is instance method
      each_of_type :defs, sexp, context, callbacks, &block # defs is class method
    end
  end
end
