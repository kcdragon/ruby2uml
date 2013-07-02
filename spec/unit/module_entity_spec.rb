require_relative '../../lib/sexp_factory'
require_relative '../../lib/graph/vertex'
require_relative '../../lib/exploration/class_entity'
require_relative '../../lib/exploration/method_entity'
require_relative '../../lib/exploration/module_entity'
require_relative 'sexp_helper'

describe Exploration::ModuleEntity do
  include SexpHelper

  let(:foo) { { name: 'Foo', type: :module, namespace: [] } }
  
  it "contains a class" do
    program = "module Foo; class Bar; end; end"
    subject.add_explorer Exploration::ClassEntity.new
    expect do |b|
      subject.each(get_sexp(program), nil, &b)
    end.to yield_successive_args(foo,
                                 { name: 'Bar', type: :class, namespace: ['Foo'] })
  end

  it "does not contain a class" do
    program = "module Foo; end"
    expect { |b| subject.each(get_sexp(program), nil, &b) }.to yield_with_args(foo)
  end

  it "contains a method" do
    program = "module Foo; def get_bar; end; end"
    subject.add_explorer Exploration::MethodEntity.new
    expect do |b|
      subject.each(get_sexp(program), nil, &b)
    end.to yield_successive_args(foo,
                                 [foo, :defines, { name: 'get_bar', type: :method }])
  end
end
