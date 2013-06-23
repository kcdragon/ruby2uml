require_relative '../../lib/graph/digraph'
require_relative '../../lib/graph/namespace'
require_relative '../../lib/graph/vertex'

describe Graph::Digraph do
  before :each do
    @digraph = Graph::Digraph.new
    @vertices = []
    ['one', 'two', 'three'].each { |s| @vertices << Graph::Vertex.new(s, :class) }
  end
  subject { @digraph }

  it { should respond_to :find_vertex }
  it { should respond_to :has_vertex? }
  it { should respond_to :add_vertex }
  it { should respond_to :remove_vertex }

  it "adds a vertex" do
    lambda {
      subject.add_vertex @vertices[0]
    }.should change { subject.has_vertex? 'one' }.from(false).to(true)
  end

  it "removes a vertex" do
    0.upto(2) { |i| subject.add_vertex @vertices[i] }
    lambda {
      subject.remove_vertex @vertices[1]
    }.should change { subject.has_vertex? 'two' }.from(true).to(false)
  end

  describe "finds the vertices that match" do
    before :each do
      create = lambda do |name, namespace|
        v = Graph::Vertex.new name, :class
        v.namespace = Graph::Namespace.new([namespace]) if !namespace.nil?
        return v
      end
      @digraph = Graph::Digraph.new
      @one = create.call('Bar', 'Foo')
      @two = create.call('Bar', nil)
      @three = create.call('World', 'Hello')
      @digraph.add_vertex @one
      @digraph.add_vertex @two
      @digraph.add_vertex @three
    end

    context "no vertices match" do
      it "not match when name doesn't exist" do
        expect(subject.find_vertex('Foo')).to be_empty
      end

      it "not match when namespace is incorrect" do
        expect(
               subject.find_vertex('Bar', Graph::Namespace.new(['Hello']))
               ).to be_empty
      end

      it "not match when path is incorrect"
    end

    context "there are vertices that match" do
      it "matches two with name" do
        expect(subject.find_vertex('Bar')).to match_array [@one, @two]
      end
      
      it "matches one with namespace" do
        expect(
               subject.find_vertex('World', Graph::Namespace.new(['Hello']))
               ).to match_array [@three]
      end

      it "matches with path"
    end
  end

  it "enumerates the vertices" do
    @vertices.each { |v| subject.add_vertex v }
    expect { |b| subject.each(&b) }.to yield_successive_args @vertices[0], @vertices[1], @vertices[2]
  end
end
