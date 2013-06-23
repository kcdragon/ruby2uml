require 'yaml'

require_relative 'exploration/explorer_builder'
require_relative 'graph_generator'
require_relative 'sexp_factory'
require_relative 'uml/dot_builder'

config = YAML.load_file 'config/dot.yml'

if ARGV.length == 0
  puts 'Must include a file name as an argument.'
  exit
end

file_name = ARGV[0]
file = File.open file_name, 'rb' # open file as binary to read into one string
program = file.read

sexp = SexpFactory.instance.get_sexp program, 'rb'
explorer = Exploration::ExplorerBuilder.instance.build_ruby_explorer
generator = GraphGenerator.new
generator.process_sexp explorer, sexp
graph = generator.graph

puts DotBuilder.new(config).build_uml(graph)
