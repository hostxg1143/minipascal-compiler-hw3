#ifndef __VISITOR_BASE_H__
#define __VISITOR_BASE_H__
#include "AST/ast.hpp"

class ProgNode;
class SubprogramHeadNode;
class SubprogramDeclarationNode;
class DeclarationNode;
class VariableNode;
class CompoundStatementNode;
class AssignmentNode;
class FunctionORProcedureCallNode;
class IfNode;
class WhileNode;
class VariableReferenceNode;
class ConstantValueNode;
class OperatorNode;

class ASTVisitorBase{
	public:
		virtual void visit(ProgNode *current_node) = 0;
		virtual void visit(SubprogramDeclarationNode *current_node) = 0;
		virtual void visit(SubprogramHeadNode *current_node) = 0;
		virtual void visit(DeclarationNode *current_node) = 0;
		virtual void visit(VariableNode *current_node) = 0;
		virtual void visit(CompoundStatementNode *current_node) = 0;
		virtual void visit(AssignmentNode) = 0;
		virtual void visit(FunctionORProcedureCallNode *current_nodee) = 0;
		virtual void visit(IfNode *current_node) = 0;
		virtual void visit(WhileNode *current_node) = 0;
		virtual void visit(VariableReferenceNode *current_node) = 0;
		virtual void visit(CompoundStatementNode *current_node) = 0;
		virtual void visit(OperatorNode *current_node) = 0;

		uint space_counter = 0;
		void space_counter_increase();
		void space_counter_decrease();
};
