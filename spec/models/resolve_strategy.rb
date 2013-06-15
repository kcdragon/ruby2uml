require_relative '../../lib/exploration/resolve/resolve_strategy'
require_relative '../../lib/graph/vertex'

describe Exploration::ResolveStrategy do
  it { respond_to :merge_vertices }

  it "should merge vertices" do
    create_vertex = lambda do |name, namespace, paths|
      v = Graph::Vertex.new name
      v.namespace = namespace
      v.paths = paths
    end

    one = create_vertex.call 'foo', nil, nil
    two = create_vertex.call 'foo', ['m2'], nil
    three = create_vertex.call 'foo', ['m1', 'm2'], nil

    expect(
           subject.merge_vertices(one, two, three)
           ).to match_array create_vertex('foo', ['m1', 'm2'], nil)
  end
end
