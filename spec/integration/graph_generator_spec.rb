require_relative '../../lib/exploration/explorer_builder'
require_relative '../../lib/graph/namespace'
require_relative '../../lib/graph/vertex'
require_relative '../../lib/graph_generator'
require_relative '../../lib/sexp_factory'

describe GraphGenerator do
  def generate_graph *programs
    sf = SexpFactory.instance
    explorer = Exploration::ExplorerBuilder.instance.build_ruby_explorer
    generator = GraphGenerator.new
    programs.each do |p|
      sexp = sf.get_sexp p, 'rb'
      generator.process_sexp explorer, sexp
    end
    generator.graph
  end

  it "generates a graph with class inside one module" do
    program = <<-EOS
      module Foo
        class Bar
        end
      end
    EOS

    graph = generate_graph program

    foo = Graph::Vertex.new('Foo')
    foo.type = :module
    bar = Graph::Vertex.new('Bar')
    bar.type = :class
    bar.namespace = Graph::Namespace.new ['Foo']

    expect(graph.each.to_a).to match_array [foo, bar]
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
    bar = Graph::Vertex.new 'Bar', :module
    bar.namespace = Graph::Namespace.new ['Foo']
    hello = Graph::Vertex.new 'Hello', :class
    hello.namespace = Graph::Namespace.new ['Foo', 'Bar']

    expect(graph.each.to_a).to match_array [foo, bar, hello]
  end

  it "rereferences references to a merged vertex" do
    program1 = "class Foo; def hello; Hello.world; end; end"
    program2 = "module Bar; class Hello; end; end"

    foo = Graph::Vertex.new 'Foo', :class
    hello = Graph::Vertex.new 'Hello', :class
    hello.namespace = Graph::Namespace.new ['Bar']
    bar = Graph::Vertex.new 'Bar', :module

    foo.add_edge Graph::Edge.new(:dependency), hello

    graph = Graph::Digraph.new
    graph.add_vertex foo
    graph.add_vertex hello
    graph.add_vertex bar

    expect(generate_graph(program1, program2)).to eq graph
  end

  it "generates a graph with multiple classes"
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
  it "generates a graph with including a module"
  it "generates a graph with instance variables one to many"

end
