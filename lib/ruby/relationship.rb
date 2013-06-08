require_relative '../graph/edge'

module Ruby
  class Relationship
    attr_writer :explorer

    def initialize
      @ef = Graph::EdgeFactory.instance
    end
  end
end
