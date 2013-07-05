require 'spec_helper'
require 'graph/edge'
require 'graph/vertex'
require_relative 'graph_generator_helper'

describe "Inheritance" do
  include GraphGeneratorHelper

  let(:foo) { Vertex.new('Foo', :class) }
  let(:bar) { Vertex.new('Bar', :class) }

  context "single class with inheritance" do
    it "graph contains class and inherited class with generalization relation" do
      graph = generate_graph "class Foo < Bar ; end"
      foo.add_edge Edge.new(:generalization), bar
      expect(graph.each.to_a).to match_array [foo, bar]
    end
  end
end
