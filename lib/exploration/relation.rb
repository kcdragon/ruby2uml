module Exploration
  class Relation
    # types_to_search: Hash of types => callback
    def each_of_type type, sexp, context, types_to_search, &block
      sexp.each_sexp do |sub_sexp|
        if sub_sexp.first == type
          method_node = sub_sexp
          method_body = method_node.rest.rest.rest
          method_body.deep_each do |sub_sexp|
            types_to_search.each do |type, callback|
              # TODO get this to work whether type is single symbol or array of symbols
              if type.include? sub_sexp.first
                callback.call(sub_sexp)
              end
            end
          end
        end
      end
    end
  end
end
