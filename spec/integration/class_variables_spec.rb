require 'spec_helper'
require 'graph/edge'
require 'graph/vertex'
require_relative 'graph_generator_helper'

describe "Class Variables" do
  include GraphGeneratorHelper

  let(:foo) { Vertex.new('Foo', :class) }
  let(:bar) { Vertex.new('Bar', :class) }
  let(:hello) { Vertex.new('hello', :method) }

  it "generates single class with one to one class variable" do
    graph = generate_graph "class Foo; def self.hello; @@bar = Bar.new; end; end"
    foo.add_edge Edge.new(:aggregation), bar
    foo.add_edge Edge.new(:dependency), bar # TODO aggregation is also a dependency, might want to fix this by only making this aggregation
    foo.add_edge Edge.new(:defines), hello
    expect(graph.each.to_a).to match_array [foo, bar, hello]
  end

  it "generates single class with one to many class variable"
end
