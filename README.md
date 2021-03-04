PDFDetach
===

## Installation

Include it in your Gemfile, make sure to set the version to the Ubuntu release you'll be using it on.

```ruby
# For Ubuntu 20.04
gem 'pdfdetach', '0.20.1'
```

## Usage

List files attached to a PDF

```ruby
pdfdetach = PDFDetach.new('path/to/pdf_with_attachments.pdf')
files = pdfdetach.list
```

Save all attached files

```ruby
pdfdetach = PDFDetach.new('path/to/pdf_with_attachments.pdf')
pdfdetach.saveall(output: 'path/to/output')

```

## Local vs. production

You can override the bundled binary with a the binary installed in your system via an initializer

```ruby
if ENV.fetch('PDFDETACH_PATH', '').present?
  PDFDetach.configure do |config|
    config.binary_path = ENV.fetch('PDFDETACH_PATH')
  end
end
```

Just make sure the environment variable `PDFDETACH_PATH` is the full path to your local binary. If you're using dotenv you could so something like this:

```
PDFDETACH_PATH=$(which pdfdetach)
```

### Build instructions

If you need to target some other environment, please refer to the [build instructions](BUILD_INSTRUCTIONS.md)


## Licensing

This gem is available as open source under the terms of the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.txt)

[Poppler](https://gitlab.freedesktop.org/poppler/poppler) is licensed under the [GNU General Public License v2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)
