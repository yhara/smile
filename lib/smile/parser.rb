module Smile
  class Parser
    def initialize(tokens)
      @tokens = tokens.dup
    end

    # Returns a list of statements, e.g.
    #   [[:push_right, 6], [:putc_right]]
    def parse
      stmts, _term = parse_seq([])
      stmts
    end

    # Parse statements until one of +terminators+ (or EOF) is reached.
    # Returns [statements, terminator_token] (terminator_token is nil at EOF).
    def parse_seq(terminators)
      ret = []
      loop do
        token = @tokens[0]
        return [ret, nil] if token.nil?
        if terminators.include?(token)
          @tokens.shift
          return [ret, token]
        end

        @tokens.shift
        case token
        when :push_left, :push_right
          ret << [token, parse_num]
        when :loop_left_start
          body, _ = parse_seq([:loop_left_end])
          ret << [:loop_left, body]
        when :loop_right_start
          body, _ = parse_seq([:loop_right_end])
          ret << [:loop_right, body]
        when :if_left_start
          ret << parse_if(:if_left, :if_left_end)
        when :if_right_start
          ret << parse_if(:if_right, :if_right_end)
        when Integer, Array
          # A bare numeric digit without a preceding push: ignore.
        else
          ret << [token]
        end
      end
    end

    def parse_if(kind, end_token)
      then_body, term = parse_seq([:else, end_token])
      else_body = []
      if term == :else
        else_body, _ = parse_seq([end_token])
      end
      [kind, then_body, else_body]
    end

    def parse_num
      digits = []
      neg = false
      sign_seen = false
      loop do
        token = @tokens[0]
        if token.is_a?(Integer)
          raise "number parse error: mixed sign" if sign_seen && neg
          neg = false; sign_seen = true
          digits << token
          @tokens.shift
        elsif token.is_a?(Array) && token[0] == :neg_digit
          raise "number parse error: mixed sign" if sign_seen && !neg
          neg = true; sign_seen = true
          digits << token[1]
          @tokens.shift
        else
          break
        end
      end
      raise "number expected" if digits.empty?
      n = digits.join.to_i
      neg ? -n : n
    end

  end
end
