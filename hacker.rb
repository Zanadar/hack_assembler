require_relative './parser'
require_relative './code'
require_relative './symbol_table'

class Hacker
  def initialize(args)
    @file_path = args[0]
    @output_file = setup_output_file
    @parser = Parser.new(setup_input_file)
    @table = SymbolTable.new
  end

  def run
    first_pass
    second_pass
  end

  private

  def first_pass
    while @parser.hasMoreCommands
      @parser.advance
      allocate_symbols
    end
    @parser.rewind
  end

  def second_pass
    while @parser.hasMoreCommands
      @parser.advance
      if type == :C_COMMAND
        line = process_C_command
      elsif type == :A_COMMAND
        line = process_A_command
      else
        next #skip this iteration of the loop
      end
      @output_file.write(line+"\n")
    end
    @output_file.close
  end

  def type
    @parser.command_type
  end

  def setup_input_file
    fd = IO.sysopen(@file_path) #defaults to 'r'
    file_stream = IO.new(fd, 'r')
    file_stream
  end

  def setup_output_file
    new_path = File.basename(@file_path, ".*")
    File.new(File.dirname(__FILE__) + "/#{new_path}.hack", "w+")
  end

  def allocate_symbols
    if  type == :A_COMMAND || type == :C_COMMAND
      @table.rom+=1
    else
      @table.table[@parser.symbol] = @table.rom
    end
  end

  def process_commands
  end

  def process_A_command
    symbol = @parser.symbol
    if symbol.is_a? Numeric
      address = symbol
    elsif !address = @table.table[symbol]
      address = @table.store_variable(symbol)
    else
      address = @table.table[symbol]
    end
    "%016b" % address
  end

  def process_C_command
    dest, comp, jump = @parser.c_part_symbols
    '111' + Code::COMP[comp] + Code::DEST[dest] + Code::JMP[jump]
  end
end
