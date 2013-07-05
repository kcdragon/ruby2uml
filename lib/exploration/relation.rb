require_relative 'explorer'

class Relation < Explorer

  # TODO these two methods are only used by aggregation and dependency, find a better place for them
  def each_by_type types, relation, sexp, context=nil, &block
    already_explored = []
    sexp.deep_each do |sub_sexp|
      if types.include? sub_sexp.sexp_type
        # by exploring :colon2 first, we won't pick up any :const that was inside a :colon2
        explore_entity_sexp :colon2, sexp, relation, context, already_explored, &block
        explore_entity_sexp :const, sexp, relation, context, already_explored, &block
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
