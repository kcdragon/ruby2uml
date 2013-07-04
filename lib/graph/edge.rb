class Edge
  attr_accessor :type

  def initialize type
    @type = type
  end

  def eql? object
    self.type.eql?(object.type)
  end
  alias_method :==, :eql?
  
  def hash
    @type.hash
  end

  def to_s
    @type
  end
end
