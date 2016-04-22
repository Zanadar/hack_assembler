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
        dest, comp, jump = @parser.c_parts
        line = '111' + Code::COMP[comp.to_sym] + Code::DEST[dest.to_sym] + Code::JMP[jump.to_sym]
      elsif type == :A_COMMAND
        binding.pry
        address = @table.table[@parser.command.to_sym]
        line = "%016b" % address
      else
        binding.pry
        line = "%016b" % @parser.symbol
      end
      @output_file.write(line+"\n")
    end
    @output_file.close
  end

  def type
    @parser.command_type
  end
end
