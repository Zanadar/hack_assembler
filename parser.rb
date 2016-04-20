require 'pry'

class Parser
  attr_accessor :command

  def initialize(stream)
    @file = stream
    @command = ''
  end

  def hasMoreCommands
    !@file.eof?
  end

  def advance
    @command = @file.gets
  end

  def commandType
    blankLine = /^\s*(#|$)/
    if @command[0] == '@'
      return :A_COMMAND
    elsif
      @command[0] == '('
      return :L_COMMAND
    elsif
      @command[0..1] == '//' || blankLine.match(command)
      return nil
    else
      return :C_COMMAND
    end
  end

  def symbol
    if commandType == :A_COMMAND
      return "%016b" % @command[1..-1]
    elsif commandType == :L_COMMAND
      return "%016b" % @command[1..-2]
    end
  end

  def whole
    [dest, comp, jump]
  end

  def dest
    return if not_c_command
    dst = parts[0]
    dst ||= 'null'
  end

  def comp
    return if not_c_command
    parts[1]
  end

  def jump
    return if not_c_command
    jmp = parts[2]
    jmp ||= 'null' # assign to null if its nil
  end

  private

  def parts
    @command.split('=').flat_map{|x| x.split(';')}.map{|x| x.strip()}
  end

  def not_c_command
    commandType != :C_COMMAND
  end
end
