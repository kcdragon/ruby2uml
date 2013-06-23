require_relative '../../lib/exploration/resolve/resolve_strategy'
require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'

describe Exploration::ResolveStrategy do
  it { respond_to? :merge_vertices }
  it { respond_to? :rereference_incoming_edges! }

  def create_vertex name, namespace=[], paths=[]
    v = Graph::Vertex.new(name, :class)
    v.namespace = Graph::Namespace.new(namespace)
    v.paths = paths
    v
  end

  let(:foo) { create_vertex 'Foo' }
  let(:m_foo) { create_vertex 'Foo', ['M'] }
  let(:bar) { create_vertex 'Bar' }
  let(:edge) { Graph::Edge.new(:dependency) }
  let(:edge2) { Graph::Edge.new(:generalization) }

  describe ".merge_vertices" do
    it "merges different edges" do
      foo.add_edge edge2, bar
      m_foo.add_edge edge, bar

      merged = subject.merge_vertices(foo, m_foo)

      expect(merged.get_edge(edge2).to_a).to match_array [bar]
      expect(merged.get_edge(edge).to_a).to match_array [bar]
    end

    it "merges only one edge when there are two of the same edges" do
      foo.add_edge edge2, bar
      m_foo.add_edge edge, bar

      merged = subject.merge_vertices(foo, m_foo)

      expect(merged.get_edge(edge).to_a).to match_array [bar]
    end
  end

  describe ".rereference_incoming_edges!" do
    let(:car) { create_vertex 'Car' }

    def merge_and_rereference *vertices
      merged = subject.merge_vertices *vertices
      subject.rereference_incoming_edges! merged, *vertices
      merged
    end
    
    it "re-references no edges" do
      bar.add_edge edge, car
      merged = merge_and_rereference foo, m_foo
      expect(bar.get_edge(edge).to_a).to match_array [car]
    end

    it "re-references one edge for one vertex" do
      bar.add_edge edge, foo
      merged = merge_and_rereference foo, m_foo
      expect(bar.get_edge(edge).to_a).to match_array [merged]
    end

    it "re-references one edge for multiple vertices" do
      bar.add_edge edge, foo
      car.add_edge edge, foo
      merged = merge_and_rereference foo, m_foo
      expect(bar.get_edge(edge).to_a).to match_array [merged]
      expect(car.get_edge(edge).to_a).to match_array [merged]
    end

    it "re-references multiple edges for one vertex" do
      bar.add_edge edge, foo
      bar.add_edge edge2, foo
      merged = merge_and_rereference foo, m_foo
      expect(bar.get_edge(edge).to_a).to match_array [merged]
      expect(bar.get_edge(edge2).to_a).to match_array [merged]
    end
  end
end
