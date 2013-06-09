require 'pp'

require_relative 'graph/digraph'
require_relative 'exploration/class_entity'
require_relative 'exploration/explorer_builder'
require_relative 'exploration/aggregation_relation'
require_relative 'exploration/dependency_relation'
#require_relative 'exploration/implements_relation'
require_relative 'exploration/parent_relation'
require_relative 'sexp_factory'

# REFACTOR into command line arguments
FILE_NAME = 'data/edge.rb'
file = File.open FILE_NAME, 'rb' # open file as binary to read into one string
program = file.read

sexp = SexpFactory.instance.get_sexp program, 'rb'
graph = Exploration::ExplorerBuilder.instance.build_ruby_explorer.generate_graph sexp

puts graph
