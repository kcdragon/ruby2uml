require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Instance Variables" do
  include GraphGeneratorHelper

  let(:foo) { Graph::Vertex.new('Foo', :class) }
  let(:bar) { Graph::Vertex.new('Bar', :class) }

  context "single class one to one instance variable" do
    it "graph contains class and aggregate class with aggregation relation" do
      graph = generate_graph "class Foo; def initialize; @bar = Bar.new; end; end"
      foo.add_edge Graph::Edge.new(:aggregation), bar
      foo.add_edge Graph::Edge.new(:dependency), bar # TODO aggregation is also a dependency, might want to fix this by only making this aggregation
      expect(graph.each.to_a).to match_array [foo, bar]
    end
  end

  it "generates single class with one to many instance variable"
end
