require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Classes and Modules w/ Namespaces" do
  include GraphGeneratorHelper

  let(:foo) { Graph::Vertex.new('Foo', :module) }
  let(:bar) { Graph::Vertex.new('Bar', :class, ['Foo']) }
  let(:baz) { Graph::Vertex.new('Baz', :class) }
  let(:hello) { Graph::Vertex.new('hello', :method) }

  it "generates single class with local variable dependency" do
    graph = generate_graph "module Foo; class Bar; def hello; return Baz.new; end; end; end"
    bar.add_edge Graph::Edge.new(:dependency), baz
    bar.add_edge Graph::Edge.new(:defines), hello
    expect(graph.each.to_a).to match_array [foo, bar, baz, hello]
  end

  it "generates a graph with class inside one module" do
    program = <<-EOS
      module Foo
        class Bar
        end
      end
    EOS

    graph = generate_graph program

    foo = Graph::Vertex.new 'Foo', :module
    bar = Graph::Vertex.new 'Bar', :class, ['Foo']

    expect { |b| graph.each(&b) }.to yield_successive_args foo, bar
  end

  it "generates a graph with class inside two modules" do
    program = <<-EOS
      module Foo
        module Bar
          class Hello
          end
        end
      end
    EOS
    graph = generate_graph program

    foo = Graph::Vertex.new 'Foo', :module
    bar = Graph::Vertex.new 'Bar', :module, ['Foo']
    hello = Graph::Vertex.new 'Hello', :class, ['Foo', 'Bar']

    expect { |b| graph.each(&b) }.to yield_successive_args foo, bar, hello
  end

  it "generates a graph for multiple programs w/ and w/o namespaces" do
    program1 = <<-EOS
      module Music
        class Artist
         end
      end
    EOS

    program2 = <<-EOS
      class Album
        def initialize
          @artist = Artist.new
        end
      end
    EOS
  end
end
