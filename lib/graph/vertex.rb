require 'set'

require_relative 'namespace'

class Vertex
  include Enumerable

  attr_accessor :name, :namespace, :paths, :type
  
  def initialize name, type, namespace=[]
    @name = name
    @type = type
    @namespace = Namespace.new namespace
    @paths = Array.new

    @outgoing = Hash.new
    @incoming = Hash.new
  end

  def get_edge edge
    @outgoing[edge] = Set.new if !@outgoing.has_key? edge
    @outgoing[edge]
  end
  alias_method :[], :get_edge

  def add_edge edge, vertex
    @outgoing[edge] = Set.new if !@outgoing.has_key? edge
    @outgoing[edge] << vertex

    vertex.add_incoming_edge edge, self
  end

  def remove_edge edge, vertex
    @outgoing[edge].delete vertex
    vertex.remove_incoming_edge edge, self
  end

  def each &block
    @outgoing.each &block
  end
  alias_method :each_outgoing, :each

  def each_incoming &block
    @incoming.each &block
  end

  def eql? obj
    self.class.eql?(obj.class) &&
      self.name.eql?(obj.name) &&
      self.namespace.eql?(obj.namespace) &&
      Set.new(self.each.to_a).eql?(Set.new(obj.each.to_a)) &&
      self.paths.eql?(obj.paths) &&
      self.type.eql?(obj.type)
  end
  alias_method :==, :eql?

  def hash
    @name.hash
  end

  def fully_qualified_name delimiter
    ns = self.namespace.join delimiter
    ns << delimiter if ns != ''
    ns + self.name
  end

  def to_s
    string = fully_qualified_name '::'
    string += "~#{type}\n"
    @outgoing.each do |edge, set|
      string << "\t#{edge.to_s}: [ "
      set.each do |v|
        string << "#{v.namespace.to_s}#{'::' if v.namespace.to_s != ''}#{v.name.to_s},"
      end
      string << "]\n"
    end
    return string.chomp
  end

  protected
  def add_incoming_edge edge, vertex
    @incoming[edge] = Set.new if !@incoming.has_key? edge
    @incoming[edge] << vertex
  end

  def remove_incoming_edge edge, vertex
    @incoming[edge].delete vertex if @incoming.has_key? edge
  end
end
