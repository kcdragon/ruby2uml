module Graph
  class Edge
    attr_accessor :type

    def initialize type
      @type = type
    end

    def eql? object
      object.kind_of?(self.class) && self.type.eql?(object.type)
    end
    
    def hash
      @type.hash
    end

    def to_s
      @type
    end
  end
end
