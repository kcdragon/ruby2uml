module Exploration

  # Contract: All classes that inherit Explorable must implement each(sexp, context=nil, &block) which yields entities (classes, modules, etc.) and their relationships among each other.
  #
  # == Explorable#each
  # [arguments] - +sexp+ an Sexp object
  #             - +context+ a String representing the Entity that is calling each (default: nil)
  #
  # [yields] - name of entity
  #          - type of entity
  #          - relation (can be +nil+)
  #          - name of entity receiving relation (can be +nil+)
  #          - type of entity receiving relation (can be +nil+)
  #
  class Explorable # REFACTOR change name to noun
    attr_writer :resolve_strategy
  end
end
