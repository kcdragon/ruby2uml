require_relative 'relation'

module Exploration
  class ImplementsRelation < Relation
    def each sexp, context=nil, &block
      sexp.each_sexp do |child|
        # check if child is a call to include
        if child.first == :call && child.rest.rest.first == :include
          node = child.rest.rest.rest.first
          name, namespace, explored = get_name_and_namespace node
          block.call context, :implements, { name: name, type: :module, namespace: namespace }
        end
      end
    end
  end
end
