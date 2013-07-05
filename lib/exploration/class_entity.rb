require_relative 'entity'

class ClassEntity < Entity
  def each sexp, context=nil, &block
    each_type sexp, :class, context, &block
  end
end
