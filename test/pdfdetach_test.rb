# frozen_string_literal: true

require 'test_helper'

# :nodoc:
class PDFDetachTest < TestCase
  def teardown
    PDFDetach.configuration.binary_path = nil
  end

  def test_pdfdetach_version
    refute_nil PDFDetach::VERSION
  end

  def test_configure_pdfdetach
    assert PDFDetach.respond_to?(:configure)
    assert_nil PDFDetach.configuration.binary_path
    PDFDetach.configure do |config|
      config.binary_path = '/usr/bin/pdfdetach'
    end
    assert_equal '/usr/bin/pdfdetach', PDFDetach.configuration.binary_path
  end

  def test_list_files_attached_to_pdf
    pdf = PDFDetach.new('test/fixtures/example_041.pdf')
    assert pdf.respond_to?(:list)
    files = pdf.list
    assert files.is_a? Array
    assert_equal 2, files.size
  end

  def test_detach_files_from_pdf
    output_path = File.expand_path('../tmp/', __dir__)
    pdf = PDFDetach.new('test/fixtures/example_041.pdf')
    files = pdf.list
    pdf.saveall({ output: output_path })
    files.each do |file| 
      assert File.exist?("#{output_path}/#{file}")
    end
  end
end
