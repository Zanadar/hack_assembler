require_relative './parser'
require_relative './code'


class Hacker
  def initialize(args)
    @args = args
    file_path = @args[0]
    fd = IO.sysopen(file_path) #defaults to 'r'
    file_stream = IO.new(fd, 'r')
    @parser = Parser.new(file_stream)
  end

  def run
    while @parser.hasMoreCommands
      @parser.advance
      if @parser.commandType == :C_COMMAND
        dest, comp, jump = @parser.whole
        puts Code::DEST[dest.to_sym] + Code::COMP[comp.to_sym]
        puts Code::JMP[jump.to_sym] if jump != nil
      else
        puts @parser.symbol
      end
    end
  end
end
