require_relative '../../lib/exploration/resolve/simple_resolve_strategy'
require_relative '../../lib/graph/digraph'
require_relative '../../lib/graph/vertex'

describe Exploration::SimpleResolveStrategy do
  let(:vertex) { Graph::Vertex.new 'Foo', :class, ['M'] }
  
  it { respond_to :is_same? }
  it { respond_to :merge_vertices }

  context "is the same as other vertex" do
    let(:other) { Graph::Vertex.new('Foo', :class) }

    it "includes other vertex" do
      other.namespace = Graph::Namespace.new []
      expect(subject.is_same?(vertex, other)).to be_true
    end

    it "included by other vertex" do
      other.namespace = Graph::Namespace.new ['L', 'M']
      expect(subject.is_same?(vertex, other)).to be_true
    end

    it "same module as other vertex" do
      other.namespace = Graph::Namespace.new ['M']
      expect(subject.is_same?(vertex, other)).to be_true
    end
  end

  context "is not the same as other vertex" do
    it "has same number of modules but are different" do
      other = Graph::Vertex.new 'Foo', :class
      other.namespace = Graph::Namespace.new ['N']

      expect(subject.is_same?(vertex, other)).to be_false
    end
  end
end
