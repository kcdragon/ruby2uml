require 'spec_helper'
require 'exploration/explorer_builder'
require 'graph_generator'
require_relative '../../lib/sexp_factory'

module GraphGeneratorHelper
  def generate_graph *programs
    sf = SexpFactory.new
    explorer = ExplorerBuilder.new.build_ruby_explorer
    generator = GraphGenerator.new
    programs.each do |p|
      sexp = sf.get_sexp p, 'rb'
      generator.process_sexp explorer, sexp
    end
    generator.graph
  end
end
