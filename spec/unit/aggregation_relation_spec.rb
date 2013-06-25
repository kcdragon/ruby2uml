require_relative '../../lib/sexp_factory'
require_relative '../../lib/exploration/aggregation_relation'
require_relative 'sexp_helper'

describe Exploration::AggregationRelation do
  include SexpHelper
  
  context "when there is an aggregation" do
    it "aggregate does not have a namespace" do
      program = "class Foo; def initialize; @hello = Hello.new; end; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] },
                                                                                                                          :aggregation,
                                                                                                                          { name: 'Hello', type: :class, namespace: [] })
    end

    it "aggregate does have a namespace" do
      program = "class Foo; def initialize; @hello = Bar::Hello.new; end; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] },
                                                                                                                          :aggregation,
                                                                                                                          { name: 'Hello', type: :class, namespace: ['Bar'] })
    end
  end

  context "when there is not an aggregation" do
    it "does not aggregate a class" do
      program = "class Foo; def initialize; puts 'hello'; end; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.not_to yield_control
    end
  end
end
