require_relative 'relation'

class GeneralizationRelation < Relation
  
  # Yields the parent of the +sexp+.
  def each sexp, context=nil, &block
    parent_node = sexp.rest.rest.head
    if parent_node != nil # class has a parent
      parent, namespace, explored = get_name_and_namespace parent_node
      block.call context, :generalization, { name: parent, type: :class, namespace: namespace }
    end
  end
end
