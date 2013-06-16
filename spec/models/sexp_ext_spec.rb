require 'ruby_parser'
require_relative '../../lib/sexp_ext'

describe Sexp do
  let(:parser) { RubyParser.new }

  describe ".each_child" do
    context "when there is one child" do
      it "child is a defn" do
        defn_program = "def say_hello; puts 'hello'; end"
        program = "class Hello; #{defn_program}; end"

        sexp = parser.parse program
        defn = parser.parse defn_program
        expect { |b| sexp.each_child(&b) }.to yield_with_args defn
      end
      
      it "child is a class" do
        class_program = "class Bar; end"
        program = "module Foo; #{class_program}; end"
        
        sexp = parser.parse program
        klass = parser.parse class_program
        expect { |b| sexp.each_child(&b) }.to yield_with_args klass
      end

      it "child is a module" do
        module_program = "module Bar; end"
        program = "module Foo; #{module_program}; end"
        
        sexp = parser.parse program
        mod = parser.parse module_program
        expect { |b| sexp.each_child(&b) }.to yield_with_args mod
      end
    end

    context "when there is multiple children" do
      it "children are defn in class" do
        defn_programs = [
                 "def say_hello; puts 'hello'; end",
                 "def wazzup; puts 'wazzup'; end",
                 "def each(&block); block.call('hello'); end"
                ]
        program = "class Hello; #{defn_programs.join ';'}; end"

        sexp = parser.parse program
        defns = defn_programs.map { |p| parser.parse p }
        expect { |b| sexp.each_child(&b) }.to yield_successive_args defns[0], defns[1], defns[2]
      end

      it "children are classes in a module" do
        class_programs = [
                 "class Foo; end",
                 "class Bar; def initialize; @a = Array.new; end; end",
                 "class Kenneth; def each(&block); block.call(\"what's the frequency, kenneth?\"); end; end"
                ]
        program = "module Hello; #{class_programs.join ';'}; end"

        sexp = parser.parse program
        classes = class_programs.map { |p| parser.parse p }
        expect { |b| sexp.each_child(&b) }.to yield_successive_args classes[0], classes[1], classes[2]
      end

      it "children are a mix of defn, classes, and modules" do
        child_programs = [
                 "def hello; puts 'hello'; end",
                 "class Bar; def initialize; @a = Array.new; end; end",
                 "module Foo; def a; return \"what's the frequency, kenneth?\"; end; end"
                ]
        program = "module Hello; #{child_programs.join ';'}; end"

        sexp = parser.parse program
        children = child_programs.map { |p| parser.parse p }
        expect { |b| sexp.each_child(&b) }.to yield_successive_args children[0], children[1], children[2]
      end
    end
  end
end
