require_relative '../../lib/sexp_factory'
require_relative '../../lib/exploration/aggregation_relation'
require_relative 'sexp_helper'

describe Exploration::AggregationRelation do
  include SexpHelper
  
  context "ruby program" do
    it "aggregates a class" do
      program = "class Foo; def initialize; @hello = Hello.new; end; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] },
                                                                                                                          :aggregation,
                                                                                                                          { name: 'Hello', type: :class })
    end

    it "does not aggregate a class" do
      program = "class Foo; def initialize; puts 'hello'; end; end"
      expect { |b| subject.each(get_sexp(program), { name: 'Foo', type: :class, namespace: [] }, &b) }.not_to yield_control
    end
  end
end
