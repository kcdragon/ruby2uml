require_relative 'relation'

module Exploration
  # TODO implement 1-n aggregation, punting on it for now
  class AggregationRelation < Relation

    # Yields aggregation relationships in +sexp+
    def each sexp, context=nil, &block
      callbacks = {
        [:iasgn, :cvasgn] => lambda do |sexp| # search inside instance and class assignment variables
          rhs = sexp.rest.rest # right-hand-side of assignment
          rhs.each_of_type(:const) do |node|
            name = node.rest.head.to_s # name of the aggregated class
            #block.call context[:name], context[:type], :aggregation, name, :class
            # REFACTOR pull up
            # TODO extract namespace
            block.call context, :aggregation, { name: name, type: :class }
          end
        end
      }
      # REFACTOR extract to superclass, possibly use template method to get the callbacks and have the each in a superclass
      each_of_type :defn, sexp, context, callbacks, &block # defn is instance method
      each_of_type :defs, sexp, context, callbacks, &block # defs is class method
    end
  end
end
