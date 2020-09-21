# frozen_string_literal: true

class PDFDetach
  class Configuration
    attr_accessor :binary_path

    def initialize
      @binary_path = nil
    end
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
