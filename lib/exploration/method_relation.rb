require_relative 'relation'

module Exploration

  # All classes that inherit MethodRelation must implement get_method_explorers(context, &block).
  # get_method_explorers returns a map with keys equal to the sexp types to explorer and the corresponding values as Procs that know how to explore that sexp.
  class MethodRelation < Relation

    INSTANCE_METHOD_TYPE = :defn
    CLASS_METHOD_TYPE = :defs

    def each sexp, context=nil, &block
      explorers = get_method_explorers context, &block
      [INSTANCE_METHOD_TYPE, CLASS_METHOD_TYPE].each do |type|
        each_of_type type, sexp, context, explorers, &block
      end
    end

    # Examines each child of +sexp+ and explores that child if it matches +type+. Searches the child for matches of the keys in +types_to_search+ and calls the Proc on that sexp for any matches. The Proc knows how to explore the given type.
    #
    # [params] - type is a sexp type (ex. :module, :class)
    #          - sexp is a Sexp object
    #          - context is a Hash with attributes describing the parent Sexp
    #          - types_to_search is a Hash of sexp types mapped to Procs
    def each_of_type type, sexp, context, types_to_search, &block
      sexp.each_child do |sub_sexp|
        if sub_sexp.first == type
          method_node = sub_sexp
          method_body = method_node.rest.rest.rest
          method_body.deep_each do |sub_sexp|
            types_to_search.each do |type, explorer|
              explorer.call(sub_sexp) if type.include? sub_sexp.first
            end
          end
        end
      end
    end
  end
end