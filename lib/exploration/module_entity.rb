require_relative 'entity'
require_relative 'explorable'

module Exploration
  class ModuleEntity < Entity
    def each sexp, context=nil, &block
      each_type sexp, :module, context, &block
    end
  end
end
