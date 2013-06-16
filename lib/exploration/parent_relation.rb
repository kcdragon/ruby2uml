require_relative 'relation'

module Exploration
  class ParentRelation < Relation
    
    # Yields the parent of the sexp
    def each sexp, context=nil, &block
      parent = nil
      parent_node = sexp.rest.rest.head
      if parent_node != nil # class has a parent
        parent = parent_node.rest.head.to_s
        #yield_wrapper = lambda { return context[:name], context[:type], :generalization, parent, :class }
        # TODO get namespace
        # REFACTOR pull up
        yield_wrapper = lambda { return context, :generalization, { name: parent, type: :class } }
        if block_given?
          #block.call yield_wrapper.call
          block.call context, :generalization, { name: parent, type: :class }
        else
          #yield yield_wrapper.call
          yield context, :generalization, { name: parent, type: :class }
        end
      end
    end
  end
end
