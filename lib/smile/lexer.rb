module Smile
  class Lexer

    def initialize(src)
      @src = src
    end

    def tokenize
      @src.split.map{|x|
        OPECODES[x]
      }
    end

  end
end
