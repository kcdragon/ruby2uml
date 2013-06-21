require_relative '../../lib/sexp_factory'
require_relative '../../lib/exploration/class_entity'

describe Exploration::ClassEntity do
  before :each do
    @sf = SexpFactory.instance
  end
  
  context "ruby program" do
    it "has a dependency" do
      program = "class Foo; def hello; puts Hello.hi; end; end"
      sexp = @sf.get_sexp program, 'rb'
      
      subject.add_explorer Exploration::DependencyRelation.new
      expect do |b|
        subject.each(sexp, nil, &b)
      end.to yield_successive_args(
                                   { name: 'Foo', type: :class, namespace: [] },
                                   [{ name: 'Foo', type: :class, namespace: [] }, :dependency, { name: 'Hello', type: :class }])
    end

    it "does not have a dependency" do
      program = "class Foo; def hello; puts 'hello'; end; end"
      sexp = @sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, nil, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] })
    end
  end
end
