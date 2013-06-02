require 'set'

module Graph
  class Vertex
    include Enumerable

    attr_reader :name
    
    def initialize name
      @name = name
      @edges = Hash.new(Set.new)
    end

    def get_edge edge
      @edges[edge]
    end
    alias_method :[], :get_edge

    def add_edge edge, vertex
      @edges[edge] << vertex
    end

    def each &block
      @edges.each { |edge, set| yield edge, set }
    end
  end

  class ClassVertex < Vertex
  end
end
