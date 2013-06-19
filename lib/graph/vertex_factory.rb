require_relative 'vertex'

module Graph
  class VertexFactory
    def self.instance
      @@instance ||= VertexFactory.new
    end

    def initialize
      @vertices = Hash.new
      @vertices[:class] = lambda { |name| ClassVertex.new name }
      @vertices[:module] = lambda { |name| ModuleVertex.new name }
    end

    # Returns an instance of Vertex that corresponds to the given type.
    #
    # [params] - name is a String that will be the name of the Vertex returned
    #          - valid values for type are :class and :module
    def get_vertex name, type
      raise "#{type} is not a valid vertex type" if not @vertices.include? type
      @vertices[type].call(name)
    end
  end
end
