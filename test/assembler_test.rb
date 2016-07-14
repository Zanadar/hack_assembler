require 'minitest/autorun'
require_relative '../hacker'

describe Hacker do
  it "parses hack assembly files and outputs *.hack binary code" do
    assembly_files = Dir['./test/fixtures/*.asm']

    assembly_files.each do |file|
      `./bin/hacksemble #{file}`
      base, _ = File.basename(file).split('.')
      hackfile = base + '.hack'

      newfile = open(hackfile)
      oldfile = open("./test/fixtures/proper/#{hackfile}")

      newfile.readlines.must_equal oldfile.readlines
      File.delete(hackfile)
    end
  end
end

