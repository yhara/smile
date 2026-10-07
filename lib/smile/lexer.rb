module Smile
  class Lexer

    def initialize(src)
      @src = src
    end

    def tokenize
      # Multi-line comment: :-X ... X-:
      src = @src.gsub(/:-X.*?X-:/m, ' ')

      words = []
      src.each_line do |line|
        ws = line.split
        # Single-line comment to the end of the line: :-x
        if (i = ws.index(":-x"))
          ws = ws[0...i]
        end
        # Single-line comment to the beginning of the line: x-:
        if (i = ws.rindex("x-:"))
          ws = ws[(i + 1)..] || []
        end
        words.concat(ws)
      end

      words.map { |w|
        OPECODES.fetch(w) { raise "unknown token: #{w.inspect}" }
      }
    end

  end
end
