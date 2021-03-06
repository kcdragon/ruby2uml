require 'spec_helper'
require 'exploration/resolve/simple_resolve_strategy'
require 'graph/digraph'
require 'graph/vertex'

describe SimpleResolveStrategy do
  let(:vertex) { Vertex.new 'Foo', :class, ['M'] }
  
  it { respond_to :is_same? }
  it { respond_to :merge_vertices }

  context "is the same as other vertex" do
    let(:other) { Vertex.new('Foo', :class) }

    it "includes other vertex" do
      other.namespace = Namespace.new []
      expect(subject.is_same?(vertex, other)).to be_true
    end

    it "included by other vertex" do
      other.namespace = Namespace.new ['L', 'M']
      expect(subject.is_same?(vertex, other)).to be_true
    end

    it "same module as other vertex" do
      other.namespace = Namespace.new ['M']
      expect(subject.is_same?(vertex, other)).to be_true
    end
  end

  context "is not the same as other vertex" do
    it "has same number of modules but are different" do
      other = Vertex.new 'Foo', :class
      other.namespace = Namespace.new ['N']

      expect(subject.is_same?(vertex, other)).to be_false
    end
  end
end
