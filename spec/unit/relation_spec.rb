require 'sexp'

require_relative '../../lib/exploration/relation'

describe Exploration::Relation do

  describe ".get_namespace" do
    context "when there is no namespace" do
      it "empty array" do
        sexp = Sexp.from_array [:const, :Foo]
        expect(subject.get_namespace(sexp)).to eq [[], []]
      end
    end

    context "when there is a namespace" do
      it "single namespace" do
        foo = [:const, :Foo]
        sexp = Sexp.from_array [:colon2, foo, :Bar]
        expect(subject.get_namespace(sexp)).to eq [['Foo'], [Sexp.from_array(foo)]]
      end

      it "two namespaces" do
        foo = [:const, :Foo]
        bar = [:colon2, foo, :Bar]
        sexp = Sexp.from_array [:colon2, bar, :Baz]
        expect(subject.get_namespace(sexp)).to eq [['Foo', 'Bar'], [Sexp.from_array(bar),
                                                                    Sexp.from_array(foo)
                                                                   ]
                                                  ]
      end

      it "three namespaces" do
        foo = [:const, :Foo]
        bar = [:colon2, foo, :Bar]
        baz = [:colon2, bar, :Baz]
        sexp = Sexp.from_array [:colon2, baz, :Car]
        expect(subject.get_namespace(sexp)).to eq [['Foo', 'Bar', 'Baz'], [
                                                                           Sexp.from_array(baz),
                                                                           Sexp.from_array(bar),
                                                                           Sexp.from_array(foo)
                                                                          ]
                                                  ]
      end
    end
  end
end
