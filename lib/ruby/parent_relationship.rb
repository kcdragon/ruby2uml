require_relative '../graph/edge'
require_relative '../graph/vertex'

require_relative 'relationship'

module Ruby
  class ParentRelationship < Relationship
    def each sexp, &block
      parent = nil
      parent_node = sexp.rest.rest.head
      if parent_node != nil # class has a parent
        parent = parent_node.rest.head.to_s
        yield_wrapper = lambda { return parent, Graph::ClassVertex, @ef.get_edge(:generalization) }
        if block_given?
          block.call yield_wrapper.call
        else
          yield yield_wrapper.call
        end
      end
    end
  end
end
