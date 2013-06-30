require_relative 'entity'

module Exploration
  class MethodEntity < Entity

    def each sexp, context=nil, &block
      # NOTE does not handle file with only methods in it
      sexp.each_sexp do |sub_sexp|
        if [:defn, :defs].include? sub_sexp.sexp_type
          explore sub_sexp, context, &block
        end
      end
    end
  end
end
