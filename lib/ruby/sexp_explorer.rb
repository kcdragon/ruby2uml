require_relative '../graph/edge'

module Ruby
  class SexpExplorer
    def initialize
      @ef = Graph::EdgeFactory.instance
      @rels = Array.new
    end

    def register_relationship rel
      rel.explorer = self
      @rels << rel
    end

    def each sexp, &block
      @rels.each do |rel|
        rel.each sexp, &block
      end
    end
  end
end
