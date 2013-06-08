module Graph
  class EdgeFactory # Flyweight Factory
    def self.instance
      @@instance ||= EdgeFactory.new
    end

    def initialize
      @edge_map = Hash.new # only need a single instance of each type of edge since their state will always be the same regardless of the context
      @edge_map[:aggregation] = AggregationEdge.new
      @edge_map[:composition] = CompositionEdge.new
      @edge_map[:implements] = ImplementsEdge.new
      @edge_map[:generalization] = GeneralizationEdge.new
      @edge_map[:dependency] = DependencyEdge.new
    end

    def get_edge edge_type
      @edge_map[edge_type]
    end
  end
  
  class Edge
    def eql? object
      object.kind_of?(self.class)
    end

    def hash
      1
    end
  end

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
