require_relative '../sexp_ext'
require_relative 'explorer'

module Exploration
  class Relation < Explorer

    # Examines each child of +sexp+ and explores that child if it matches +type+. Searches the child for matches of the keys in +types_to_search+ and calls the Proc on that sexp for any matches.
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
            types_to_search.each do |type, callback|
              if type.include? sub_sexp.first
                callback.call(sub_sexp)
              end
            end
          end
        end
      end
    end

    def explore_sexp_with_namespace sexp, type, context, already_explored, &block
      sexp.each_of_type(:colon2) do |dependency_node|
        if !already_explored.include?(dependency_node)
          dependency_name = dependency_node.rest.rest.head.to_s # name of the dependent class
          namespace, explored = get_namespace dependency_node

          block.call context, type, { name: dependency_name, type: :class, namespace: namespace }

          already_explored << dependency_node
          already_explored.concat explored # do not want to explore anything the was encountered in the namespace, if this was not done, there would be multiple yields for the same class
          # i.e. Foo::Bar::Baz,
          #           Bar::Baz, and
          #                Baz
        end
      end
    end

    def explore_sexp_without_namespace sexp, type, context, already_explored, &block
      sexp.each_of_type(:const) do |node|
        if !already_explored.include?(node)
          name = node.rest.head.to_s # name of the dependent class
          block.call context, type, { name: name, type: :class, namespace: [] }
          already_explored << node
        end
      end
    end

    # Extracts the namespace from the Sexp object.
    #
    # [precondition] - sexp is of the form: s(:colon2, s(:colon2 ..., s(:const, FirstNamespace), SecondNamespace, ..., ClassName).
    #                - :colon2 sexp's are optional but there must be a :const
    #
    # [params] - sexp is a Sexp object
    #
    # [return] - Array of String objects
    #          - Array of Sexp objects that where encountered
    #
    # [example] - s(:colon2, s(:colon2, s(:const, :Baz), :Foo), :Bar) ==> ['Baz', 'Foo']
    def get_namespace sexp
      current = sexp
      type = current.first
      namespace = []
      subs = []
      while type == :colon2
        namespace.unshift current.rest.rest.first.to_s
        current = current.rest.first
        subs << current
        type = current.first
      end
      namespace.unshift current.rest.first.to_s
      return namespace[0...namespace.length-1], subs # return all except for the last element
    end
  end
end
