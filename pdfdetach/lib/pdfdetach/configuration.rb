# frozen_string_literal: true

# :nodoc:
class PDFDetach
  # Catch and configure pdfdetach binary path
  class Configuration
    attr_accessor :binary_path

    def initialize
      @binary_path = nil
    end
  end

  # On a initializer or somewhere else in your code, if you want to use a different version or binary
  # instead of the binary provided in this gem, you can assign a path for a binary like this:
  #
  #   PDFDetach.configure do |config|
  #     config.binary_path = 'path/to/pdfdetach'
  #   end
  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
