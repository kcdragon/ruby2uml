require_relative 'explorer'

module Exploration
  class Relation < Explorer

    # Extracts name and namespace of the Sexp object.
    #
    # [params] - sexp is a Sexp object
    #
    # [precondition] - sexp is of the form: s(:colon2, s(:colon2 ..., s(:const, FirstNamespace), SecondNamespace, ..., ClassName).
    #                - :colon2 sexp's are optional but there must be a :const
    #
    # [return] - name as String
    #          - namespace as Array of String objects
    #          - explored Sexp objects as an Array
    def get_name_and_namespace sexp
      name = if sexp.first == :colon2
               sexp.rest.rest.first.to_s
             else
               sexp.rest.first.to_s
             end
      namespace, explored = get_namespace sexp
      explored << sexp
      return name, namespace, explored
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
