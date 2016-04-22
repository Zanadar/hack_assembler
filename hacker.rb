require_relative './parser'
require_relative './code'
require_relative './symbol_table'
require 'pry-byebug'

class Hacker
  def initialize(args)
    @args = args
    file_path = @args[0]
    fd = IO.sysopen(file_path) #defaults to 'r'
    file_stream = IO.new(fd, 'r')
    new_path = File.basename(file_path, ".*")
    @output_file = File.new(File.dirname(__FILE__) + "/#{new_path}.hack", "w+")
    @parser = Parser.new(file_stream)
    @table = SymbolTable.new
  end

  def run
    first_pass
    second_pass
  end

  def first_pass
    while @parser.hasMoreCommands
      @parser.advance
      if  type == :A_COMMAND || type == :C_COMMAND
        @table.rom+=1
      else
        @table.table[@parser.symbol] = @table.rom
      end
    end
    @parser.rewind
  end

  def second_pass
    while @parser.hasMoreCommands
      @parser.advance
      if type == :C_COMMAND
        dest, comp, jump = @parser.c_part_symbols
        line = '111' + Code::COMP[comp] + Code::DEST[dest] + Code::JMP[jump]
      elsif type == :A_COMMAND
        symbol = @parser.symbol
        if !address = @table.table[symbol]
          address = @table.store_variable(symbol)
        end
        line = "%016b" % address
      else # :L_Command
        line = "%016b" % @table.table[@parser.symbol]
      end
      @output_file.write(line+"\n")
    end
    @output_file.close
  end

  def type
    @parser.command_type
  end
end
