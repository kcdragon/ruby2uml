require_relative '../../lib/graph/digraph'
require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'

include Graph

describe Digraph do
  before :all do
    @digraph = Digraph.new
    @vertices = []
    ['one', 'two', 'three'].each { |s| @vertices << Vertex.new(s) }
  end
  subject { @digraph }

  it { should respond_to :get_vertex }
  it { should respond_to :has_vertex? }
  it { should respond_to :add_vertex }

  it "should add vertex" do
    lambda {
      subject.add_vertex @vertices[0]
    }.should change { subject.has_vertex? 'one' }.from(false).to(true)
  end

  it "should enumerate vertices" do
    subject.add_vertex @vertices[1]
    subject.add_vertex @vertices[2]
    subject.each { |name, vertex| @vertices.should include(vertex) }
    subject.each_vertex { |vertex| @vertices.should include(vertex) }
  end
end
