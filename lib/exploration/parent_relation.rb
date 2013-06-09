require_relative 'relation'

module Exploration
  class ParentRelation < Relation
    def each sexp, context=nil, &block
      parent = nil
      parent_node = sexp.rest.rest.head
      if parent_node != nil # class has a parent
        parent = parent_node.rest.head.to_s
        yield_wrapper = lambda { return context[:name], context[:type], :generalization, parent, :class }
        if block_given?
          block.call yield_wrapper.call
        else
          yield yield_wrapper.call
        end
      end
    end
  end
end
