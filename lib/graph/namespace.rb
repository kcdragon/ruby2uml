module Graph
  class Namespace
    include Enumerable

    def initialize array
      if array.is_a? Array
        @array = array.dup
      else
        @array = Array.new
      end
    end

    # Checks if the Namespace could be included by the other Namespace.
    # ex. B::C is included by A::B::C since B::C could belong to A
    # other is a Namespace object
    def is_included_by? other
      return false if self.count > other.count
      return true if self.eql? other
      return other.drop(other.count - self.count).to_a.eql? self.to_a
    end
    
    # Checks if the Namespace include the other Namespace.
    # ex. A::B::C includes B::C since B::C could belong to A
    # other is a Namespace object
    def does_include? other
      return false if other.count > self.count
      return true if self.eql? other
      return self.drop(self.count - other.count).to_a.eql? other.to_a
    end

    def size
      @array.count
    end

    def eql? other
      @array.eql?(other.to_a) && self.class.eql?(other.class)
    end
    alias_method :==, :eql?

    def hash
      @array.hash
    end

    # postcondition: order will be preserved
    def each &block
      @array.each &block
    end

    def to_s
      # TODO change delimiter based on language or find a language independent delimiter
      @array.join '::'
    end
  end
end
