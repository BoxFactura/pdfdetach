# frozen_string_literal: true

require 'pathname'

# :nodoc:
class PDFDetach
  # @param filepath [String]
  # @param binary_path [String]
  def initialize(filepath, binary_path: '')
    @src = filepath
    @base_path = Pathname.new("#{__dir__}/../../bin/#{LIB_TARGET}").cleanpath
    @binary_path = binary_path
  end

  def get_opts(hash)
    args = String.new
    args << " -o #{hash[:output]} " if hash[:output]
    args << " -enc #{hash[:encoding]} " if hash[:encoding]
    args << " -opw #{hash[:owner_password]} " if hash[:owner_password]
    args << " -upw #{hash[:user_password]} " if hash[:user_password]
    args
  end

  def list
    result = run("-list #{@src}")

    files = if result[:ok]
              result[:out].split("\n").map do |line|
                next line.match(/^(\d+): (.+?)$/) { |m| m[2] } if line =~ /^(\d+):/
              end
            else
              []
            end
    files.compact
  end

  def save(offset, opts = {})
    run("-save #{offset} #{get_opts(opts)} #{@src}")[:ok]
  end

  def savefile(filename, opts = {})
    run("-savefile #{filename} #{get_opts(opts)} #{@src}")[:ok]
  end

  def saveall(opts = {})
    run("-saveall #{get_opts(opts)} #{@src}")[:ok]
  end

  def run(args)
    output = if @binary_path&.empty?
               `LD_LIBRARY_PATH=#{@base_path}/lib #{@base_path}/pdfdetach #{args}`
             else
               `#{@binary_path} #{args}`
             end

    { ok: $?.success?, out: output }
  end
end
