require_relative 'edge'

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
      raise "#{edge_type} of type #{edge_type.class} is not a valid edge type" if not @edge_map.include? edge_type
      @edge_map[edge_type]
    end
  end
end
