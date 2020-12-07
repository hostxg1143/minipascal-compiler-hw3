#include "semantic_analyzer.hpp"
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
#include <cstdio>
#include <iomanip>
#include <iostream>

using namespace std;

void SemanticAnalyzer::visit(ProgNode *current_node){

}
void SemanticAnalyzer::visit(SubprogramDeclarationNode *current_node){
	
}
void SemanticAnalyzer::visit(SubprogramHeadNode *current_node){
	
}
void SemanticAnalyzer::visit(DeclarationNode *current_node){
	
}
void SemanticAnalyzer::visit(VariableNode *current_node){
	
}
void SemanticAnalyzer::visit(CompoundStatementNode *current_node){
	
}
void SemanticAnalyzer::visit(AssignmentNode *current_node){
	
}
void SemanticAnalyzer::visit(FunctionORProcedureCallNode *node){
	
}
void SemanticAnalyzer::visit(IfNode *node){
	
}
void SemanticAnalyzer::visit(WhileNode *node){
	
}
void SemanticAnalyzer::visit(VariableReferenceNode *node){
	
}
void SemanticAnalyzer::visit(CompoundStatementNode *node){
	
}
void SemanticAnalyzer::visit(OperatorNode *node){
	
}