require_relative 'entity'

class MethodEntity < Entity

  def each sexp, context=nil, &block
    # NOTE does not handle file with only methods in it
    sexp.each_sexp do |sub_sexp|
      if [:defn, :defs].include? sub_sexp.sexp_type
        # TODO handle arguments for methods
        if sub_sexp.rest.first.kind_of? Sexp # TODO right now, we assume this is self, need to look into
          name = sub_sexp.rest.rest.first.to_s
        else
          name = sub_sexp.rest.first.to_s
        end
        block.call context, :defines, { name: name, type: :method }
        explore sub_sexp, context, &block
      end
    end
  end
end
