require_relative '../../lib/graph/edge_factory'
require_relative '../../lib/graph/vertex'

describe Graph::Vertex do
  before :each do
    @vertex = Graph::Vertex.new 'foo'
    @ef = Graph::EdgeFactory.instance
  end
  subject { @vertex }

  it { should respond_to :name }
  it { should respond_to :namespace }
  it { should respond_to :add_edge }
  it { should respond_to :get_edge }
  it { should respond_to :[] }

  it "add aggregation edge" do
    another_vertex = Graph::Vertex.new 'bar'
    edge = @ef.get_edge :aggregation
    lambda {
      subject.add_edge edge, another_vertex
    }.should change(subject[@ef.get_edge :aggregation], :count).by(1)
  end

  it "enumerate edges" do
    @one = Graph::ClassVertex.new 'one'
    @two = Graph::ClassVertex.new 'two'
    @three = Graph::ClassVertex.new 'three'
    @vertex.add_edge @ef.get_edge(:generalization), @one
    @vertex.add_edge @ef.get_edge(:aggregation), @two
    @vertex.add_edge @ef.get_edge(:aggregation), @three
    
    actual_gen = Array.new
    actual_agg = Array.new
    @vertex.each do |edge, set|
      if edge.eql? @ef.get_edge(:generalization)
        actual_gen.concat set.to_a
      elsif edge.eql? @ef.get_edge(:aggregation)
        actual_agg.concat set.to_a
      end
    end
    
    expect(actual_gen).to match_array([@one])
    expect(actual_agg).to match_array([@two, @three])
  end
end
