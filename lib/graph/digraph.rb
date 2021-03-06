require 'set'

class Digraph
  include Enumerable

  def initialize
    @vertices = Array.new
  end

  # Returns an Array of Vertices that match the name, namespace and path.
  def find_vertex name, namespace=nil, paths=nil # REFACTOR consider changing this to a Vertex object
    @vertices.select do |v|
      v.name == name &&
        (namespace.nil? || v.namespace.eql?(namespace)) &&
        (paths.nil? || (paths - v.paths).empty?) # checks to see if paths is a subset of v.paths
    end
  end

  # Returns true if self has a Vertex with the name +vertex_name+.
  def has_vertex? vertex_name
    !@vertices.select { |v| v.name == vertex_name }.empty?
  end

  def add_vertex vertex
    @vertices.push vertex
    vertex
  end

  def remove_vertex vertex
    @vertices.delete vertex
  end

  def each &block
    @vertices.each &block
  end

  def eql? obj
    Set.new(self.vertices).eql? Set.new(obj.vertices)
    
  end
  alias_method :==, :eql?
  
  protected
  attr_reader :vertices # needed for eql?
  public

  def to_s
    @vertices.map(&:to_s).join("\n")
  end
end
