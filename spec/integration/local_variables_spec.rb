require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Local Variables" do
  include GraphGeneratorHelper

  let(:foo) { Graph::Vertex.new('Foo', :class) }
  let(:bar) { Graph::Vertex.new('Bar', :class) }

  it "generates single class with local variable dependency" do
    graph = generate_graph "class Foo; def hello; return Bar.new; end; end"
    foo.add_edge Graph::Edge.new(:dependency), bar
    expect(graph.each.to_a).to match_array [foo, bar]
  end

  it "generates single module with local variable dependency" do
    graph = generate_graph "module Foo; def hello; return Bar.new; end; end"
    foo.type = :module
    foo.add_edge Graph::Edge.new(:dependency), bar
    expect(graph.each.to_a).to match_array [foo, bar]
  end
end
