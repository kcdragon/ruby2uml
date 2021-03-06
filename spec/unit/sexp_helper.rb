require 'spec_helper'
require 'sexp_factory'

module SexpHelper
  def get_sexp program, type='rb'
    sf.get_sexp program, type
  end

private
  def sf
    SexpFactory.new
  end
end
