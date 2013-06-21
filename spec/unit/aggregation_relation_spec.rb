require_relative '../../lib/sexp_factory'
require_relative '../../lib/exploration/aggregation_relation'

describe Exploration::AggregationRelation do
  before :each do
    @sf = SexpFactory.instance
  end
  
  context "ruby program" do
    it "aggregates a class" do
      program = "class Foo; def initialize; @hello = Hello.new; end; end"
      sexp = @sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] }, :aggregation, { name: 'Hello', type: :class })
    end

    it "does not aggregate a class" do
      program = "class Foo; def initialize; puts 'hello'; end; end"
      sexp = @sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, { name: 'Foo', type: :class, namespace: [] }, &b) }.not_to yield_control
    end
  end
end
