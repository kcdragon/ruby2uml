require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'

include Graph

describe Vertex do
  before :all do
    @vertex = Vertex.new 'foo'
  end
  subject { @vertex }

  it { should respond_to :name }
  it { should respond_to :add_edge }
  it { should respond_to :get_edge }

  it "should add aggregation edge" do
    ef = EdgeFactory.instance
    another_vertex = Vertex.new 'bar'
    edge = ef.get_edge :aggregation
    lambda {
      subject.add_edge edge, another_vertex
    }.should change(subject[ef.get_edge :aggregation], :count).by(1)
  end
end
