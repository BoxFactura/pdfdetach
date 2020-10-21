# frozen_string_literal: true

$:.push File.expand_path('../lib', __FILE__)
require 'pdfdetach/version'
require 'pdfdetach/main'

Gem::Specification.new do |s|
  s.name        = 'pdfdetach'
  s.version     = PDFDetach::VERSION
  s.authors     = ['Alvaro Cabrera']
  s.email       = ['pateketrueke@gmail.com']
  s.homepage    = 'https://github.com/pateketrueke/pdfdetach'
  s.summary     = %(Ruby wrapper for pdfdetach executable)

  s.description = %{Binaries for pdfdetach (poppler-utils) that runs on Ubuntu}

  s.require_paths = ['lib']
  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.add_development_dependency 'minitest'
end
