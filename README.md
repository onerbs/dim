# dim

## Add to your PATH

If you wish to symlink this script to `~/.local/bin/dim` simply run:
``` bash
./mk-symlink
```

Or if you prefer to use a different prefix then run:
``` bash
./mk-symlink /your/prefix
```
the above will symlink to `/your/prefix/dim`.

## Usage

Using `dim` is easy:

``` bash
dim file[.d] [OPTIONS]
```

The available options are:

- `-plu *MODULE` The list of [importd/plu](https://github.com/onerbs/importd/tree/master/plu) modules
- `-t *ARGS` The testing arguments
- `-o OUTPUT_FILE` The output file name
- `-u` Run unit tests
- `-r` Make release
- `-q` Do not run on compile

The args marked with a `*` are lists
