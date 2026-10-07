module Smile
  OPECODES = {}

  # Numeric literal digits.
  #   positive digit  N-)   => N        (e.g. 1-) 0-) means 10)
  #   negative digit  (-N   => [:neg_digit, N]  (e.g. (-1 (-0 means -10)
  (0..9).each do |n|
    OPECODES["#{n}-)"] = n
    OPECODES["(-#{n}"] = [:neg_digit, n]
  end

  OPECODES.merge!({
    # Arithmetic
    "(+:" => :add_left,     ":+)" => :add_right,
    "(-:" => :sub_left,     ":-)" => :sub_right,
    ";-)" => :sub_right,    # legacy alias used by the sample program
    "(*:" => :mul_left,     ":*)" => :mul_right,
    "(-/" => :div_left,     "/-)" => :div_right,
    "(-%" => :mod_left,     "%-)" => :mod_right,
    "(-|" => :bitor_left,   "|-)" => :bitor_right,
    "(-&" => :bitand_left,  "&-)" => :bitand_right,
    "(^:" => :bitxor_left,  ":^)" => :bitxor_right,
    "(-!" => :not_left,     "!-)" => :not_right,

    # Comparison
    "<-:" => :greater_left, ":-<" => :greater_right,
    ">-:" => :less_left,    ":->" => :less_right,
    "<=:" => :ge_left,      ":=<" => :ge_right,
    ">=:" => :le_left,      ":=>" => :le_right,
    "(=:" => :equal_left,   ":=)" => :equal_right,

    # Deque operations
    "p-:" => :push_left,    ":-p" => :push_right,
    "s-:" => :swap_left,    ":-s" => :swap_right,
    "(\":" => :dup_left,    ":\")" => :dup_right,
    "D-:" => :discard_left, ":-D" => :discard_right,
    "o-8" => :rotate_left,  "8-o" => :rotate_right,

    # I/O
    "o-:" => :putc_left,    ":-o" => :putc_right,
    "O-:" => :putn_left,    ":-O" => :putn_right,
    "i-:" => :getc_left,    ":-i" => :getc_right,
    "I-:" => :getn_left,    ":-I" => :getn_right,

    # Control flow
    "{-:" => :if_left_start,    ":-}" => :if_left_end,
    ":-{" => :if_right_start,   "}-:" => :if_right_end,
    ":-|" => :else,            "|-:" => :else,
    "[-:" => :loop_left_start,  ":-]" => :loop_left_end,
    ":-[" => :loop_right_start, "]-:" => :loop_right_end,
    "B-)" => :exit,            "(-B" => :exit,
  })

  def self.run(src)
    tokens = Lexer.new(src).tokenize
    code = Parser.new(tokens).parse
    Evaluator.new(code).eval
  end
end

require 'smile/lexer'
require 'smile/parser'
require 'smile/evaluator'
