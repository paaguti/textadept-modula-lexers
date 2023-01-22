-- Copyright 2023 paaguti@hotmail.com. See LICENSE.
-- Modula-2 LPeg lexer.

local lexer = require('lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S, R = lpeg.P, lpeg.S, lpeg.R

local lex = lexer.new('modula2')

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match({
-- from the BNF definition
--
  'ARRAY' , 'BEGIN' , 'BY' , 'CASE' ,
  'CONST' , 'DEFINITION' , 'DO' , 'ELSE' ,
  'ELSIF' , 'END' , 'EXCEPT' , 'EXIT' ,
  'EXPORT' , 'FINALLY' , 'FOR' , 'FORWARD' ,
  'FROM' , 'IF' , 'IMPLEMENTATION' , 'IMPORT' , 'IN',
  'LOOP' , 'MODULE' , 'OF' , 'PACKEDSET' ,
  'POINTER' , 'PROCEDURE' , 'QUALIFIED' , 'RECORD' ,
  'REPEAT' , 'RETRY' , 'RETURN' , 'SET' ,
  'THEN' , 'TO' , 'TYPE', 'UNTIL' ,
  'VAR' , 'WHILE' , 'WITH' ,
}, false)))

-- Functions.
lex:add_rule('function', token(lexer.FUNCTION, word_match({
  'ABS', 'ADR', 'ASH', 'AND', 'CAP', 'DEC', 'DISPOSE',
  'DIV', 'EXCL', 'FLOAT', 'INC', 'INCL', 'HALT',
  'HIGH', 'NEW', 'MOD', 'NOT', 'ODD', 'OR',
  'PROC', 'ROUND', 'SIZE', 'TSIZE'
}, false)))

-- Types.
lex:add_rule('type', token(lexer.TYPE, word_match({
  'BITSET', 'BOOLEAN',  'CARDINAL', 'CHAR', 'INTEGER', 'REAL'
}, false)))

-- Constants
lex:add_rule('constant', token(lexer.CONSTANT, word_match({
  'FALSE', 'TRUE', 'NIL'
}, false)

-- Strings.
--lex:add_rule('string', token(lexer.STRING, S('uUrR')^-1 * lexer.range("'", true, false)))
local modula_string = lexer.range("\"", true, false)
local modula_char = S("'")*P(1)*S("'")
lex:add_rule('string', token(lexer.STRING, modula_string + modula_char))

-- Identifiers.
lex:add_rule('identifier', token(lexer.IDENTIFIER, lexer.word))

-- Comments.
lex:add_rule('comment', token(lexer.COMMENT, lexer.range('(*', '*)')))

-- Numbers.
local modula_octal = R("07")^1*R("BC")
local modula_dec   = R("09")^1
local modula_hex   = (R("09")+R("AF"))^1*P("H")
local modula_real  = R("09")^1*(P(".")*R("09")^1)^-1*P("E")*S("+-")^-1*R("09")^1
lex:add_rule('number', token(lexer.NUMBER, modula_octal + modula_dec +
                                           modula_hex + modula_real))
-- Operators.
lex:add_rule('operator', token(lexer.OPERATOR, S('.,;^&:=<>+-/*()[]')))

lexer.property['scintillua.comment'] = '//'

return lex
