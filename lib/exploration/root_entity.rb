require_relative 'entity'
require_relative 'explorable'

module Exploration
  class RootEntity < Entity
    def each sexp, context=nil, &block
      @explorers.each do |exp|
        exp.each sexp, context, &block
      end
    end
  end
end
