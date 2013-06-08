require_relative '../graph/edge'
require_relative '../graph/vertex'

require_relative 'relationship'

module Ruby
  class DependencyRelationship < Relationship
    def each sexp, &block
      # REFACTOR extract this to superclass method
      sexp.each_of_type(:call) do |call_node|
        call_node.rest.each_of_type(:const) do |dependency_node|
          dependency_name = dependency_node.rest.head.to_s
           yield_wrapper = lambda { return dependency_name, Graph::ClassVertex, @ef.get_edge(:dependency) }
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
