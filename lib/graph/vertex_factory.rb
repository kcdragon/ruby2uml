require_relative 'vertex'

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
end
