LuaMinify
=========

A collection of tools for working with Lua source code. Primarily a Lua source code minifier, but also includes some static analysis tools and a general Lua lexer and parser.

Currently the minifier performs:

- Stripping of all comments and whitespace
- True semantic renaming of all local variables to a reduced form
- Reduces the source to the minimal spacing, spaces are only inserted where actually needed.


Usage
-----

The `LuaMinify` shell and batch files are given as shortcuts to running a command line instance of the minifier with the following usage:

    LuaMinify sourcefile [destfile]

Which will minify to a given destination file, or to a copy of the source file with _min appended to the filename if no output file is given.


