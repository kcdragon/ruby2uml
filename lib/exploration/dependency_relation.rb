require_relative 'relation'

class DependencyRelation < Relation

  def each sexp, context=nil, &block
    each_by_type [:call], :dependency, sexp, context, &block
  end
end
