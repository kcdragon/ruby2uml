require 'test/unit'

require_relative '../lib/graph/digraph'
require_relative '../lib/graph/edge_factory'
require_relative '../lib/exploration/class_entity'
require_relative '../lib/exploration/explorer_builder'
require_relative '../lib/sexp_factory'
require_relative '../lib/graph_generator'

class TestRubySexp < Test::Unit::TestCase
  def setup
    @edge_factory = Graph::EdgeFactory.instance
  end

private
  # return Digraph
  def analyze_program *programs
    # FIXME
    sexp = SexpFactory.instance.get_sexp programs[0], 'rb'
    explorer = Exploration::ExplorerBuilder.instance.build_ruby_explorer
    generator = GraphGenerator.new
    generator.process_sexp explorer, sexp
    return generator.graph
  end

public
  # NOTE these are not unit tests, they are integration tests, i currently don't have many unit tests for the individual modules
  # TODO move these into an integration folder

  # TODO add checks that Foo and Bar are ClassVertex's

  def test_program_with_class_inheritance
    program = "class Foo < Bar ; end"
    graph = analyze_program(program)

    foo, bar = assert_and_get_vertices graph, 'Foo', 'Bar'
    assert_edge_type foo, bar, :generalization
  end

  def test_program_with_class_dependency
    program = "class Foo \n def hello \n return Bar.new \n end \n end"
    graph = analyze_program(program)

    foo, bar = assert_and_get_vertices graph, 'Foo', 'Bar'
    assert_edge_type foo, bar, :dependency
  end

  def test_program_with_class_instance_variable_aggregation_one_to_one
    program = <<-EOS
      class Foo
        def initialize
          @bar = Bar.new
        end
      end
    EOS
    graph = analyze_program(program)

    foo, bar = assert_and_get_vertices graph, 'Foo', 'Bar'
    assert_edge_type foo, bar, :aggregation
  end


#  def test_program_with_class_instance_variable_aggregation_one_to_many
#    program = <<-EOS
#      class Foo
#        def initialize
#          @bar = Array.new
#          @bar << Bar.new
#          @bar << Bar.new
#        end
#      end
#    EOS
#    graph = analyze_program(program)
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
    graph = analyze_program(program)

    foo, bar = assert_and_get_vertices graph, 'Foo', 'Bar'
    assert_edge_type foo, bar, :aggregation
  end

#  def test_program_with_class_inside_module
#    program = <<-EOS
#      module Foo
#        class Bar
#        end
#      end
#    EOS#

#    graph = analyze_program(program)
#    assert !graph.find_vertex('Bar', Graph::Namespace.new(['Foo'])).empty?
#  end

  def test_program_with_module_dependency
    program = <<-EOS
      module Foo
        def hello
          return Bar.new
        end
      end
    EOS
    graph = analyze_program program
    
    foo, bar = assert_and_get_vertices graph, 'Foo', 'Bar'
    assert_edge_type foo, bar, :dependency
  end

  # test that the class has a dependency but the module does not
  def test_program_with_module_class_and_class_dependency
    program = <<-EOS
      module Foo
        class Bar
          def hello
            return World.new
          end
        end
      end
    EOS
    graph = analyze_program program
    
    foo, bar, world = assert_and_get_vertices graph, 'Foo', 'Bar', 'World'
    assert_edge_type bar, world, :dependency
    assert_no_edge_type foo, world, :dependency
  end

  def test_program_with_multiple_classes
    assert true
    # TODO implement test program with multiple classes
  end

  def test_program_with_include_module
    assert true
    # TODO implement test program with include
  end

  # tests that a un-namespaced class in one program is successfully identified as the fully-namespaced class in another program
  def test_program_aggregatating_unnamespaced_reference
    program1 = <<-EOS
      module Music
        class Artist
         end
      end
    EOS

    program2 = <<-EOS
      class Album
        def initialize
          @artist = Artist.new
        end
      end
    EOS

    #graph = analyze_program program1, program2

    #music, artist, album = assert_and_get_vertices graph, 'Music', 'Music::Artist', 'Album'
    #assert_edge_type artist, album, :aggregation
  end

private
  # precondition: vertices is non-empty
  # postcondition: returns n vertex objects s.t. n is vertices.length
  def assert_and_get_vertices graph, *vertices
    assert_vertices graph, *vertices
    
    vars = Array.new
    vertices.each do |v|
      vars << graph.get_vertex(v)
    end
    return vars
  end

  def assert_vertices graph, *vertices
    vertices.each do |v|
      assert graph.has_vertex?(v), "graph must contain vertex #{v}"
    end
  end

  def assert_no_vertices graph, *vertices
    vertices.each do |v|
      assert !graph.has_vertex?(v), "graph must not contain vertex #{v}"
    end
  end

  def assert_edge_type from, to, type
    e = @edge_factory.get_edge(type)
    assert from.get_edge(e).include?(to), "#{from.name} #{e.to_s} #{to.name} must be true"
  end

  def assert_no_edge_type from, to, type
    e = @edge_factory.get_edge(type)
    assert !from.get_edge(e).include?(to), "#{from.name} #{e.to_s} #{to.name} must not exist"
  end
end
