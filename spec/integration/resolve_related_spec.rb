require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Resolve-related" do
  include GraphGeneratorHelper

  it "rereferences references to a merged vertex" do
    program1 = "class Foo; def hello; Hello.world; end; end"
    program2 = "module Bar; class Hello; end; end"

    foo = Graph::Vertex.new 'Foo', :class
    hello = Graph::Vertex.new 'Hello', :class, ['Bar']
    bar = Graph::Vertex.new 'Bar', :module

    foo.add_edge Graph::Edge.new(:dependency), hello

    graph = Graph::Digraph.new
    graph.add_vertex foo
    graph.add_vertex hello
    graph.add_vertex bar

    expect(generate_graph(program1, program2)).to eq graph
  end
end
