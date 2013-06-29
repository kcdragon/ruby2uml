require_relative '../sexp_ext'
require_relative 'relation'

module Exploration
  class ImplementsRelation < Relation
    def each sexp, context=nil, &block
      sexp.each_child do |child|
        # check if child is a call to include
        if child.first == :call && child.rest.rest.first == :include
          # REFACTOR similar to parent and other relations, should just need one call get_name_and_namespace
          node = child.rest.rest.rest.first
          name = node.rest.first.to_s
          namespace, explored = get_namespace node
          block.call context, :implements, { name: name, type: :module, namespace: namespace }
        end
      end
    end
  end
end
