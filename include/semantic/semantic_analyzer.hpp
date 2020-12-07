#ifndef __SEMANTIC_ANALYZER_H__
#define __SEMANTIC_ANALYZER_H__

#include "AST/ast.hpp"
#include "visitor/visitor_BASE.hpp"

class SemanticAnalyzer : public ASTVisitorBase{
	public:
		void visit(ProgNode *current_node) override;
		void visit(SubprogramDeclarationNode *current_node) override;
		void visit(SubprogramHeadNode *current_node) override;
		void visit(DeclarationNode *current_node) override;
		void visit(VariableNode *current_node) override;
		void visit(CompoundStatementNode *current_nodee) override;
		void visit(AssignmentNode *current_node) override;
		void visit(FunctionORProcedureCallNode *current_node) override;
		void visit(IfNode *current_node) override;
		void visit(WhileNode *current_node) override;
		void visit(VariableReferenceNode *current_node) override;
		void visit(CompoundStatementNode *current_node) override;
		void visit(OperatorNode *current_node) override;
};