require 'pp'

require_relative 'graph_generator'
require_relative 'graph/digraph'
require_relative 'ruby/class_sexp_explorer'
require_relative 'ruby/aggregation_relationship'
require_relative 'ruby/dependency_relationship'
#require_relative 'ruby/implements_relationship'
require_relative 'ruby/parent_relationship'
require_relative 'sexp_factory'

# REFACTOR into command line arguments
FILE_NAME = 'data/edge.rb'
file = File.open FILE_NAME, 'rb' # open file as binary to read into one string
program = file.read

sexp = SexpFactory.instance.get_sexp program, 'rb'

graph = Graph::Digraph.new

class_explorer = Ruby::ClassSexpExplorer.instance
class_explorer.register_relationship Ruby::AggregationRelationship.new
class_explorer.register_relationship Ruby::ParentRelationship.new
class_explorer.register_relationship Ruby::DependencyRelationship.new

generator = GraphGenerator.new(graph, class_explorer, Graph::EdgeFactory.instance)
generator.analyze_sexp sexp

puts graph
