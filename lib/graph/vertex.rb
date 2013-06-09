require 'set'

module Graph
  class VertexFactory
    def self.instance
      @@instance ||= VertexFactory.new
    end

    def initialize
      @vertices = Hash.new
      @vertices[:class] = lambda { |name| ClassVertex.new name }
    end

    def get_vertex name, type
      raise "#{type} is not a valid vertex type" if not @vertices.include? type
      @vertices[type].call(name)
    end
  end
  
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
