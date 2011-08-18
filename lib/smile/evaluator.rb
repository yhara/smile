module Smile
  class Evaluator
    def initialize(codes)
      @codes = codes

      @deque = []
    end

    def eval
      eval_stmts(@codes)
    end
    
    def eval_stmts(codes)
      codes.each do |opecode, operand|
        #$stderr.puts "#{opecode} #{operand ? operand.inspect : ''} : #{@deque.inspect}"
        case opecode
        when :push_right
          @deque << operand
        when :putc_right
          n = pop(:right)
          print n.chr
        when :putn_right
          n = pop(:right)
          print n
        when :dup_right
          n = pop(:right)
          @deque << n
          @deque << n
        when :sub_right
          b = pop(:right)
          a = pop(:right)
          @deque << (a - b)
        when :loop
          eval_loop(operand)
        else
          raise "unknown op: #{opecode}"
        end
      end
    end

    def eval_loop(codes)
      loop do
        flag = @deque[0]
        if flag == 0
          break
        else
          eval_stmts(codes)
        end
      end
    end

    def pop(dir)
      if @deque.empty?
        raise RuntimeError, "Tried to pop from empty deque"
      end
      case dir
      when :right then @deque.pop
      when :left  then @deque.shift
      else
        raise "[BUG]"
      end
    end

  end
end
