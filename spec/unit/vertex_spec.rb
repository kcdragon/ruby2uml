require_relative '../../lib/graph/vertex'

describe Graph::Vertex do
  before :each do
    @vertex = Graph::Vertex.new 'foo'
  end
  subject { @vertex }

  it { should respond_to :name }
  it { should respond_to :namespace }
  it { should respond_to :add_edge }
  it { should respond_to :get_edge }
  it { should respond_to :[] }

  it "add aggregation edge" do
    another_vertex = Graph::Vertex.new 'bar'
    edge = Graph::Edge.new :aggregation
    lambda {
      subject.add_edge edge, another_vertex
    }.should change(subject[Graph::Edge.new(:aggregation)], :count).by(1)
  end

  it "enumerate edges" do
    @one = Graph::Vertex.new 'one', :class
    @two = Graph::Vertex.new 'two', :class
    @three = Graph::Vertex.new 'three', :class
    @vertex.add_edge Graph::Edge.new(:generalization), @one
    @vertex.add_edge Graph::Edge.new(:aggregation), @two
    @vertex.add_edge Graph::Edge.new(:aggregation), @three
    
    actual_gen = Array.new
    actual_agg = Array.new
    @vertex.each do |edge, set|
      if edge.eql? Graph::Edge.new(:generalization)
        actual_gen.concat set.to_a
      elsif edge.eql? Graph::Edge.new(:aggregation)
        actual_agg.concat set.to_a
      end
    end
    
    expect(actual_gen).to match_array([@one])
    expect(actual_agg).to match_array([@two, @three])
  end
end
