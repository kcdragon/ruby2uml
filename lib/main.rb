require 'pp'

require_relative 'graph_generator'
require_relative 'graph/digraph'
require_relative 'ruby/sexp_explorer'
require_relative 'sexp_factory'

# REFACTOR into command line arguments
FILE_NAME = 'data/edge.rb'
file = File.open FILE_NAME, 'rb' # open file as binary to read into one string
program = file.read

sexp = SexpFactory.instance.get_sexp program, 'rb'

graph = Graph::Digraph.new
generator = GraphGenerator.new graph, Ruby::SexpExplorer.new, Graph::EdgeFactory.instance
generator.analyze_sexp sexp

puts graph
