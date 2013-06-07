require 'pp'

require_relative 'graph_generator'
require_relative 'sexp_factory'

FILE_NAME = 'data/edge.rb'
file = File.open FILE_NAME, 'rb' # open file as binary to read into one string
program = file.read

# TODO implement aggregation
# TODO implement composition
# cvasgn for class variable
# ivasgn for instance variable

# TODO implement implements

sexp = SexpFactory.instance.get_sexp program, 'rb'

gen = GraphGenerator.new nil
gen.analyze_sexp sexp
