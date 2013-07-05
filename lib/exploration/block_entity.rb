require_relative 'entity'

# Explores any children of a :block element. The block element itself is not yielded as an entity only children.
class BlockEntity < Entity
  def each sexp, context=nil, &block
    if sexp.first == :block
      sexp.each_sexp do |sub_sexp|
        explore sub_sexp, context, &block
      end
    end
  end
end
