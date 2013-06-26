require_relative 'entity'

module Exploration
  class ClassEntity < Entity
    def each sexp, context=nil, &block
      each_type sexp, :class, context, &block
    end
  end
end
