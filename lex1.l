/* scanner for a toy Pascal-S language */

%{
#include <cmath>
#include <cstdio>
#include <string>
#include "dec.h"
#include "y.tab.h"
int line = 1;
int comment_caller;
%}

%option noyywrap yylineno

LETTER   [a-zA-Z]
DIGIT    [0-9]
ID       [a-zA-Z][a-zA-Z0-9]*
NUM      {DIGIT}+(\.{DIGIT}+)?(E[+\-]?{DIGIT}*)?
RELOP    ("<"|">"|">="|"<="|"<>")
enter    [\n]


%x commentoneline_1 commentmultiline commentoneline_2


%%



and	    	{	return AND;			}
array		{	return ARRAY;		}
begin		{	return BEGINpas;	}
boolean		{	return BOOLEAN;		}
case		{	return CASE;		}
char		{	return CHAR;		}
const		{	return CONST;		}
div			{	return DIV;			}
do  		{	return DO;			}
downto		{	return DOWNTO;		}
else		{	return ELSE;		}
end			{	return END;			}
for 		{	return FOR;			}
function	{	return FUNCTION;	}
if 			{	return IF;			}
integer		{	return INTEGER;		}
mod			{	return MOD;			}
not 		{	return NOT;			}
of			{	return OF;			}
or			{	return OR;			}
procedure 	{	return PROCEDURE;	}
program 	{	return PROGRAM;		}
real		{	return REAL;		}
record 		{	return RECORD;		}
repeat 		{	return REPEAT;		}
then		{	return THEN;		}
to 			{	return TO;			}	
type 		{	return TYPE;		}
until 		{	return UNTIL;		}
var 		{	return VAR;			}
while 		{	return WHILE;		}



{NUM}       {
                terminalSAttriP terp = new(terminalSAttri);
                terp->val = atof( yytext );
                yylval.terattrip = terp;
                return NUM;
            }

{ID}        {
                terminalSAttriP terp = new(terminalSAttri);
                terp->id_name =   yytext ;
                yylval.terattrip = terp;
                return ID;
            }

{RELOP}     {
                terminalSAttriP terp = new(terminalSAttri);
                terp->id_name =   yytext;
                yylval.terattrip = terp;
                return RELOP;
            }

{enter}     {	
                line++;
            }

","         {   return COMMA;       }
";"         {   return SEMICOLON;   }
"."         {   return DOT;         }
":"         {   return COLON;       }
"("         {   return LEFTBRACKETS;       }
")"         {   return RIGHTBRACKETS;      }
"["         {   return LEFTSQUBRACKETS;    }
"]"         {   return RIGHTSQUBRACKETS;   }

":="        {   return ASSIGNOP;        }
"="         {   return EQUSIGN;         }
"+"         {   return PLUS;            }
"-"         {   return MINUS;           }
"/"         {   return DIVISION;        }
"*"         {   return MULTIPLY;        }


"(*"        {
                BEGIN(commentmultiline);
            }

"{"         {
                BEGIN(commentoneline_1);
            }

"//"        {
                BEGIN(commentoneline_2);
            }            

[ \t]+       /* eat up whitespace and \t */




<commentoneline_1>{enter}   {  
                                printf("error, {} comment can only comment one line!");
                                line++;
                            }
<commentoneline_1>"}"         BEGIN(INITIAL);
<commentoneline_1>.         /* eat anything that's not a '}' or a '\n'*/


<commentoneline_2>{enter}   {  
                                BEGIN(INITIAL);
                                line++;
                            }
<commentoneline_2>.         /* eat anything that's not  a '\n'*/


<commentmultiline>"*)"      BEGIN(INITIAL);
<commentmultiline>{enter}   { line++; }
<commentmultiline>.         /* eat anything that's not  a '\n' or a "*)"*/



.           printf( "ERROR: Line %d\tUnrecognized character: %s\n", yylineno ,yytext );

%%

