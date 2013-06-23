require_relative '../../lib/exploration/resolve/resolve_strategy'
require_relative '../../lib/graph/edge'
require_relative '../../lib/graph/vertex'

describe Exploration::ResolveStrategy do
  it { respond_to :merge_vertices }

  def create_vertex name, namespace=[], paths=[]
    v = Graph::Vertex.new(name, :class)
    v.namespace = Graph::Namespace.new(namespace)
    v.paths = paths
    v
  end

  it "should merge vertices" do
    one = create_vertex 'foo', []
    two = create_vertex 'foo', ['m2']
    three = create_vertex 'foo', ['m1', 'm2']
    expect(
           subject.merge_vertices(one, two, three)
           ).to eq create_vertex('foo', ['m1', 'm2'])
  end

  context "vertex and other vertex have edges" do
    let(:vertex) { create_vertex 'Foo', ['M'] }
    let(:other) { create_vertex 'Foo', ['M'] }
    let(:dependent) { create_vertex 'Bar' }

    context "when edges are different" do
      it "adds both edges" do
        vertex.add_edge Graph::Edge.new(:generalization), dependent
        other.add_edge Graph::Edge.new(:dependency), dependent
        
        merged = subject.merge_vertices(vertex, other)

        generalizations = merged.get_edge(Graph::Edge.new(:generalization)).to_a
        expect(generalizations).to match_array [dependent]
        expect(generalizations.count).to eq 1

        dependencies = merged.get_edge(Graph::Edge.new(:dependency)).to_a
        expect(dependencies).to match_array [dependent]
        expect(dependencies.count).to eq 1
      end
    end
    
    context "when edges are the same" do
      it "adds only one edge" do
        vertex.add_edge Graph::Edge.new(:dependency), dependent
        other.add_edge Graph::Edge.new(:dependency), dependent
        
        merged = subject.merge_vertices(vertex, other)

        dependencies = merged.get_edge(Graph::Edge.new(:dependency)).to_a
        expect(dependencies).to match_array [dependent]
        expect(dependencies.count).to eq 1
      end
    end
  end

  context "when another vertex references a merged vertex" do
    it "re-references vertex to reference merged vertex" do
      vertex = create_vertex 'Foo'
      other = create_vertex 'Foo', ['M']
      
      bar = create_vertex 'Bar'
      bar.add_edge Graph::Edge.new(:dependency), vertex

      merged = subject.merge_vertices(vertex, other)
      subject.rereference_incoming_edges merged, vertex, other

      dependencies = bar.get_edge(Graph::Edge.new(:dependency)).to_a
      expect(dependencies).to match_array [merged]
      expect(dependencies.count).to eq 1
    end
  end
end
