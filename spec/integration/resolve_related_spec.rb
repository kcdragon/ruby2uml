require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Resolve-related" do
  include GraphGeneratorHelper

  it "rereferences references to a merged vertex" do
    program1 = "class Foo; def say_hello; Hello.world; end; end"
    program2 = "module Bar; class Hello; end; end"

    foo = Vertex.new 'Foo', :class
    say_hello = Vertex.new 'say_hello', :method
    hello = Vertex.new 'Hello', :class, ['Bar']
    bar = Vertex.new 'Bar', :module

    foo.add_edge Edge.new(:dependency), hello
    foo.add_edge Edge.new(:defines), say_hello

    graph = Digraph.new
    graph.add_vertex foo
    graph.add_vertex say_hello
    graph.add_vertex hello
    graph.add_vertex bar

    expect(generate_graph(program1, program2)).to eq graph
  end
end
