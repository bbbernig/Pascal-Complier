
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     NUM = 259,
     RELOP = 260,
     TYPE = 261,
     PROGRAM = 262,
     PROCEDURE = 263,
     FUNCTION = 264,
     IF = 265,
     ELSE = 266,
     THEN = 267,
     CONST = 268,
     INTEGER = 269,
     BEGINpas = 270,
     END = 271,
     VAR = 272,
     WHILE = 273,
     REAL = 274,
     NOT = 275,
     TO = 276,
     UNTIL = 277,
     OF = 278,
     CHAR = 279,
     FOR = 280,
     BOOLEAN = 281,
     CASE = 282,
     DOWNTO = 283,
     ARRAY = 284,
     RECORD = 285,
     REPEAT = 286,
     OR = 287,
     MOD = 288,
     DIV = 289,
     AND = 290,
     DO = 291,
     COMMA = 292,
     SEMICOLON = 293,
     DOT = 294,
     COLON = 295,
     LEFTBRACKETS = 296,
     RIGHTBRACKETS = 297,
     LEFTSQUBRACKETS = 298,
     RIGHTSQUBRACKETS = 299,
     ASSIGNOP = 300,
     EQUSIGN = 301,
     PLUS = 302,
     MINUS = 303,
     DIVISION = 304,
     MULTIPLY = 305,
     LOWER_THAN_ELSE = 306
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 23 "y.y"

	terminalSAttriP 		terattrip;
	idlistAttriP			idlistattrip;
	typeAttrip				typeattrip;
	periodAttrip			periodattrip;
	periodsAttrip			periodsattrip;
	type_declarationAttrip 	type_declarationattrip;
	var_declarationAttrip 	var_declarationattrip;
	record_bodyAttrip		record_bodyattrip;
	id_varpartAttrip		id_varpartattrip;
	id_varpartsAttrip		id_varpartsattrip;
	expression_listAttrip	expression_listattrip;

	paraInfop				parainfop;		
	double					numer_val;
	TYPEKIND				typekind;



/* Line 1676 of yacc.c  */
#line 123 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


