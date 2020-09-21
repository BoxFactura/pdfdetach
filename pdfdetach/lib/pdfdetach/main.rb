# frozen_string_literal: true

require 'pathname'

# PDFDetach is wrapper around poppler's pdfdetach utils command
#
class PDFDetach
  # @param filepath [String]
  def initialize(filepath)
    @src = filepath
    @base_path = Pathname.new("#{__dir__}/../../bin/#{LIB_TARGET}").cleanpath
    @binary_path = PDFDetach.configuration.binary_path
  end

  # @param options [Hash]
  def get_opts(options)
    args = String.new
    args << " -o #{options[:output]} " if options[:output]
    args << " -enc #{options[:encoding]} " if options[:encoding]
    args << " -opw #{options[:owner_password]} " if options[:owner_password]
    args << " -upw #{options[:user_password]} " if options[:user_password]
    args
  end

  # List all files attached
  #
  # @return [Array]
  #
  def list
    result = run("-list #{@src}")

    list ||= if result[:ok]
               result[:out].split("\n").map do |line|
                 next line.match(/^(\d+): (.+?)$/) { |m| m[2] } if line =~ /^(\d+):/
               end
             else
               []
             end
    list.compact
  end

  # Save all attached files in the pdf
  #
  # @param options [Hash]
  #
  def saveall(options = {})
    run("-saveall #{get_opts(options)} #{@src}")[:ok]
  end

  private

  def run(args)
    output = if @binary_path.nil? || @binary_path&.empty?
               `LD_LIBRARY_PATH=#{@base_path}/lib #{@base_path}/pdfdetach #{args}`
             else
               `#{@binary_path} #{args}`
             end

    { ok: $?.success?, out: output }
  end
end
