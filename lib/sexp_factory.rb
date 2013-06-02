require 'ruby_parser'

class SexpFactory
  
  def self.instance
    @@instance ||= SexpFactory.new
  end

  def initialize
    @ext_map = Hash.new
    rb_parser = RubyParser.new
    @ext_map['rb'] = lambda { |program| rb_parser.parse program }
  end

  # Returns a Sexp representation of the program
  # = +Sexp+
  # Params:
  # +program+:: string containing a program to be converted to s-expression
  # +ext+:: string for file extensions of the program
  def get_sexp program, ext
    @ext_map[ext].call program
  end
end
