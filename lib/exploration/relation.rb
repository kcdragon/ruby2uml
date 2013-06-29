require_relative '../sexp_ext'
require_relative 'explorer'

module Exploration
  class Relation < Explorer

    def explore_sexp_with_namespace sexp, type, context, already_explored, &block
      sexp.each_of_type(:colon2) do |namespace_sexp|
        if !already_explored.include?(namespace_sexp)
          name = namespace_sexp.rest.rest.head.to_s # name of the dependent namespace
          namespace, explored = get_namespace namespace_sexp

          block.call context, type, { name: name, type: :class, namespace: namespace }

          already_explored << namespace_sexp
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
