require_relative '../../lib/sexp_factory'
require_relative '../../lib/exploration/class_entity'
require_relative '../../lib/exploration/module_entity'
require_relative 'sexp_helper'

describe Exploration::ModuleEntity do
  include SexpHelper
  
  context "ruby program" do
    it "contains a class" do
      program = "module Foo; class Bar; end; end"
      
      subject.add_explorer Exploration::ClassEntity.new
      expect do |b|
        subject.each(get_sexp(program), nil, &b)
      end.to yield_successive_args(
                                   { name: 'Foo', type: :module, namespace: [] },
                                   { name: 'Bar', type: :class, namespace: ['Foo'] }
                                   )
    end

    it "does not contain a class" do
      program = "module Foo; end"
      expect { |b| subject.each(get_sexp(program), nil, &b) }.to yield_with_args({ name: 'Foo', type: :module, namespace: [] })
    end
  end
end
