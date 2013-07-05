require_relative 'entity'

class ModuleEntity < Entity
  def each sexp, context=nil, &block
    each_type sexp, :module, context, &block
  end
end
