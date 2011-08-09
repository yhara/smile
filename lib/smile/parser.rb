module Smile
  class Parser
    def initialize(tokens)
      @tokens = tokens.dup
    end
    
    # [:push_right, 6, 5, :putc_right]
    def parse
      ret = []
      until @tokens.empty?
        token = @tokens.shift
        case token
        when :push_right
          ret << [:push_right, parse_num]
        when :putc_right, :putn_right, :dup_right, :sub_right
          ret << [token]
        when :loop_start
          ret << [:loop, parse]
        when :loop_end
          break
        end
      end
      ret
    end

    def parse_num
      ret = []
      loop do
        token = @tokens[0]
        if token.is_a?(Integer)
          ret << token
          @tokens.shift
        else
          break
        end
      end
      ret.map{|n| n.to_s}.join.to_i
    end

  end
end

