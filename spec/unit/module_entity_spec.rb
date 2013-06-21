require_relative '../../lib/sexp_factory'
require_relative '../../lib/exploration/class_entity'
require_relative '../../lib/exploration/module_entity'

describe Exploration::ModuleEntity do
  before :each do
    @sf = SexpFactory.instance
  end
  
  context "ruby program" do
    it "contains a class" do
      program = "module Foo; class Bar; end; end"
      sexp = @sf.get_sexp program, 'rb'
      
      subject.add_explorer Exploration::ClassEntity.new
      expect do |b|
        subject.each(sexp, nil, &b)
      end.to yield_successive_args(
                                   { name: 'Foo', type: :module, namespace: [] },
                                   { name: 'Bar', type: :class, namespace: ['Foo'] }
                                   )
    end

    it "does not contain a class" do
      program = "module Foo; end"
      sexp = @sf.get_sexp program, 'rb'
      expect { |b| subject.each(sexp, nil, &b) }.to yield_with_args({ name: 'Foo', type: :module, namespace: [] })
    end
  end
end
