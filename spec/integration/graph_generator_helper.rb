require_relative '../../lib/exploration/explorer_builder'
require_relative '../../lib/graph_generator'
require_relative '../../lib/sexp_factory'

module GraphGeneratorHelper
  def generate_graph *programs
    sf = SexpFactory.instance
    explorer = Exploration::ExplorerBuilder.new.build_ruby_explorer
    generator = GraphGenerator.new
    programs.each do |p|
      sexp = sf.get_sexp p, 'rb'
      generator.process_sexp explorer, sexp
    end
    generator.graph
  end
end
