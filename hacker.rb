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
        puts @parser.whole
      else
        puts @parser.symbol
      end
    end
  end
end
