require_relative 'relation'

module Exploration
  class ParentRelation < Relation
    
    # Yields the parent of the sexp
    def each sexp, context=nil, &block
      parent = nil
      parent_node = sexp.rest.rest.head
      if parent_node != nil # class has a parent
        parent = parent_node.rest.head.to_s
        # TODO get namespace
        # REFACTOR pull up
        # HACK not sure why I cannot use yield wrapper here
        if block_given?
          block.call context, :generalization, { name: parent, type: :class }
        else
          yield context, :generalization, { name: parent, type: :class }
        end
      end
    end
  end
end
