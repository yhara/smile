module Smile
  class Evaluator
    def initialize(codes)
      @codes = codes

      @deque = []
    end

#[[:push_right, 9],
# [:loop,
#   [[:dup], [:putn_right], [:sub]]]]
    def eval_loop(codes)
      loop do
        flag = @deque.shift
        if flag == 0
          break
        else
          _eval(codes)
        end
      end
    end

    def eval
      _eval(@codes)
    end
    
    def _eval(codes)
      codes.each do |opecode, operand|
        $stderr.puts "#{opecode} #{operand.inspect} : #{@deque.inspect}"
        case opecode
        when :push_right
          @deque << operand
        when :putc_right
          n = @deque.pop
          print n.chr
        when :putn_right
          n = @deque.pop
          print n
        when :dup_right
          n = @deque.pop
          @deque << n
          @deque << n
        when :sub_right
          a = @deque.pop
          b = @deque.pop
          @deque << (a - b)
        when :loop
          eval_loop(operand)
        else
          raise "unknown op: #{opecode}"
        end
      end
    end

  end
end
