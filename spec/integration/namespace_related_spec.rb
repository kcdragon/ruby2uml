require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Classes and Modules w/ Namespaces" do
  include GraphGeneratorHelper

  let(:foo) { Graph::Vertex.new('Foo', :module) }
  let(:bar) { Graph::Vertex.new('Bar', :class, ['Foo']) }
  let(:baz) { Graph::Vertex.new('Baz', :class) }

  it "generates single class with local variable dependency" do
    graph = generate_graph "module Foo; class Bar; def hello; return Baz.new; end; end; end"
    bar.add_edge Graph::Edge.new(:dependency), baz
    expect(graph.each.to_a).to match_array [foo, bar, baz]
  end
end
