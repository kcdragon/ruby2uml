require_relative 'relation'

module Exploration
  class ParentRelation < Relation
    
    # Yields the parent of the +sexp+.
    def each sexp, context=nil, &block
      parent_node = sexp.rest.rest.head
      if parent_node != nil # class has a parent
        parent = if parent_node.first == :colon2
                   parent_node.rest.rest.head.to_s
                 else
                   parent_node.rest.head.to_s
                 end
        
        namespace, explored = get_namespace parent_node # don't need to do anything with what was explored
        # REFACTOR pull up
        block.call context, :generalization, { name: parent, type: :class, namespace: namespace }
      end
    end
  end
end
