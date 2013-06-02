module Graph
  class Digraph
    include Enumerable

    def initialize
      @vertices = Hash.new
    end

    def get_vertex vertex_name
      @vertices[vertex_name]
    end

    def has_vertex? vertex_name
      @vertices.has_key? vertex_name
    end

    def add_vertex vertex
      @vertices[vertex.name] = vertex
    end

    def each &block
      @vertices.each &block
    end

    def each_vertex &block
      @vertices.each_value &block
    end
  end
end
