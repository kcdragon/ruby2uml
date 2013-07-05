require_relative 'relation'

class AggregationRelation < Relation

  def each sexp, context=nil, &block
    each_by_type [:iasgn, :cvasgn], :aggregation, sexp, context, &block
  end
end
