# PDFDetach

This repository downloads the binaries, e.g. `pdfdetach` and publish them back as i.e. a ruby-gem &mdash; suitable for Ubuntu 16.04, 18.04 and 20.04.

## How it works?

On the target system: overloading the `LD_LIBRARY_PATH` variable allows to execute arbitrary binaries, abusing of that we can ship those and their required `.so` files within a tarfile.

- First we setup a docker image with an particular Ubuntu version:
  - install the binary of our interest, then we use `docker cp` to get a copy
  - retrieve the used `.so` files the binary uses with `ldd`, also we get a copy of them
- Now we have the binaries, they are copied inside our `bin` directory:
  - they are released using `git worktree` &mdash; it turns out you can use directories as branches, like for `gh-pages` we're using it for pushing final files only
  - they are ignored by default on the main repository &mdash; but a `.gitignore` is placed inside this new branch with `bin/*` to sill ignore all binaries and, i.e. `!bin/20.04` to actually skip the desired version of binaries
- The ruby-gem is written as usual but the `version.rb` gets rewritten on release time to match the target environment, a `LIB_TARGET` constant is set as i.e. `20.04` (or `18.04`, etc.)
  - you don't need to modify this file, the `make release` task will setup that for you &mdash; also you can set `MAJOR` and `PATCH` for specific version values, the `MINOR` will be `20`, `18` or `16` according the target runtime, e.g. `make release TAG=v16 PATCH=2 MAJOR=1` will be `1.16.2`
  - probably you can use something else, not just ruby &mdash; try hacking the `Makefile` to match another stack, just keep in mind the `bin` folder shouls remain inside the created directory!
  - [official release as ruby-gem is still pending...]

> `Makefile` can be configured to fetch another binaries, see the `PKG`, `DEPS` and `ARGS` variables &mdash; see how dependencies are fetched on the `install.sh` script.

## Integration tests

If you're on a system with Docker running:

- type `make` to setup all docker images required
- type `make test` to run the available tests on each of them

> Try `make dev` to spawn a Bash session: once inside Ubuntu, type `make check`

## Publishing modules

We're using Ruby as the target language, see the `pdfdetach/lib/pdfdetach/main.rb` file to see how the wrapper works.

The `make release` task will care about the versioning bits, it will commit on a separated branch each release with their respective binaries also commited.

> To release a particular version try `make release TAG=v16`

## Using this module

Include it in your Gemfile, make sure to set the version to the Ubuntu release you'll be using it on.

```ruby
# For Ubuntu 20.04
gem 'pdfdetach', '0.20.1'
```

## Licensing

This gem is available as open source under the terms of the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.txt)

[Poppler](https://gitlab.freedesktop.org/poppler/poppler) is licensed under the [GNU General Public License v2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)
