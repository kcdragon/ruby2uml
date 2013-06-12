require_relative 'relation'

module Exploration
  # TODO implement 1-n aggregation, punting on it for now
  class AggregationRelation < Relation
    def each sexp, context=nil, &block
      callbacks = {
        [:iasgn, :cvasgn] => lambda do |sexp|
          rhs = sexp.rest.rest # right-hand-side of assignment
          rhs.each_of_type(:const) do |node|
            name = node.rest.head.to_s
            block.call context[:name], context[:type], :aggregation, name, :class
          end
        end
      }
      each_of_type :defn, sexp, context, callbacks, &block # defn is instance method
      each_of_type :defs, sexp, context, callbacks, &block # defs is class method
    end
  end
end
