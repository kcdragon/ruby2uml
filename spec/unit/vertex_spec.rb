require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/namespace'
require_relative '../../lib/graph/vertex'

describe Graph::Vertex do

  let(:vertex) do
    g = Graph::Vertex.new 'foo', :class
    g.namespace = Graph::Namespace.new ['ns']
    g
  end
  subject { vertex }

  it { should respond_to :name }
  it { should respond_to :namespace }
  it { should respond_to :add_edge }
  it { should respond_to :get_edge }
  it { should respond_to :[] }

  describe ".add_edge" do
    it "add aggregation edge" do
      another_vertex = Graph::Vertex.new 'bar', :class
      edge = Graph::Edge.new :aggregation
      lambda {
        subject.add_edge edge, another_vertex
      }.should change(subject[Graph::Edge.new(:aggregation)], :count).by(1)
    end
  end

  describe ".eql?" do
    it "equates equal vertices" do
      v = Graph::Vertex.new 'foo', :class
      v.namespace = Graph::Namespace.new ['ns']
      expect(subject.eql?(v)).to be_true
    end
  end

  describe ".each" do
    it "enumerate edges" do
      one = Graph::Vertex.new 'one', :class
      two = Graph::Vertex.new 'two', :class
      three = Graph::Vertex.new 'three', :class
      subject.add_edge Graph::Edge.new(:generalization), one
      subject.add_edge Graph::Edge.new(:aggregation), two
      subject.add_edge Graph::Edge.new(:aggregation), three

      expect { |b| subject.each &b }.to yield_successive_args(
                                                              [Graph::Edge.new(:generalization), Set.new([one])],
                                                              [Graph::Edge.new(:aggregation), Set.new([two, three])]
                                                              )
    end
  end
end
