require_relative 'resolve_strategy'

module Exploration

  # The SimpleResolveStrategy assumes any vertex with the same name  and a namespace that includes or is included by the other represents the same entity regardless of the namespace of the entity or paths where the entity is declared.
  class SimpleResolveStrategy < ResolveStrategy

    # Returns true if v1 and v2 represent the same vertex based on the Simple Resolve Strategy
    # v1, v2 are Vertex objects
    def is_same? v1, v2
      v1.name.eql?(v2.name) && (
                                v1.namespace.is_included_by?(v2.namespace) ||
                                v1.namespace.does_include?(v2.namespace)
                                )
    end
  end
end
