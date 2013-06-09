require_relative '../../lib/graph/edge_factory'
require_relative '../../lib/graph/vertex'

describe Graph::Vertex do
  before :all do
    @vertex = Graph::Vertex.new 'foo'
  end
  subject { @vertex }

  it { should respond_to :name }
  it { should respond_to :add_edge }
  it { should respond_to :get_edge }
  it { should respond_to :[] }

  it "should add aggregation edge" do
    ef = Graph::EdgeFactory.instance
    another_vertex = Graph::Vertex.new 'bar'
    edge = ef.get_edge :aggregation
    lambda {
      subject.add_edge edge, another_vertex
    }.should change(subject[ef.get_edge :aggregation], :count).by(1)
  end
end
