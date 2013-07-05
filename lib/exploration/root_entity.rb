require_relative 'entity'

# A wrapper Entity to support multiple top-level entities in an explorer. Does not represent an actual Entity.
class RootEntity < Entity
  def each sexp, context=nil, &block
    explore sexp, context, &block
  end
end
