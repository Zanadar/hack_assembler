class Parser
  attr_accessor :command

  def initialize(in_stream)
    @file = in_stream
    @command = command
  end

  def hasMoreCommands
    !@file.eof?
  end

  def advance
    begin
      command = @file.gets.strip
      clean_comments = command.split(/\/{2}/)[0] || ""
      @command = clean_comments
    end while command_type == nil # So that the commands advance (run at least once)
  end

  def command_type
    blankLine = /^\s*(#|$)/
    if @command[0..1] == '//' || @command.match(blankLine)
      return nil
    elsif @command.match(/(?=\s*)@/)
      return :A_COMMAND
    elsif @command.match(/(?=\s*)\(/)
      return :L_COMMAND
    else
      return :C_COMMAND
    end
  end

  def rewind
    @file.rewind
  end

  def symbol
    if command_type == :A_COMMAND
      return @command[1..-1]
    elsif command_type == :L_COMMAND
      return @command[1..-2]
    end
  end

  def dest
    return if not_c_command
    dst = get_c_part[0]
    dst ||= 'null'
  end

  def comp
    return if not_c_command
    get_c_part[1]
  end

  def jump
    return if not_c_command
    jmp = get_c_part[2]
    jmp ||= 'null' # assign to null if its nil
  end

  def c_parts
    [dest, comp, jump]
  end

  private

  def get_c_part
    clean = @command.split(/\/{2}/)[0]
    command = clean.split('=').flat_map{|x| x.split(';')}.map{|x| x.strip()}
    if @command.match(';')
      command = [nil, command[0], command[1]] # for empty dest
    end
    command
  end

  def not_c_command
    command_type != :C_COMMAND
  end
end
