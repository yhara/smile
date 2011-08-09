module Smile
  OPECODES = {
    "1-)" => 1,
    "2-)" => 2,
    "3-)" => 3,
    "4-)" => 4,
    "5-)" => 5,
    "6-)" => 6,
    "7-)" => 7,
    "8-)" => 8,
    "9-)" => 9,
    "0-)" => 0,
    ":-p" => :push_right,
    ":-o" => :putc_right,
    ":-O" => :putn_right,
    "[-:" => :loop_start,
    ":-]" => :loop_end,
    ":\")" => :dup_right,
    ";-)" => :sub_right,
  }

  def self.foo
    :foo
  end
end

require 'smile/lexer'
require 'smile/parser'
require 'smile/evaluator'

