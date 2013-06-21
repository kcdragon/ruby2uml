require_relative '../../lib/sexp_factory'
require_relative '../../lib/exploration/dependency_relation'

describe Exploration::DependencyRelation do
  before :each do
    @sf = SexpFactory.instance
  end
  
  context "ruby program" do
    it "has a dependency" do
      program = "class Foo; def hello; puts Hello.hi; end; end"
      sexp = @sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, { name: 'Foo', type: :class, namespace: [] }, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] }, :dependency, { name: 'Hello', type: :class })
    end

    it "does not have a dependency" do
      program = "class Foo; def hello; puts 'hello'; end; end"
      sexp = @sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, { name: 'Foo', type: :class, namespace: [] }, &b) }.not_to yield_control
    end
  end
end
