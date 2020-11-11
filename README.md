# dim

compile [D](https://dlang.org) programs that uses the [importd](https://github.com/onerbs/importd) library


## Installation

if you wish to symlink the `dim` script into `~/.local/bin`; then run:

	./symlink

else if you prefer to use a different prefix then run:

	./symlink /your/prefix

> the above will symlink to `/your/prefix/dim`<br>
> make sure it is in your `PATH` *!*


## Usage

to use `dim` is easy:

	$ dim FILE [OPTIONS]

the available options are:

- `-o OUTFILE` - the output file name (as-is)
- `-plu MODULES` - the list of [plu](https://github.com/onerbs/importd/tree/master/plu) modules
- `-dmd DFLAGS` - the list of extra [dmd flags](https://dlang.org/dmd-linux.html) to pass to the compiler
- `-u` - run unit tests
- `-r` - make release
- `-n` - do not run after compile
- `-t ARGS` - the testing arguments. this flag **must** be the last

also, get help at any time with:

	$ dim [-h | --help]
