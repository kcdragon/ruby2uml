require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Inheritance" do
  include GraphGeneratorHelper

  let(:foo) { Graph::Vertex.new('Foo', :class) }
  let(:bar) { Graph::Vertex.new('Bar', :class) }

  context "single class with inheritance" do
    it "graph contains class and inherited class with generalization relation" do
      graph = generate_graph "class Foo < Bar ; end"
      foo.add_edge Graph::Edge.new(:generalization), bar
      expect(graph.each.to_a).to match_array [foo, bar]
    end
  end
end
