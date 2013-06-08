require 'test/unit'

require_relative '../lib/graph/edge'
require_relative '../lib/graph/vertex'

class TestVertex < Test::Unit::TestCase
  def setup
    @one = create_vertex 'one'
    @two = create_vertex 'two'
    @three = create_vertex 'three'
    @one.add_edge Graph::EdgeFactory.instance.get_edge(:generalization), @two
    @one.add_edge Graph::EdgeFactory.instance.get_edge(:aggregation), @three
  end

  def test_vertex_enumerability
    assert @one.count > 0
    @one.each do |edge, set|
      assert edge.eql?(Graph::GeneralizationEdge.new) || edge.eql?(Graph::AggregationEdge.new)
      if edge.eql? Graph::GeneralizationEdge.new
        assert set.include? @two
      else
        assert set.include? @three
      end
    end
  end

private
  def create_vertex name
    Graph::ClassVertex.new name
  end
end
