require_relative 'relation'

module Exploration
  class DependencyRelation < Relation
    def each sexp, context=nil, &block
      callbacks = {
        [:call] => lambda do |sexp|
          sexp.rest.each_of_type(:const) do |dependency_node|
            dependency_name = dependency_node.rest.head.to_s
            block.call context[:name], context[:type], :dependency, dependency_name, :class
          end
        end
      }
      each_of_type :defn, sexp, context, callbacks, &block # defn is instance method
      each_of_type :defs, sexp, context, callbacks, &block # defs is class method
    end
  end
end
