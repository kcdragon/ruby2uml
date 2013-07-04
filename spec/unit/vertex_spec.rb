require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/namespace'
require_relative '../../lib/graph/vertex'

describe Vertex do

  let(:vertex) do
    v = Vertex.new 'foo', :class
    v.namespace = Namespace.new ['ns']
    v
  end
  subject { vertex }

  it { should respond_to :name }
  it { should respond_to :namespace }
  it { should respond_to :add_edge }
  it { should respond_to :get_edge }
  it { should respond_to :[] }

  describe ".add_edge" do
    it "add aggregation edge" do
      another_vertex = Vertex.new 'bar', :class
      edge = Edge.new :aggregation
      lambda {
        subject.add_edge edge, another_vertex
      }.should change(subject[Edge.new(:aggregation)], :count).by(1)
    end
  end

  describe ".fully_qualified_name" do
    context "when there is a namespace" do
      it "includes namespace and name, seperated by delimiter" do
        expect(subject.fully_qualified_name('::')).to eq 'ns::foo'
      end
    end
    
    context "when there is not a namespace" do
      it "only includes name and there is not delimiter" do
        v = Vertex.new 'Foo', :class
        expect(v.fully_qualified_name('::')).to eq 'Foo'
      end
    end
  end

  describe ".eql?" do
    it "equates equal vertices" do
      v = Vertex.new 'foo', :class, ['ns']
      expect(subject.eql?(v)).to be_true
    end
  end

  describe ".each" do
    it "enumerate edges" do
      one = Vertex.new 'one', :class
      two = Vertex.new 'two', :class
      three = Vertex.new 'three', :class
      subject.add_edge Edge.new(:generalization), one
      subject.add_edge Edge.new(:aggregation), two
      subject.add_edge Edge.new(:aggregation), three

      expect { |b| subject.each &b }.to yield_successive_args(
                                                              [Edge.new(:generalization), Set.new([one])],
                                                              [Edge.new(:aggregation), Set.new([two, three])]
                                                              )
    end
  end

  describe ".each_incoming" do
    it "enumerates incoming edges" do
      one = Vertex.new 'one', :class
      two = Vertex.new 'two', :class
      three = Vertex.new 'three', :class
      one.add_edge Edge.new(:generalization), subject
      two.add_edge Edge.new(:dependency), subject
      three.add_edge Edge.new(:dependency), subject

      expect { |b| subject.each_incoming &b }.to yield_successive_args(
                                                              [Edge.new(:generalization), Set.new([one])],
                                                              [Edge.new(:dependency), Set.new([two, three])]
                                                              )
    end
  end
end
