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
  end
end
