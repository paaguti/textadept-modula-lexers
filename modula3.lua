-- Copyright 2023 paagutigmail.com. See LICENSE.
-- MODULA-3 LPeg lexer.

local lexer = require('lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S, R = lpeg.P, lpeg.S, lpeg.R

local lex = lexer.new('modula3')

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match({
-- from the BNF definition
--
  'AND', 'DO', 'FROM', 'NOT', 'REPEAT', 'UNTIL',
  'ANY', 'ELSE', 'GENERIC', 'OBJECT', 'RETURN', 'UNTRACED',
  'ARRAY', 'ELSIF', 'IF', 'OF', 'REVEAL', 'VALUE',
  'AS', 'END', 'IMPORT', 'OR', 'ROOT', 'VAR',
  'BEGIN', 'EVAL', 'IN', 'OVERRIDES', 'SET', 'WHILE',
  'BITS', 'EXCEPT', 'INTERFACE', 'PROCEDURE', 'THEN', 'WITH',
  'BRANDED', 'EXCEPTION', 'LOCK', 'RAISE', 'TO',
  'BY', 'EXIT', 'LOOP', 'RAISES', 'TRY',
  'CASE', 'EXPORTS', 'METHODS', 'READONLY', 'TYPE',
  'CONST', 'FINALLY', 'MOD', 'RECORD', 'TYPECASE',
  'DIV', 'FOR', 'MODULE', 'REF', 'UNSAFE'
}, false)))

-- Functions.
lex:add_rule('function', token(lexer.FUNCTION, word_match({
'ABS', 'BYTESIZE', 'EXTENDED', 'MAX', 'SUBARRAY',
'ADDRESS', 'ISTYPE', 'MIN', 'NUMBER', 'TEXT',
'ADR', 'CEILING', 'FIRST', 'LAST', 'MUTEX', 'ORD',
'ADRSIZE', 'NARROW', 'TRUNC',
'BITSIZE', 'DEC', 'FLOOR', 'NEW', 'REFANY', 'TYPECODE',
'DISPOSE', 'INC', 'LOOPHOLE', 'VAL',
}, false)))

-- Types.
lex:add_rule('type', token(lexer.TYPE, word_match({
  'BITSET', 'BOOLEAN',  'CARDINAL', 'CHAR', 'INTEGER', 'REAL',
  'FLOAT', 'LONGINT', 'LONGREAL',  'BOOLEAN', 'WIDECHAR',

}, false)))

-- Constants
lex:add_rule('constant', token(lexer.CONSTANT, word_match({
  'FALSE', 'TRUE', 'NIL', 'NULL',
}, false)))

-- Strings and characters
lex:add_rule('string', token(lexer.STRING, lexer.range("\"", true, false)))

-- Identifiers.
lex:add_rule('identifier', token(lexer.IDENTIFIER, lexer.word))

-- Comments.
lex:add_rule('comment', token(lexer.COMMENT, lexer.range('(*', '*)')))

-- Pragmas (TODO)
local pragma = token(lexer.PREPROCESSOR, lexer.range('<*','*>'))
lex:add_rule('preprocessor' , pragma)
-- Numbers.
local modula_exp   = S("E")*S("+-")^-1*R("09")^1
local modula_rest  = P(".")*R("09")^1
-- This can be a decimal or a real
local modula_number  = S("+-")^-1 * R("09")^1 * modula_rest^-1 * modula_exp^-1
lex:add_rule('number',
  token(lexer.NUMBER,
    R("09","AF")^1*S("H") + R("07")^1*S("BC") + modula_number))

-- Operators.
lex:add_rule('operator', token(lexer.OPERATOR, S('.,;^&:=<>+-/*()[]')))

lexer.property['scintillua.comment'] = '//'

return lex
