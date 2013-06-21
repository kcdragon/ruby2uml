require_relative '../../lib/sexp_factory'
require_relative '../../lib/exploration/parent_relation'

describe Exploration::ParentRelation do
  before :each do
    @sf = SexpFactory.instance
  end
  
  context "ruby program" do
    it "has a parent class" do
      program = "class Foo < Bar; end"
      sexp = @sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] }, :generalization, { name: 'Bar', type: :class })
    end

    it "does not have a parent class" do
      program = "class Foo; end"
      sexp = @sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, { name: 'Foo', type: :class, namespace: [] }, &b) }.not_to yield_control
    end
  end
end
