# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'fileutils'
require 'pdfdetach'

dest_path = "#{__dir__}/tmp"
src_file = "#{__dir__}/example_041.pdf"

FileUtils.mkdir_p(dest_path) unless File.directory?(dest_path)

puts "OS target: #{PDFDetach::LIB_TARGET}"
pdf = PDFDetach.new(src_file)

puts pdf.list
puts pdf.saveall({ output: dest_path })
