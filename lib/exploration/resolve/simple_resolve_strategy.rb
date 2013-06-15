require_relative 'resolve_strategy'

module Exploration
  # The SimpleNameResolveStrategy assumes any vertex with the same name represents the same entity regardless of the namespace of the entity or paths where the entity is declared.
  class SimpleResolveStrategy < ResolveStrategy
    def resolve graph
      
    end
  end
end
