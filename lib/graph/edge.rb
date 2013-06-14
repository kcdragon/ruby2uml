module Graph
  class Edge
    def eql? object
      object.kind_of?(self.class)
    end
    
    # REFACTOR move hash method to subclasses and have a different hash value for each subclass
    def hash
      1
    end
  end

  # REFACTOR consider using strategy/state instead of subclassing edge

  class AggregationEdge < Edge
    def to_s
      'aggregates'
    end
  end

  class CompositionEdge < Edge
    def to_s
      'composes'
    end
  end

  class ImplementsEdge < Edge
    def to_s
      'implements'
    end
  end

  class GeneralizationEdge < Edge
    def to_s
      'generalizes'
    end
  end

  class DependencyEdge < Edge
    def to_s
      'depends on'
    end
  end
end
