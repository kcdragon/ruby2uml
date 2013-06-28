require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Ruby Programs With Block Wrappers" do
  include GraphGeneratorHelper

  it "generates graph that begins with require statements" do
    program = "require 'set'; class Foo; end"
    graph = generate_graph program
    foo = Graph::Vertex.new 'Foo', :class
    expect { |b| graph.each(&b) }.to yield_successive_args foo
  end

  it "generates a graph with multiple classes"

end
