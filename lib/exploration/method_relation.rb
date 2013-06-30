require_relative '../sexp_ext'
require_relative 'relation'

module Exploration

  # All classes that inherit MethodRelation must implement get_method_explorers(context, &block).
  # get_method_explorers returns a map with keys equal to the sexp types to explorer and the corresponding values as Procs that know how to explore that sexp.
  class MethodRelation < Relation

    def each sexp, context=nil, &block
      explorers = get_method_explorers context, &block
      [:defn, :defs].each do |type|
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

    def explore_entity_sexp type, sexp, relationship, context, already_explored, &block
      sexp.each_of_type(type) do |node|
        if !already_explored.include?(node)
          name, namespace, explored = get_name_and_namespace node
          block.call context, relationship, { name: name, type: :class, namespace: namespace }
          already_explored.concat explored
        end
      end
    end
  end
end
