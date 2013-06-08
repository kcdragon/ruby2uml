require 'test/unit'

require_relative '../lib/graph_generator'
require_relative '../lib/graph/digraph'
require_relative '../lib/graph/edge'
require_relative '../lib/ruby/sexp_explorer'
require_relative '../lib/sexp_factory'

class TestRubySexp < Test::Unit::TestCase
  def setup
    @explorer = Ruby::SexpExplorer.new
    @edge_factory = Graph::EdgeFactory.instance
  end

  def test_ruby_program_with_inheritance
    program = "class Foo < Bar ; end"
    sexp = SexpFactory.instance.get_sexp program, 'rb'
    graph = Graph::Digraph.new
    generator = GraphGenerator.new graph, @explorer, @edge_factory
    generator.analyze_sexp sexp
    
    assert graph.has_vertex? :Foo
    assert graph.has_vertex? :Bar
    
    foo = graph.get_vertex :Foo
    bar = graph.get_vertex :Bar
    assert foo.get_edge(@edge_factory.get_edge(:generalization)).include?(bar)
  end
end
