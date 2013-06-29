require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'
require_relative 'graph_generator_helper'

describe "Ruby Programs with include" do
  include GraphGeneratorHelper

  let(:foo) { Graph::Vertex.new('Foo', :class) }
  let(:bar) { Graph::Vertex.new('Bar', :module) }
  let(:baz) { Graph::Vertex.new('Baz', :module) }
  
  context "class has single include" do
    let(:graph) { generate_graph "class Foo; include Bar; end" }
  
    it "graph contains class and included module with implements relationship" do
      foo.add_edge Graph::Edge.new(:implements), bar
      expect { |b| graph.each(&b) }.to yield_successive_args foo, bar
    end
  end

  context "class has multiple includes" do
    let(:graph) { generate_graph "class Foo; include Bar; include Baz; end" }

    it "graph contains class and included modules with implements relationships" do
      foo.add_edge Graph::Edge.new(:implements), bar
      foo.add_edge Graph::Edge.new(:implements), baz
      expect(graph.each.to_a).to match_array [foo, bar, baz]
    end
  end

  context "module has single include" do
    let(:graph) { generate_graph "module Bar; include Baz; end" }

    it "graph contains module and included module with implements relationship" do
      bar.add_edge Graph::Edge.new(:implements), baz
      expect(graph.each.to_a).to match_array [bar, baz]
    end
  end

  context "module has multiple includes" do
    let(:graph) { generate_graph "module Bar; include Baz; include Car; end" }

    it "graph contains module and included modules with implements relationships" do
      car = Graph::Vertex.new 'Car', :module
      bar.add_edge Graph::Edge.new(:implements), baz
      bar.add_edge Graph::Edge.new(:implements), car
      expect(graph.each.to_a).to match_array [bar, baz, car]
    end
  end
end
