Lua Parsing and Refactorization tools
=========

A collection of tools for working with Lua source code. Primarily a Lua source code minifier, but also includes some static analysis tools and a general Lua lexer and parser.

Currently the minifier performs:

- Stripping of all comments and whitespace
- True semantic renaming of all local variables to a reduced form
- Reduces the source to the minimal spacing, spaces are only inserted where actually needed.


LuaMinify Command Line Utility Usage
------------------------------------

The `LuaMinify` shell and batch files are given as shortcuts to running a command line instance of the minifier with the following usage:

    LuaMinify sourcefile [destfile]

Which will minify to a given destination file, or to a copy of the source file with _min appended to the filename if no output file is given.


LuaMinify Roblox Plugin Usage
-----------------------------

First, download the source code, which you can do by hitting this button:

![Click That](http://github.com/stravant/LuaMinify/raw/master/RobloxPluginInstructions.png)

Then copy the `RobloxPlugin` folder from the source into your Roblox Plugins directory, which can be found by hitting `Tools->Open Plugins Folder` in Roblox Studio.

Features/Todo
-------------
Features:

    - Lua scanner/parser, which generates a full AST (See TODO 1 and 2)
    - Lua reconstructor
        - minimal
        - full reconstruction (TODO: options)
        - TODO: exact reconstructor
    - support for embedded long strings/comments e.g. [[abc [[ def ]] ghi]]

Todo:

    - Comment parsing needs fixed. It works in place of statements. Works: "function a() -- main function" Doesn't work: "for i = 1, --[[2]] 3 do"
    - Preserve whitespace into AST as AstNode Type 'WhiteSpace'
    - use table.concat instead of appends in the reconstructors
    - bytecode generator