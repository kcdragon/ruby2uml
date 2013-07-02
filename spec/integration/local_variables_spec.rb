require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Local Variables" do
  include GraphGeneratorHelper

  let(:foo) { Graph::Vertex.new('Foo', :class) }
  let(:bar) { Graph::Vertex.new('Bar', :class) }
  let(:hello) { Graph::Vertex.new('hello', :method) }

  it "generates single class with local variable dependency" do
    graph = generate_graph "class Foo; def hello; return Bar.new; end; end"
    foo.add_edge Graph::Edge.new(:dependency), bar
    foo.add_edge Graph::Edge.new(:defines), hello
    expect(graph.each.to_a).to match_array [foo, bar, hello]
  end

  it "generates single module with local variable dependency" do
    graph = generate_graph "module Foo; def hello; return Bar.new; end; end"
    foo.type = :module
    foo.add_edge Graph::Edge.new(:dependency), bar
    foo.add_edge Graph::Edge.new(:defines), hello
    expect(graph.each.to_a).to match_array [foo, bar, hello]
  end
end
