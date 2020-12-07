%{
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "AST/loc.h"
#include "AST/ast.h"
#include "AST/error.h"
#include "AST/prog.hpp"
#include "AST/declaration.hpp"
#include "AST/variable.hpp"
#include "AST/operator.hpp"
#include "AST/variable_reference.hpp"
#include "AST/costant_value.hpp"
#include "AST/functionorprocedure_call.hpp"
#include "AST/assignment.hpp"
#include "AST/compound_statement.hpp"
#include "AST/if.hpp"
#include "AST/while.hpp"
#include "AST/subprogram_head.hpp"
#include "AST/subprogram_declaration.hpp"

#define YYLTYPE LocType

#define MAX_LINE_LENG      256
extern int line_no, col_no, opt_list;
extern char buffer[MAX_LINE_LENG];
extern FILE *yyin;        /* declared by lex */
extern char *yytext;      /* declared by lex */
extern int yyleng;

static Node root = NULL;

extern
#ifdef __cplusplus
"C"
#endif
int yylex(void);
static void yyerror(const char *msg);
extern int yylex_destroy(void);

%}

%locations

%union {
  int val;
  char* text;
  double dval;
  
  Node *node;
  NodeList *node_list_ptr;

  vector<struct NodeWithType *> *node_w_type_list_ptr;

  VariableInfo *variable_info_ptr;
  vector<struct IdentifierInfo> *id_list_ptr;
}

%token PROGRAM VAR ARRAY OF INTEGER REAL STRING FUNCTION PROCEDURE PBEGIN END IF THEN ELSE WHILE DO NOT AND OR

%token LPAREN RPAREN SEMICOLON DOT COMMA COLON LBRACE RBRACE DOTDOT ASSIGNMENT ADDOP SUBOP MULOP DIVOP LTOP GTOP EQOP GETOP LETOP NEQOP

%token <text> IDENTIFIER
%token <val> INTEGERNUM
%token <dval> REALNUMBER
%token <dval> SCIENTIFIC
%token <text> LITERALSTR

    /*Type of non-terminal*/
%type <node> prog
%type <node> subprogram_declaration
%type <node> compound_statement
%type <node> statement
%type <node> variable
%type <node> procedure_statement
%type <node> expression
%type <node> boolexpression
%type <node> simple_expression
%type <node> term
%type <node> factor
%type <node> addop
%type <node> mulop
%type <node> relop
%type <node_list_ptr> subprogram_declarations
%type <node_list_ptr> statement_list
%type <node_list_ptr> expression_list
%type <node_list_ptr> tail
%type <node_w_type_list_ptr> declarations
%type <node_w_type_list_ptr> parameter_list
%type <node_w_type_list_ptr> arguments
%type <variable_info_ptr> type
%type <variable_info_ptr> standard_type
%type <variable_info_ptr> num
%type <id_list_ptr> identifier_list

%%

    /* define your snytax here */
    /* @n return the sturct LocType of "n-th node", ex: @1 return the PROGRAM node's locType
       $n return the $$ result you assigned to the rule, ex: $1 */
prog :  PROGRAM IDENTIFIER LPAREN identifier_list RPAREN SEMICOLON
        declarations
        subprogram_declarations
        compound_statement
        DOT { 
            root = new ProgNode(
                @1.first_line,
                @1.first_column,
                string($2),
                $4,
                $7,
                $8,
                $9
            ); 
        }
     ;
     /*
     printf("program node is @ line: %d, column: %d\n",
                 @1.first_line, @1.first_column);
     yylval.val, yylval.text, yylval.dval to get the data (type defined in %union) you assigned by scanner.
     */

identifier_list : IDENTIFIER {
                        $$ = new vector<IdentifierInfo>();
                        $$->push_back({string($1), @1.first_line, @1.first_column});
                        
                        free($1); //free memory
                  }
                | IDENTIFIER COMMA identifier_list {
                        $3->push_back({string($1), @1.first_line, @1.first_column});
                        $$ = $3;

                        free($1); //free memory
                  }
                ;

declarations : VAR identifier_list COLON type SEMICOLON declarations {
                    NodeWithType *tmp_node_with_type = new NodeWithType();
                    tmp_node_with_type->type = $4;
                    tmp_node_with_type->counter = 0;

                    NodeList *var_node_list = new NodeList();

                    for(uint i = 0; i < $2->size(); i++){
                        VariableInfo *dup_type = new VariableInfo();
                        dup_type->type_set = $4->type_set;
                        dup_type->type = $4->type;
                        dup_type->array_range = $4->array_range;
                        dup_type->int_literal = $4->int_literal;
                        dup_type->real_literal = $4->real_literal;
                        dup_type->string_literal = $4->string_literal;

                        VariableNode *tmp_node = new VariableNode(
                            (*$2)[i].first_line,
                            (*$2)[i].first_column,
                            (*$2)[i].name,
                            dup_type
                        );

                        var_node_list.push_back(tmp_node);
                        tmp_node_with_type->counter++;
                    }

                    tmp_node_with_type->node = new DeclarationNode(
                            @2.first_line,
                            @2.first_column,
                            var_node_list
                    );
                            
                    $6->push_back(tmp_node_with_type);

                    $$->$6; 
               }
             | /*lambda*/{
                    $$ = new vector<NodeWithType *>(); 
               }
             ;

type : standard_type { 
            $$ = $1; 
       }
     | ARRAY LBRACE num DOTDOT num RBRACE OF type {
            IntPair *tmp = new IntPair();
            tmp->start = $3->int_literal;
            tmp->end = $5->int_literal;

            $8->array_range.push_back(tmp);

            $$ = $8;
       }
     ;

standard_type : INTEGER { 
                    $$ = new VariableInfo();
                    $$->type_set = SET_SCALAR;
                    $$->type = TYPE_INTEGER; 
                }
              | REAL    { 
                    $$ = new VariableInfo();
                    $$->type_set = SET_SCALAR;
                    $$->type = TYPE_REAL;
                }
              | STRING  { 
                    $$ = new VariableInfo();
                    $$->type_set = SET_SCALAR;
                    $$->type = TYPE_STRING;  
                }
              ;

subprogram_declarations : subprogram_declaration SEMICOLON subprogram_declarations {
                            $3->push_back($1);
                            $$ = $3;
                          }
                        | /*lambda*/ {
                            $$ = new NodeList();
                          }
                        ;

subprogram_declaration : subprogram_head
                         declarations
                         subprogram_declarations
                         compound_statement {
                            $$ = new SubprogramDeclarationNode(
                                @1.first_line,
                                @1.first_column,
                                $1,
                                $2,
                                $3,
                                $4
                            );
                         }
                         ;

subprogram_head : FUNCTION IDENTIFIER arguments COLON standard_type SEMICOLON {
                    $$ = new SubprogramHeadNode(
                        @1.first_line,
                        @1.first_column,
                        string($2),
                        $3,
                        $5
                    ); 
                  }
                | PROCEDURE IDENTIFIER arguments SEMICOLON {
                    VariableInfo *tmp_return_type = new VariableInfo();
                    tmp_return_type->type_set = UNKNOWN_SET;
                    tmp_return_type->type = TYPE_VOID;

                    $$ = new SubprogramHeadNode(
                        @1.first_line,
                        @1.first_column,
                        string($2),
                        $3,
                        tmp_return_type
                    ); 
                  }
                ;

arguments : LPAREN parameter_list RPAREN {
                $$ = $2;
            }
          | /*lambda*/ { 
                $$ = nullptr; 
            }
          ;

parameter_list : optional_var identifier_list COLON type {
                    $$ = new vector<NodeWithType *>();

                    NodeWithType *tmp_node_with_type = new NodeWithType();
                    tmp_node_with_type->type = $4;
                    tmp_node_with_type->counter = 0;

                    NodeList *var_node_list = new NodeList();

                    for(uint i = 0; i < $2->size(); i++){
                        VariableInfo *dup_type = new VariableInfo();
                        dup_type->type_set = $4->type_set;
                        dup_type->type = $4->type;
                        dup_type->array_range = $4->array_range;
                        dup_type->int_literal = $4->int_literal;
                        dup_type->real_literal = $4->real_literal;
                        dup_type->string_literal = $4->string_literal;

                        VariableNode *tmp_node = new VariableNode(
                            (*$2)[i].first_line,
                            (*$2)[i].first_column,
                            (*$2)[i].name,
                            dup_type
                        );

                        var_node_list.push_back(tmp_node);
                        tmp_node_with_type->counter++;
                    }

                    tmp_node_with_type->node = new DeclarationNode(
                            @2.first_line,
                            @2.first_column,
                            var_node_list
                    );
                            
                    $$->push_back(tmp_node_with_type);
                 }
               | optional_var identifier_list COLON type SEMICOLON parameter_list {
                    NodeWithType *tmp_node_with_type = new NodeWithType();
                    tmp_node_with_type->type = $4;
                    tmp_node_with_type->counter = 0;

                    NodeList *var_node_list = new NodeList();

                    for(uint i = 0; i < $2->size(); i++){
                        VariableInfo *dup_type = new VariableInfo();
                        dup_type->type_set = $4->type_set;
                        dup_type->type = $4->type;
                        dup_type->array_range = $4->array_range;
                        dup_type->int_literal = $4->int_literal;
                        dup_type->real_literal = $4->real_literal;
                        dup_type->string_literal = $4->string_literal;

                        VariableNode *tmp_node = new VariableNode(
                            (*$2)[i].first_line,
                            (*$2)[i].first_column,
                            (*$2)[i].name,
                            dup_type
                        );

                        var_node_list.push_back(tmp_node);
                        tmp_node_with_type->counter++;
                    }

                    tmp_node_with_type->node = new DeclarationNode(
                            @2.first_line,
                            @2.first_column,
                            var_node_list
                    );
                            
                    $6->push_back(tmp_node_with_type);

                    $$->$6;
                 }
               ;

optional_var : VAR
             |
             ;

compound_statement : PBEGIN statement_list END {
                        $$ = new CompoundStatementNode(
                                @1.first_line,
                                @1.first_column,
                                $2
                        );
                     }

statement_list : statement {
                    $$ = new NodeList();
                    $$->push_back($1);
                 }
               | statement SEMICOLON statement_list {
                    $3->push_back($1);
                    $$ = $3;
                 }
               ;

statement : variable ASSIGNMENT expression {
                $$ = new AssignmentNode(
                        @1.first_line,
                        @1.first_column,
                        $1,
                        $3
                ); 
            }
          | procedure_statement {
                $$ = $1;
            }
          | compound_statement { 
                $$ = $1; 
            }
          | IF expression THEN statement ELSE statement {
                $$ = new IfNode(
                    @1.first_line,
                    @1.first_column,
                    $2,
                    $4,
                    $6
                );
            }
          | WHILE expression DO statement {
                $$ = new WhileNode(
                    @1.first_line,
                    @1.first_column,
                    $2,
                    $4
                );
            }
          | /*lambda*/ { 
                $$ = nullptr; 
            }
          ;

variable : IDENTIFIER tail {
                $$ = new VariableReferenceNode(
                    @1.first_line, 
                    @1.first_column, 
                    string($1),
                    $2
                );
            }

tail : LBRACE expression RBRACE tail {
            $4->push_back($2); 
            $$ = $4;
       }
     | /*lambda*/ {
            $$ = new NodeList(); 
       }
     ;

procedure_statement : IDENTIFIER {
                        $$ = new FunctionORProcedureCallNode(
                            @1.first_line,
                            @1.first_column,
                            string($1),
                            nullptr
                        );
                      }
                    | IDENTIFIER LPAREN expression_list RPAREN {
                        $$ = new FunctionORProcedureCallNode(
                            @1.first_line,
                            @1.first_column,
                            string($1),
                            $3
                        );
                      }
                    ;

expression_list : expression {
                    $$ = new NodeList();
                    $$->push_back($1);
                  }
                | expression COMMA expression_list {
                    $3->push_back(1);
                    $$ = $3;
                  }
                ;

expression : boolexpression {
                $$ = $1; 
             }
           | boolexpression AND boolexpression { 
                $$ = new OperatorNode(
                    @2.first_line,
                    @2.first_column,
                    OP_AND,
                    nullptr,
                    $1,
                    $3
                ); 
             }
           | boolexpression OR boolexpression { 
                $$ = new OperatorNode(
                    @2.first_line,
                    @2.first_column,
                    OP_OR,
                    nullptr,
                    $1,
                    $3
                ); 
             }
           ;


boolexpression : simple_expression {
                    $$ = $1;
                 }
               | simple_expression relop simple_expression { 
                    $2->left_operand = $1;
                    $2->right_operand = $3;
                    $$ = $2; 
                 }
               ;

simple_expression : term {
                        $$ = $1;
                    }
                  | simple_expression addop term{ 
                        $2->left_operand = $1;
                        $2->right_operand = $3;
                        $$ = $2; 
                    }
                  ;

term : factor {
            $$ = $1;
       }
     | term mulop factor{ 
            $2->left_operand = $1;
            $2->right_operand = $3;
            $$ = $2; 
       }
     ;

factor : variable {
            $$ = $1;
         }
       | IDENTIFIER LPAREN expression_list RPAREN {
            $$ = new FunctionORProcedureCallNode(
                    @1.first_line,
                    @1.first_column,
                    string($1),
                    $3
                );
         }
       | num {
            $$ = new ConstantValueNode(
                    @1.first_line,
                    @1.first_column,
                    $1
                );
         }
       | LITERALSTR {
            VariableInfo *tmp = new VariableInfo(SET_SCALAR, TYPE_STRING, string($1));
            $$ = new ConstantValueNode(
                    @1.first_line,
                    @1.first_column,
                    tmp
                ); 
         }
       | LPAREN expression RPAREN {
            $$ = $2;
         }
       | NOT factor {
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_NOT,
                $2,
                nullptr,
                nullptr
            );
         }
       | SUBOP factor {
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_SUB,
                $2,
                nullptr,
                nullptr
            );
         }
       ;

addop : ADDOP { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_ADD,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      | SUBOP { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_SUB,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      ;

mulop : MULOP { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_MUL,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      | DIVOP { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_DIV,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      ;

relop : LTOP  { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_LT,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      | GTOP  { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_GT,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      | EQOP  { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_EQ,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      | LETOP { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_LET,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      | GETOP { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_GET,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      | NEQOP { 
            $$ = new OperatorNode(
                @1.first_line,
                @1.first_column,
                OP_NEQ,
                nullptr,
                nullptr,
                nullptr
            ); 
        }
      ;

num : INTEGERNUM { 
        $$ = new VariableInfo();
        $$->type_set = SET_CONSTANT_LITERAL;
        $$->type = TYPE_INTEGER;
        $$->int_literal = $1;
      }
    | REALNUMBER { 
        $$ = new VariableInfo();
        $$->type_set = SET_CONSTANT_LITERAL;
        $$->type = TYPE_REAL;
        $$->real_literal = $1;
      }
    | SCIENTIFIC { 
        $$ = new VariableInfo();
        $$->type_set = SET_CONSTANT_LITERAL;
        $$->type = TYPE_REAL;
        $$->string_literal = $1;
      }
    ;

%%

void yyerror(const char *msg) {
    fprintf(stderr,
            "[ERROR] line %4d:%3d %s, Unmatched token: %s\n",
            line_no, col_no-(int)yyleng+1, buffer, yytext);
}

int main(int argc, const char *argv[]) {

    if(argc > 2)
        fprintf( stderr, "Usage: ./parser [filename]\n" ), exit(0);

    FILE *fp = argc == 1 ? stdin : fopen(argv[1], "r");

    if(fp == NULL)
        fprintf( stderr, "Open file error\n" ), exit(-1);

    yyin = fp;
    yyparse();
    if(root){
        // do pass here
    }
    return 0;
}