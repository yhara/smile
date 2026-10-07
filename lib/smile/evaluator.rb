module Smile
  class Evaluator
    def initialize(codes)
      @codes = codes
      @deque = []
    end

    def eval
      catch(:smile_exit) do
        eval_stmts(@codes)
      end
    end

    def eval_stmts(codes)
      codes.each do |code|
        op = code[0]
        #$stderr.puts "#{op} #{code[1..].inspect} : #{@deque.inspect}"
        case op
        # --- Deque: push ---
        when :push_left  then push(:left,  code[1])
        when :push_right then push(:right, code[1])

        # --- Arithmetic ---
        when :add_left   then binop(:left)  { |a, b| a + b }
        when :add_right  then binop(:right) { |a, b| a + b }
        when :sub_left   then binop(:left)  { |a, b| a - b }
        when :sub_right  then binop(:right) { |a, b| a - b }
        when :mul_left   then binop(:left)  { |a, b| a * b }
        when :mul_right  then binop(:right) { |a, b| a * b }
        when :div_left   then binop(:left)  { |a, b| a / b }
        when :div_right  then binop(:right) { |a, b| a / b }
        when :mod_left   then binop(:left)  { |a, b| a % b }
        when :mod_right  then binop(:right) { |a, b| a % b }

        # --- Bitwise ---
        when :bitor_left   then binop(:left)  { |a, b| a | b }
        when :bitor_right  then binop(:right) { |a, b| a | b }
        when :bitand_left  then binop(:left)  { |a, b| a & b }
        when :bitand_right then binop(:right) { |a, b| a & b }
        when :bitxor_left  then binop(:left)  { |a, b| a ^ b }
        when :bitxor_right then binop(:right) { |a, b| a ^ b }
        when :not_left     then unop(:left)  { |a| a == 0 ? 1 : 0 }
        when :not_right    then unop(:right) { |a| a == 0 ? 1 : 0 }

        # --- Comparison (push 1 for true, 0 for false) ---
        when :greater_left  then binop(:left)  { |a, b| a > b ? 1 : 0 }
        when :greater_right then binop(:right) { |a, b| a > b ? 1 : 0 }
        when :less_left     then binop(:left)  { |a, b| a < b ? 1 : 0 }
        when :less_right    then binop(:right) { |a, b| a < b ? 1 : 0 }
        when :ge_left       then binop(:left)  { |a, b| a >= b ? 1 : 0 }
        when :ge_right      then binop(:right) { |a, b| a >= b ? 1 : 0 }
        when :le_left       then binop(:left)  { |a, b| a <= b ? 1 : 0 }
        when :le_right      then binop(:right) { |a, b| a <= b ? 1 : 0 }
        when :equal_left    then binop(:left)  { |a, b| a == b ? 1 : 0 }
        when :equal_right   then binop(:right) { |a, b| a == b ? 1 : 0 }

        # --- Deque manipulation ---
        when :swap_left    then swap(:left)
        when :swap_right   then swap(:right)
        when :dup_left     then n = pop(:left);  push(:left, n);  push(:left, n)
        when :dup_right    then n = pop(:right); push(:right, n); push(:right, n)
        when :discard_left  then pop(:left)
        when :discard_right then pop(:right)
        when :rotate_left  then push(:right, pop(:left))
        when :rotate_right then push(:left,  pop(:right))

        # --- I/O ---
        when :putc_left  then print pop(:left).chr
        when :putc_right then print pop(:right).chr
        when :putn_left  then print pop(:left)
        when :putn_right then print pop(:right)
        when :getc_left  then push(:left,  read_char)
        when :getc_right then push(:right, read_char)
        when :getn_left  then push(:left,  read_num)
        when :getn_right then push(:right, read_num)

        # --- Control flow ---
        when :loop_left  then eval_loop(:left,  code[1])
        when :loop_right then eval_loop(:right, code[1])
        when :if_left    then eval_if(:left,  code[1], code[2])
        when :if_right   then eval_if(:right, code[1], code[2])
        when :exit       then throw :smile_exit

        else
          raise "unknown op: #{op}"
        end
      end
    end

    def eval_loop(dir, codes)
      loop do
        flag = (dir == :left ? @deque.first : @deque.last)
        break if flag.nil? || flag == 0
        eval_stmts(codes)
      end
    end

    def eval_if(dir, then_body, else_body)
      if pop(dir) != 0
        eval_stmts(then_body)
      else
        eval_stmts(else_body)
      end
    end

    # Apply a binary operation, consuming two values from +dir+ and pushing
    # the result back. The value pushed first is +a+, the one on top is +b+,
    # so e.g. "push a, push b, sub" yields a - b.
    def binop(dir)
      b = pop(dir)
      a = pop(dir)
      push(dir, yield(a, b))
    end

    def unop(dir)
      push(dir, yield(pop(dir)))
    end

    def swap(dir)
      x = pop(dir)
      y = pop(dir)
      push(dir, x)
      push(dir, y)
    end

    def push(dir, n)
      case dir
      when :left  then @deque.unshift(n)
      when :right then @deque.push(n)
      else raise "[BUG]"
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

    def read_char
      c = $stdin.getc
      c ? c.ord : -1
    end

    def read_num
      line = $stdin.gets
      line ? line.to_i : -1
    end

  end
end
