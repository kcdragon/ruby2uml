require_relative '../../lib/exploration/parent_relation'
require_relative 'sexp_helper'

describe Exploration::ParentRelation do
  include SexpHelper
  
  context "ruby program" do
    it "has a parent class" do
      program = "class Foo < Bar; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] },
                                                                                                                          :generalization,
                                                                                                                          { name: 'Bar', type: :class })
    end

    it "does not have a parent class" do
      program = "class Foo; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.not_to yield_control
    end
  end
end
