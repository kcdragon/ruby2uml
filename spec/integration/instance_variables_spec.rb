require 'spec_helper'
require 'graph/edge'
require 'graph/vertex'
require_relative 'graph_generator_helper'

describe "Instance Variables" do
  include GraphGeneratorHelper

  let(:foo) { Vertex.new('Foo', :class) }
  let(:bar) { Vertex.new('Bar', :class) }
  let(:initialize) { Vertex.new('initialize', :method) }

  context "single class one to one instance variable" do
    it "graph contains class and aggregate class with aggregation relation" do
      graph = generate_graph "class Foo; def initialize; @bar = Bar.new; end; end"
      foo.add_edge Edge.new(:aggregation), bar
      foo.add_edge Edge.new(:dependency), bar # TODO aggregation is also a dependency, might want to fix this by only making this aggregation
      foo.add_edge Edge.new(:defines), initialize
      expect(graph.each.to_a).to match_array [foo, bar, initialize]
    end
  end

  it "generates single class with one to many instance variable"
end
