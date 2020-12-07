
%{
/*
 * scanner.l
 *
 * lex input file for pascal scanner
 *
 */

#include <stdio.h>
#include <string.h>
#include "ast.h"
#include "parser.h"

int fileno(FILE *);

#define YY_USER_ACTION \
    yylloc.first_line = line_no; \
    yylloc.first_column = col_no; \
    col_no += yyleng;

#define MAX_LINE_LENG      256
#define LIST       strcat(buffer, yytext)
#define LIST_FLUSH do{ if(opt_list) printf("%s", buffer); *buffer = 0; line_no++; col_no = 0;}while(0)
#define LOG(TYPE) do{ LIST; if(opt_token) fprintf(stderr, "token(type:%-10s) on line %4d, %3d : %s\n", #TYPE, line_no, col_no - yyleng + 1, yytext); } while(0)
#define INFO(TAG) do{ LIST; if(opt_token) fprintf(stderr, "[INFO ] line %4d:%3d comment string\n", line_no, col_no - yyleng + 1); } while(0)
#define INFOS(TAG) do{ LIST; if(opt_token) fprintf(stderr, "[INFO ] line %4d:%3d comment string %s\n", line_no, col_no - yyleng + 1, #TAG); } while(0)

#ifdef __cplusplus
extern "C" int yylex(void);
#endif

int opt_list = 1, opt_token = 0;
int line_no = 1, col_no = 0;
char buffer[MAX_LINE_LENG];

%}

%option nounput
%option noinput
%x COMMENT
%x COMMENTS
A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]
Int ([0-9]+)
Float ([0-9]+)\.[0-9]+
%%
                             /* v could do something */
{P}{R}{O}{G}{R}{A}{M}       {LOG(KEYWORD); return(PROGRAM);    }
{V}{A}{R}                   {LOG(KEYWORD); return(VAR);        }
{A}{R}{R}{A}{Y}             {LOG(KEYWORD); return(ARRAY);      }
{O}{F}                      {LOG(KEYWORD); return(OF);         }
{I}{N}{T}{E}{G}{E}{R}       {LOG(KEYWORD); return(INTEGER);    }
{R}{E}{A}{L}                {LOG(KEYWORD); return(REAL);       }
{S}{T}{R}{I}{N}{G}          {LOG(KEYWORD); return(STRING);     }
{F}{U}{N}{C}{T}{I}{O}{N}    {LOG(KEYWORD); return(FUNCTION);   }
{P}{R}{O}{C}{E}{D}{U}{R}{E} {LOG(KEYWORD); return(PROCEDURE);  }
{B}{E}{G}{I}{N}             {LOG(KEYWORD); return(PBEGIN);     }
{E}{N}{D}                   {LOG(KEYWORD); return(END);        }
{I}{F}                      {LOG(KEYWORD); return(IF);         }
{T}{H}{E}{N}                {LOG(KEYWORD); return(THEN);       }
{E}{L}{S}{E}                {LOG(KEYWORD); return(ELSE);       }
{W}{H}{I}{L}{E}             {LOG(KEYWORD); return(WHILE);      }
{D}{O}                      {LOG(KEYWORD); return(DO);         }
{N}{O}{T}                   {LOG(KEYWORD); return(NOT);        }
{A}{N}{D}                   {LOG(KEYWORD); return(AND);        }
{O}{R}                      {LOG(KEYWORD); return(OR);         }

"("                         {LOG(KEYWORD); return(LPAREN);     }
")"                         {LOG(KEYWORD); return(RPAREN);     }
";"                         {LOG(KEYWORD); return(SEMICOLON);  }
"."                         {LOG(KEYWORD); return(DOT);        }
","                         {LOG(KEYWORD); return(COMMA);      }
":"                         {LOG(KEYWORD); return(COLON);      }
"["                         {LOG(KEYWORD); return(LBRACE);     }
"]"                         {LOG(KEYWORD); return(RBRACE);     }
".."                        {LOG(KEYWORD); return(DOTDOT);     }
":="                        {LOG(KEYWORD); return(ASSIGNMENT); }
"+"                         {LOG(KEYWORD); return(ADDOP);      }
"-"                         {LOG(KEYWORD); return(SUBOP);      }
"*"                         {LOG(KEYWORD); return(MULOP);      }
"/"                         {LOG(KEYWORD); return(DIVOP);      }
">"                         {LOG(KEYWORD); return(GTOP);       }
"<"                         {LOG(KEYWORD); return(LTOP);       }
"="                         {LOG(KEYWORD); return(EQOP);       }
">="                        {LOG(KEYWORD); return(GETOP);      }
"<="                        {LOG(KEYWORD); return(LETOP);      }
"!="                        {LOG(KEYWORD); return(NEQOP);      }

  /* define identifier here */
([a-z][a-zA-Z0-9_]*[a-zA-Z0-9])|[a-z] {LOG(IDENTIFIER); yylval.text = strdup(yytext); return(IDENTIFIER);     }

  /* define INTEGERNUM, REALNUMBER, SCIENTIFIC here */
{Int}                        {LOG(NUMBER); yylval.val = atoi(yytext); return(INTEGERNUM);                     }
{Float}                      {LOG(NUMBER); yylval.dval = atof(yytext); return(REALNUMBER);                    }
({Int}|{Float}){E}[+-]?{Int} {LOG(NUMBER); yylval.dval = atof(yytext); return(SCIENTIFIC);                    }

  /* define single/multiple line comment here */
\/\/                         {INFO(); BEGIN COMMENT;                                                          }
\/\*                         {INFOS(start); BEGIN COMMENTS;                                                   }

<COMMENT>.                   {LIST;                                                                           }                 
<COMMENT>\n                  {LIST; LIST_FLUSH; BEGIN INITIAL;                                                }

<COMMENTS>\*\/               {INFOS(end); BEGIN INITIAL;                                                      }
<COMMENTS>.                  {LIST;                                                                           }
<COMMENTS>\n                 {LIST; LIST_FLUSH;                                                               }

  /* define string constant (LITERALSTR) here */
\"[^\n"]*\"                  {LOG(STRING); yylval.text = strdup(yytext); return(LITERALSTR);                  }

  /* define pragma here */
#[ \t\f\r]*{P}{R}{A}{G}{M}{A}[ \t\f\r]*{L}{I}{S}{T}[ \t\f\r]*{O}{F}{F}  {if(opt_list){ opt_list=0; } LIST;    }
#[ \t\f\r]*{P}{R}{A}{G}{M}{A}[ \t\f\r]*{L}{I}{S}{T}[ \t\f\r]*{O}{N}   {if(!opt_list){ opt_list=1; } LIST;     }
#[ \t\f\r]*{P}{R}{A}{G}{M}{A}[ \t\f\r]*{T}{O}{K}{E}{N}[ \t\f\r]*off  {if(opt_token){ opt_list=0; } LIST;      }
#[ \t\f\r]*{P}{R}{A}{G}{M}{A}[ \t\f\r]*{T}{O}{K}{E}{N}[ \t\f\r]*{O}{F}{F}   {if(!opt_token){opt_list=1;} LIST;}

[ \t\f\r]    LIST;

\n {
  LIST;  //not string, LIST clear
  LIST_FLUSH;
}

.  {LIST; fprintf(stderr, "[ERROR] line %4d:%3d lexical analyzer error %s\n", line_no, col_no-(int)yyleng+1, yytext);}
=======
%{
/*
 * scanner.l
 *
 * lex input file for pascal scanner
 *
 */

#include <stdio.h>
#include <string.h>
#include "ast.h"
#include "parser.h"

int fileno(FILE *);

#define YY_USER_ACTION \
    yylloc.first_line = line_no; \
    yylloc.first_column = col_no; \
    col_no += yyleng;

#define MAX_LINE_LENG      256
#define LIST       strcat(buffer, yytext)
#define LIST_FLUSH do{ if(opt_list) printf("%s", buffer); *buffer = 0; line_no++; col_no = 0;}while(0)
#define LOG(TYPE) do{ LIST; if(opt_token) fprintf(stderr, "token(type:%-10s) on line %4d, %3d : %s\n", #TYPE, line_no, col_no - yyleng + 1, yytext); } while(0)
#define INFO(TAG) do{ LIST; if(opt_token) fprintf(stderr, "[INFO ] line %4d:%3d comment string\n", line_no, col_no - yyleng + 1); } while(0)
#define INFOS(TAG) do{ LIST; if(opt_token) fprintf(stderr, "[INFO ] line %4d:%3d comment string %s\n", line_no, col_no - yyleng + 1, #TAG); } while(0)

#ifdef __cplusplus
extern "C" int yylex(void);
#endif

int opt_list = 1, opt_token = 0;
int line_no = 1, col_no = 0;
char buffer[MAX_LINE_LENG];

%}

%option nounput
%option noinput
%x COMMENT
%x COMMENTS
A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]
Int ([0-9]+)
Float ([0-9]+)\.[0-9]+
%%
                             /* v could do something */
{P}{R}{O}{G}{R}{A}{M}       {LOG(KEYWORD); return(PROGRAM);    }
{V}{A}{R}                   {LOG(KEYWORD); return(VAR);        }
{A}{R}{R}{A}{Y}             {LOG(KEYWORD); return(ARRAY);      }
{O}{F}                      {LOG(KEYWORD); return(OF);         }
{I}{N}{T}{E}{G}{E}{R}       {LOG(KEYWORD); return(INTEGER);    }
{R}{E}{A}{L}                {LOG(KEYWORD); return(REAL);       }
{S}{T}{R}{I}{N}{G}          {LOG(KEYWORD); return(STRING);     }
{F}{U}{N}{C}{T}{I}{O}{N}    {LOG(KEYWORD); return(FUNCTION);   }
{P}{R}{O}{C}{E}{D}{U}{R}{E} {LOG(KEYWORD); return(PROCEDURE);  }
{B}{E}{G}{I}{N}             {LOG(KEYWORD); return(PBEGIN);     }
{E}{N}{D}                   {LOG(KEYWORD); return(END);        }
{I}{F}                      {LOG(KEYWORD); return(IF);         }
{T}{H}{E}{N}                {LOG(KEYWORD); return(THEN);       }
{E}{L}{S}{E}                {LOG(KEYWORD); return(ELSE);       }
{W}{H}{I}{L}{E}             {LOG(KEYWORD); return(WHILE);      }
{D}{O}                      {LOG(KEYWORD); return(DO);         }
{N}{O}{T}                   {LOG(KEYWORD); return(NOT);        }
{A}{N}{D}                   {LOG(KEYWORD); return(AND);        }
{O}{R}                      {LOG(KEYWORD); return(OR);         }

"("                         {LOG(KEYWORD); return(LPAREN);     }
")"                         {LOG(KEYWORD); return(RPAREN);     }
";"                         {LOG(KEYWORD); return(SEMICOLON);  }
"."                         {LOG(KEYWORD); return(DOT);        }
","                         {LOG(KEYWORD); return(COMMA);      }
":"                         {LOG(KEYWORD); return(COLON);      }
"["                         {LOG(KEYWORD); return(LBRACE);     }
"]"                         {LOG(KEYWORD); return(RBRACE);     }
".."                        {LOG(KEYWORD); return(DOTDOT);     }
":="                        {LOG(KEYWORD); return(ASSIGNMENT); }
"+"                         {LOG(KEYWORD); return(ADDOP);      }
"-"                         {LOG(KEYWORD); return(SUBOP);      }
"*"                         {LOG(KEYWORD); return(MULOP);      }
"/"                         {LOG(KEYWORD); return(DIVOP);      }
">"                         {LOG(KEYWORD); return(GTOP);       }
"<"                         {LOG(KEYWORD); return(LTOP);       }
"="                         {LOG(KEYWORD); return(EQOP);       }
">="                        {LOG(KEYWORD); return(GETOP);      }
"<="                        {LOG(KEYWORD); return(LETOP);      }
"!="                        {LOG(KEYWORD); return(NEQOP);      }

  /* define identifier here */
([a-z][a-zA-Z0-9_]*[a-zA-Z0-9])|[a-z] {LOG(IDENTIFIER); yylval.text = strdup(yytext); return(IDENTIFIER);     }

  /* define INTEGERNUM, REALNUMBER, SCIENTIFIC here */
{Int}                        {LOG(NUMBER); yylval.val = atoi(yytext); return(INTEGERNUM);                     }
{Float}                      {LOG(NUMBER); yylval.dval = atof(yytext); return(REALNUMBER);                    }
({Int}|{Float}){E}[+-]?{Int} {LOG(NUMBER); yylval.dval = atof(yytext); return(SCIENTIFIC);                    }

  /* define single/multiple line comment here */
\/\/                         {INFO(); BEGIN COMMENT;                                                          }
\/\*                         {INFOS(start); BEGIN COMMENTS;                                                   }

<COMMENT>.                   {LIST;                                                                           }                 
<COMMENT>\n                  {LIST; LIST_FLUSH; BEGIN INITIAL;                                                }

<COMMENTS>\*\/               {INFOS(end); BEGIN INITIAL;                                                      }
<COMMENTS>.                  {LIST;                                                                           }
<COMMENTS>\n                 {LIST; LIST_FLUSH;                                                               }

  /* define string constant (LITERALSTR) here */
\"[^\n"]*\"                  {LOG(STRING); yylval.text = strdup(yytext); return(LITERALSTR);                  }

  /* define pragma here */
#[ \t\f\r]*{P}{R}{A}{G}{M}{A}[ \t\f\r]*{L}{I}{S}{T}[ \t\f\r]*{O}{F}{F}  {if(opt_list){ opt_list=0; } LIST;    }
#[ \t\f\r]*{P}{R}{A}{G}{M}{A}[ \t\f\r]*{L}{I}{S}{T}[ \t\f\r]*{O}{N}   {if(!opt_list){ opt_list=1; } LIST;     }
#[ \t\f\r]*{P}{R}{A}{G}{M}{A}[ \t\f\r]*{T}{O}{K}{E}{N}[ \t\f\r]*off  {if(opt_token){ opt_list=0; } LIST;      }
#[ \t\f\r]*{P}{R}{A}{G}{M}{A}[ \t\f\r]*{T}{O}{K}{E}{N}[ \t\f\r]*{O}{F}{F}   {if(!opt_token){opt_list=1;} LIST;}

[ \t\f\r]    LIST;

\n {
  LIST;  //not string, LIST clear
  LIST_FLUSH;
}

.  {LIST; fprintf(stderr, "[ERROR] line %4d:%3d lexical analyzer error %s\n", line_no, col_no-(int)yyleng+1, yytext);}

