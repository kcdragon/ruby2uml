require 'test/unit'

require_relative '../lib/graph_generator'
require_relative '../lib/graph/digraph'
require_relative '../lib/graph/edge'
require_relative '../lib/ruby/sexp_explorer'
require_relative '../lib/sexp_factory'

class TestRubySexp < Test::Unit::TestCase
  def setup
    @explorer = Ruby::SexpExplorer.instance
    @explorer.register_relationship Ruby::AggregationRelationship.new
    @explorer.register_relationship Ruby::ParentRelationship.new
    @explorer.register_relationship Ruby::DependencyRelationship.new
    @edge_factory = Graph::EdgeFactory.instance
  end

private
  # return GraphGenerator
  def analyze_program program
    sexp = SexpFactory.instance.get_sexp program, 'rb'
    graph = Graph::Digraph.new
    generator = GraphGenerator.new graph, @explorer, @edge_factory
    generator.analyze_sexp sexp
    return generator
  end

public
  # NOTE these are not unit tests, they are integration tests, i currently don't have many unit tests for the individual modules
  # TODO move these into an integration folder

  def test_program_with_inheritance
    program = "class Foo < Bar ; end"
    graph = analyze_program(program).graph

    foo, bar = assert_and_get_vertices graph, 'Foo', 'Bar'
    assert_edge_type foo, bar, :generalization
  end

  def test_program_with_dependency
    program = "class Foo \n def hello \n return Bar.new \n end \n end"
    graph = analyze_program(program).graph

    foo, bar = assert_and_get_vertices graph, 'Foo', 'Bar'
    assert_edge_type foo, bar, :dependency
  end

  def test_program_with_instance_variable_aggregation_one_to_one
    program = <<-EOS
      class Foo
        def initialize
          @bar = Bar.new
        end
      end
    EOS
    graph = analyze_program(program).graph

    foo, bar = assert_and_get_vertices graph, 'Foo', 'Bar'
    assert_edge_type foo, bar, :aggregation
  end


#  def test_program_with_instance_variable_aggregation_one_to_many
#    program = <<-EOS
#      class Foo
#        def initialize
#          @bar = Array.new
#          @bar << Bar.new
#          @bar << Bar.new
#        end
#      end
#    EOS
#    graph = analyze_program(program).graph
#
#    foo, bar, array = assert_and_get_vertices graph, 'Foo', 'Bar', 'Array'
#    assert_edge_type foo, array, :aggregation
#    assert_edge_type foo, bar, :aggregation
#  end


  def test_program_with_class_variable_aggregation_one_to_one
    program = <<-EOS
      class Foo
        def self.hello
          @@bar = Bar.new
        end
      end
    EOS
    graph = analyze_program(program).graph

    foo, bar = assert_and_get_vertices graph, 'Foo', 'Bar'
    assert_edge_type foo, bar, :aggregation
  end

  def test_program_with_multiple_classes
    assert true
    # TODO implement test program with multiple classes
  end

  def test_program_with_include_module
    assert true
    # TODO implement test program with include
  end

  

private
  # precondition: vertices is non-empty
  # postcondition: returns n vertex objects s.t. n is vertices.length
  def assert_and_get_vertices graph, *vertices
    vertices.each do |v|
      assert graph.has_vertex?(v), "graph must contain vertex #{v}"
    end
    
    vars = Array.new
    vertices.each do |v|
      vars << graph.get_vertex(v)
    end
    return vars
  end

  def assert_edge_type from, to, type
    e = @edge_factory.get_edge(type)
    assert from.get_edge(e).include?(to), "#{from.name} #{e.to_s} #{to.name} must be true"
  end
end
