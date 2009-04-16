# Copyright (c) 2007-2009 by Reto Schüttel <reto (ät) schuettel (dut) ch>

# Please contact me if you like this released under a OSS license!

class Rudoku
  NRS = { 1 => true, 2 => true, 3 => true,
          4 => true, 5 => true, 6 => true,
          7 => true, 8 => true, 9 => true, }

  class Board
    attr_accessor :fields, :blocks, :rows, :cols

    def initialize(board)
      @fields = []
      @board  = []
      @rows   = []
      @cols   = []
      @blocks = []
      @missing = []
      @stats = {
        :missing => 0,
        :solved_by_only_one_possible => 0,
        :solved_by_no_other_possible => 0,
        :solved_by_presolve => 0
      }

      # initialize rows, columns & blocks
      0.upto(8) do |i|
        @rows[i]   = Row.new(self, i)
        @cols[i]   = Col.new(self, i)
        @blocks[i] = Block.new(self, i)
      end

      board.each_with_index do |row, y|
        @board[y] = []

        row.each_with_index do |value, x|
          f = @board[y][x] = Field.new(self, x, y)
          f.value = value
          @fields << f
          @missing << f if f.missing?
        end
      end

      @stats[:missing] = @missing.length

      @counter = 0

      raise "Invalid field" if not valid_field?
    end


    def pre_solve
      begin
        #puts "try"
        changed = @missing.reject! do |f|
          # create a list of all fields which are wmissing
          # in the same block, not including t the current field f
          nrs = f.available_nrs


          #puts "#{f} hat #{nrs.length} möglichkeiten: #{nrs.join(" ")}" if nrs.length == 2
          #f.mark if nrs.length ==2
          if nrs.length == 1
            #puts "ONLY: nur noch #{ nrs.first } moeglich in feld #{ f }"
            @stats[:solved_by_only_one_possible] += 1
            #f.mark
            f.value = nrs.first
            true
          else
            # use the scanning method for possible other solutions
            # returns false or true

            if v = f.nr_only_possible_in_this_field
              f.mark
              raise "in #{f} is only #{v} possible"
              #puts "SCANNING: nr #{ v } ist nur noch im feld #{ f }"
              @stats[:solved_by_no_other_possible] += 1
              f.value = v
              #f.mark
              #return
              true
            else
              false
            end
          end
        end
      end while changed

      @stats[:solved_by_presolve] =
      @stats[:solved_by_no_other_possible] +
      @stats[:solved_by_only_one_possible]
    end

    # returns false if there's no possible next move, else return the valid path
    def solve(level = 0)
      fm = @missing.shift

      if fm.nil?
        return true
      end

      available_nrs = fm.available_nrs

      unless available_nrs.empty?
        # try all the available nrs on this field
        available_nrs.each do |nr|

          raise "nr is nil??" if nr.nil?
          # set it
          fm.value = nr

          # and try to fill the next field
          result = solve(level + 1)

          # return true if we found a solution
          return true if result
        end
      end

      # seems like we are in a 'sackgasse', reset the value and
      # go back to the next stepp
      fm.value = nil
      @missing.unshift(fm)

      return false
    end

    def print_field(p = [])
      p = [p] unless p.kind_of?(Array)

      @board.each_with_index do |row, y|
        #row.map{|f| f.value}.map{|f| f || "_"}.each_with_index do |f, x|
        row.each_with_index do |f, x|
          t = ( f.value ? f.value.to_s : "_" ) + ( f.marked? ? "<" : " " )

          print "#{t} "

          #if p.any?{|o| x == o.x && y == o.y}
          #  print "#{f}<"
          #else
          #  print "#{f} "
          #end
          print " " if x % 3 == 2
        end
        puts
        puts if y % 3 == 2
      end

      #puts "Lösung"
      #0.upto(8) do |i|
      # print "#{@board[i][i].value} "
      #end
     #puts

      #puts
      puts "Stats"
      @stats.each do |key, value|
        puts "#{key}: #{value}"
      end

    end

    def valid_field?
      true
    end

    def get(x, y)
      @board[y][x]
    end

    def get_row(y)
      @rows[y]
    end

    def get_col(x)
      @cols[x]
    end

    def get_block(x, y)
      block_nr = x / 3 + y/3*3
      @blocks[block_nr] or raise "Unitialized block at #{x}/#{y} block_nr #{block_nr}"
    end

    def find_first_missing
      @fields.find{|f| f.missing?}
    end
  end

  class Field
    attr_reader :x, :y, :value, :block

    def initialize(board, x, y)
      @board = board
      @x = x
      @y = y
      @marked = false

      @row   = @board.get_row(y) or raise
      @col   = @board.get_col(x) or raise
      @block = @board.get_block(x, y) or raise
    end

    def mark
      @marked = true
    end

    def marked?
      @marked
    end

    def value=(v)
      unless value.nil?
        add(value)
      end

      unless v.nil?
        remove(v)
      end
      @value = v
    end

    def remove(v)
      @block.remove(v)
      @row.remove(v)
      @col.remove(v)
    end

    def add(v)
      @block.add(v)
      @row.add(v)
      @col.add(v)
    end

    def missing?
      @value.nil?
    end

    def available_nrs
      @row.available_nrs & @col.available_nrs & @block.available_nrs
    end

    def to_s
      x.to_s + ":" + y.to_s
    end

    def nr_only_possible_in_this_field
      neighbours = block.missing_fields.reject{|m| m == self}

      available_nrs.each do |nr|
        # iterate over all neighbours and check if theres a Nr (nr)
        # which can't be anywere else
        if neighbours.all?{|n| not n.available_nrs.include?(nr) }
          # okay, nr isn't possible in all the other missing
          # fields in the neighbourhood, that means it can only be
          # on f
          return nr
        end
      end

      nil
    end

  end

  class Area
    attr_reader :board

    def initialize(b, coord)
      @available_nrs = NRS.dup
      @board = b or raise "b not defined"
    end

    def available_nrs
      @available_nrs.keys
    end

    def remove(v)
      raise if v == true

      @available_nrs.delete(v)
      raise "bb" if v == true
    end

    def add(v)
      @available_nrs[v] = true
    end

    def info(mode, v)
       #puts "#{type} #{mode} #{v} available_nrs contains #{@available_nrs.join(", ")}"
    end

    def missing_fields
      if fields.nil?
        initialize_area
      end

      fields.reject{|f| not f.missing?}
    end
  end

  class Row < Area
    def initialize(b, y)
      @y = y
      super
    end

    def type
      "row #{@y}"
    end
  end

  class Col < Area
    def initialize(b, x)
      @x = x
      super
    end

    def type
      "col #{@x}"
    end
  end

  class Block < Area
    attr_reader :fields
    def initialize(b, n)
      @n = n
      @x = n % 3
      @y = n / 3
      super
    end

    def initialize_area
      f_x = @x * 3
      f_y = @y * 3

      @fields = []

      f_x.upto(f_x + 2) do |x|
        f_y.upto(f_y + 2) do |y|
          @fields << board.get(x, y)
        end
      end
    end
  end
end
