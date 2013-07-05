require 'spec_helper'
require 'graph/vertex'
require_relative 'graph_generator_helper'

# When a program has multiple elements on the top level (i.e. two classes not nested in a module, require statements followed by a class), the whole program is wrapped in a block when a Sexp is generated. These specs test programs that have a block wrapping the whole program.
describe "Block Wrappers" do
  include GraphGeneratorHelper

  let(:foo) { Vertex.new 'Foo', :class }
  let(:bar) { Vertex.new 'Bar', :class }

  it "generates graph that begins with require statements" do
    program = "require 'set'; class Foo; end"
    graph = generate_graph program
    expect(graph.each.to_a).to match_array [foo]
  end

  it "generates a graph with multiple classes" do
    program = "class Foo; end; class Bar; end"
    graph = generate_graph program
    expect(graph.each.to_a).to match_array [foo, bar]
  end
end
