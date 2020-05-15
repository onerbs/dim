# dim

compile [D](https://dlang.org) programs that uses the [importd](https://github.com/onerbs/importd) library

## Add to your PATH

if you wish to symlink the `dim` script to `~/.local/bin/dim` then run:
``` bash
./mk-symlink
```

else if you prefer to use a different prefix then run:
``` bash
./mk-symlink /your/prefix
```
> the above will symlink to `/your/prefix/bin/dim`

(or) if you prefer the prefix without the `/bin` at the end then run:
``` bash
./mk-symlink /your/prefix -q
```
> the above will symlink to `/your/prefix/dim`

## Usage

to use `dim` is easy:
``` bash
dim file[.d] [OPTIONS]
```
the available options are:
- `-plu MODULES` - the list of [plu](https://github.com/onerbs/importd/tree/master/plu) modules
- `-t ARGS` - the testing arguments
- `-o OUTFILE` - the output file name
- `-u` - run unit tests
- `-r` - make release
- `-q` - do not run after compile

**note:** if both `-t` and `-q` flags are present, only the last one will apply
