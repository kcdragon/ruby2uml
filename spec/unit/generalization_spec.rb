require 'spec_helper'
require 'exploration/generalization_relation'
require_relative 'sexp_helper'

describe GeneralizationRelation do
  include SexpHelper

  context "when there is a generalization" do
    it "generalized class does not have a namespace" do
      program = "class Foo < Bar; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] },
                                                                                                                          :generalization,
                                                                                                                          { name: 'Bar', type: :class, namespace: [] })
    end

    it "generalized class has a namespace" do
      program = "class Foo < Baz::Bar; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] },
                                                                                                                          :generalization,
                                                                                                                          { name: 'Bar', type: :class, namespace: ['Baz'] })
    end
  end

  context "when there is not a generalization" do
    it "does not have a generalization" do
      program = "class Foo; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.not_to yield_control
    end
  end
end
