require_relative '../../lib/exploration/class_entity'
require_relative '../../lib/exploration/dependency_relation'
require_relative '../../lib/sexp_factory'

describe Exploration::ClassEntity do
  let(:sf) { SexpFactory.instance }
  
  context "ruby program" do
    it "has a dependency" do
      program = "class Foo; def hello; puts Hello.hi; end; end"
      sexp = sf.get_sexp program, 'rb'
      
      subject.add_explorer Exploration::DependencyRelation.new
      expect do |b|
        subject.each(sexp, nil, &b)
      end.to yield_successive_args(
                                   { name: 'Foo', type: :class, namespace: [] },
                                   [{ name: 'Foo', type: :class, namespace: [] }, :dependency, { name: 'Hello', type: :class }])
    end

    it "does not have a dependency" do
      program = "class Foo; def hello; puts 'hello'; end; end"
      sexp = sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, nil, &b) }.to yield_with_args({ name: 'Foo', type: :class, namespace: [] })
    end

    it "does not explore classes nested inside module" do
      program = "module Bar; class Foo; end; end"
      sexp = sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, nil, &b) }.to_not yield_control
    end

    it "explores multiple top-level classes"# do
      #program = "class Bar; end; class Foo; end"
    #end
  end
end
