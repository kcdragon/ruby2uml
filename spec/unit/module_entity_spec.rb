require 'spec_helper'
require 'graph/vertex'
require 'exploration/class_entity'
require 'exploration/method_entity'
require 'exploration/module_entity'
require_relative 'sexp_helper'

describe ModuleEntity do
  include SexpHelper

  let(:foo) { { name: 'Foo', type: :module, namespace: [] } }
  
  it "contains a class" do
    program = "module Foo; class Bar; end; end"
    subject.add_explorer ClassEntity.new
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
    subject.add_explorer MethodEntity.new
    expect do |b|
      subject.each(get_sexp(program), nil, &b)
    end.to yield_successive_args(foo,
                                 [foo, :defines, { name: 'get_bar', type: :method }])
  end
end
