require_relative 'entity'
require_relative 'explorable'

module Exploration

  # A wrapper Entity to support multiple top-level entities in an explorer. Does not represent an actual Entity.
  class RootEntity < Entity
    def each sexp, context=nil, &block
      @explorers.each do |exp|
        exp.each sexp, context, &block
      end
    end
  end
end
