require_relative 'relation'

module Exploration
  class DependencyRelation < Relation
    def each sexp, context=nil, &block
      # REFACTOR extract this to superclass method
      sexp.each_of_type(:call) do |call_node|
        call_node.rest.each_of_type(:const) do |dependency_node|
          dependency_name = dependency_node.rest.head.to_s
          yield_wrapper = lambda { return context[:name], context[:type], :dependency, dependency_name, :class }
          if block_given?
            block.call yield_wrapper.call
          else
            yield yield_wrapper.call
          end
        end
      end
    end
  end
end
