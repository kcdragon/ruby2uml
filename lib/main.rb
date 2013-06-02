require 'pp'

require_relative 'sexp_factory'

FILE_NAME = 'data/metrics.rb'
file = File.open FILE_NAME, 'rb' # open file as binary to read into one string
program = file.read

pp SexpFactory.instance.get_sexp program, 'rb'
