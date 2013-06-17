require_relative 'relation'

module Exploration

  # Yields dependency relationships in +sexp+
  class DependencyRelation < Relation
    def each sexp, context=nil, &block
      yielded = []
      callbacks = {
        [:call] => lambda do |sexp| # search for call statements
          sexp.rest.each_of_type(:const) do |dependency_node|
            if !yielded.include?(dependency_node) # HACK currently, don't want dependencies being yielded twice
              dependency_name = dependency_node.rest.head.to_s # name of the dependenct class
              # REFACTOR pull up
              # TODO get namespace (if present)
              block.call context, :dependency, { name: dependency_name, type: :class }
              yielded << dependency_node
            end
          end
        end
      }
      # REFACTOR extract to superclass, possibly use template method to get the callbacks and have the each in a superclass
      each_of_type :defn, sexp, context, callbacks, &block # defn is instance method
      each_of_type :defs, sexp, context, callbacks, &block # defs is class method
    end
  end
end
