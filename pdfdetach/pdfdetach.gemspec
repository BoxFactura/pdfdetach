# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'pdfdetach/version'
require 'pdfdetach/main'

Gem::Specification.new do |s|
  s.name        = 'pdfdetach'
  s.version     = PDFDetach::VERSION
  s.authors     = ['Alvaro Cabrera']
  s.email       = ['pateketrueke@gmail.com']
  s.homepage    = 'https://github.com/pateketrueke/pdfdetach'
  s.summary     = %q{Ruby wrapper for pdfdetach executable}

  s.description = %q{Binaries for pdfdetach (poppler-utils) that runs on Ubuntu}

  s.require_paths = ['lib']

  s.add_development_dependency 'test-unit', '>= 2.3.0'
end
