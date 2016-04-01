class Parser
  def initialize(file_path)
    @file = File.open(file_path)
    @command = ''
  end

  def hasMoreCommands
    @file.eof?
  end

  def advance
    @command = @file.gets('\n')
  end

  def commandType
    # May want to memoize this?
    if @command[0] = '@'
      return :A_COMMAND
    elsif
      @command[0]= '('
      return :L_COMMAND
    else
      return :C_COMMAND
    end
  end

  def symbol
    return nil if commandType == :L_COMMAND
    if commandType == :A_COMMAND
      return @command[1..-1]
    else
      return @command[1..-2]
    end
  end

  def dest
    return if not_c_command
    parts[0]
  end

  def comp
    return if not_c_command
    parts[1]
  end

  def jump
    return if not_c_command
    parts[2]
  end

  private
  def parts
    @command.scan(/(.*)\=(.*)\;(.*)/)
  end

  def not_c_command
    commandType != :C_COMMAND
  end
end
