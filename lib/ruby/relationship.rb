require_relative '../graph/edge'

module Ruby
  class Relationship
    def initialize
      @ef = Graph::EdgeFactory.instance
    end
  end
end
