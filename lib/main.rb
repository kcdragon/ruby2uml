require 'pp'

require_relative 'graph/digraph'
require_relative 'exploration/class_entity'
require_relative 'exploration/explorer_builder'
require_relative 'exploration/aggregation_relation'
require_relative 'exploration/dependency_relation'
#require_relative 'exploration/implements_relation'
require_relative 'exploration/parent_relation'
require_relative 'graph_generator'
require_relative 'sexp_factory'
require_relative 'uml/dot_builder'

# REFACTOR into command line arguments
FILE_NAME = 'data/edge.rb'
file = File.open FILE_NAME, 'rb' # open file as binary to read into one string
program = file.read

sexp = SexpFactory.instance.get_sexp program, 'rb'
explorer = Exploration::ExplorerBuilder.instance.build_ruby_explorer
generator = GraphGenerator.new
generator.process_sexp explorer, sexp
graph = generator.graph

pp graph

#out = File.new('out.dot', 'w')
#out.puts DotBuilder.new.build_uml(graph)
#out.close
