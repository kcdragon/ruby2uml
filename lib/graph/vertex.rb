require 'set'

module Graph
  class Vertex
    include Enumerable

    attr_reader :name
    
    def initialize name
      @name = name
      @edges = Hash.new
    end

    def get_edge edge
      @edges[edge] = Set.new if !@edges.has_key? edge
      @edges[edge]
    end
    alias_method :[], :get_edge

    def add_edge edge, vertex
      @edges[edge] = Set.new if !@edges.has_key? edge
      @edges[edge] << vertex
    end

    def each &block
      @edges.each &block
    end
  end

  class ClassVertex < Vertex
    def to_s
      string = "class: #{@name}\n"
      @edges.each do |edge, set|
        string << "\t#{edge.to_s}: "
        set.each do |v|
          string << "#{v.name.to_s},"
        end
        string << "\n"
      end
      return string
    end
  end
end
