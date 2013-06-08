require_relative '../graph/vertex'
require_relative 'sexp_explorer'

module Ruby
  class ClassSexpExplorer < SexpExplorer
    def self.instance
      @@instance ||= ClassSexpExplorer.new
    end
    
    # TODO prefix class name with module name (if there is one) that the class is nested in
    # not sure how to do this, easisest way would be for class_sexp to reach "up" into parent element, but not sure if that is possible
    # could also explore modules first and then pass a reference to module name to each embedded class
    def get_subject module_name=''
      return :class, lambda { |sexp| module_name + sexp.rest.head.to_s }, Graph::ClassVertex
    end
  end
end
