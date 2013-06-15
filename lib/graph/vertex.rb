require 'set'

require_relative 'namespace'

module Graph
  class Vertex
    include Enumerable

    attr_accessor :name,      # name of entity ex. 'Artist'
                  :namespace, # namespace the entity belongs to ex. ['Performer', 'Musician']
                  :paths      # path(s) the entity is declared ex. ['foo/bar/artist.rb']
    
    def initialize name
      @name = name
      @namespace = Namespace.new []
      @paths = Array.new
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

    def to_s
      string = "#{type}: #{@name}\n"
      string << "\tnamespace: #{namespace}"
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

  # REFACTOR consider using strategy/state instead of subclassing vertex

  class ClassVertex < Vertex
    def type
      'class'
    end
  end

  class ModuleVertex < Vertex
    def type
      'module'
    end
  end
end
