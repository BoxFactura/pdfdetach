require 'pathname'

class PDFDetach
  def initialize(filepath)
    @src = filepath
    @base_path = Pathname.new("#{__dir__}/../../bin/#{LIB_TARGET}").cleanpath
    @binary_path = `which pdfdetach`.chop
  end

  def get_opts(hash)
    args = ''
    args << " -o #{hash[:output]} " if hash[:output]
    args << " -enc #{hash[:encoding]} " if hash[:encoding]
    args << " -opw #{hash[:owner_password]} " if hash[:owner_password]
    args << " -upw #{hash[:user_password]} " if hash[:user_password]
    args
  end

  def list(opts = {})
    result = run("-list #{@src}")
    files = []

    if result[:ok]
      lines = result[:out].split("\n")
      for line in lines
        if line =~ /^(\d+):/
          files << line.match(/^(\d+): (.+?)$/) { |m| m[2] }
        end
      end
    end

    files
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
    output = if @binary_path.empty?
      `LD_LIBRARY_PATH=#{@base_path}/lib #{@base_path}/pdfdetach #{args}`
    else
      `#{@binary_path} #{args}`
    end

    { :ok => $?.success?, :out => output }
  end
end
