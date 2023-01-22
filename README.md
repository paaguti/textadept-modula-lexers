# textadept-modula-lexers
Modula-2 and Modula-3 lexers for TextAdept

This is still in alpha state.

Put the Lua files in your `~/.textadept/lexers` directory and add the following in your `~/.textadept/init.lua` file to associate file extensions to Modula-2 and Modula-3 files.

```
lexer.detect_extensions.def='modula2'
lexer.detect_extensions.mod='modula2'
lexer.detect_extensions.m3='modula3'
lexer.detect_extensions.i3='modula3'
lexer.detect_extensions.mg='modula3'
lexer.detect_extensions.ig='modula3'
```
