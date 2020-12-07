#ifndef __ASSIGNMENT_H__
#define __ASSIGNMENT_H__

#include "ast.hpp"

class AssignmentNode : public ASTNodeBase {
	public:
		Node *variable_reference_node;
		Node *expression_node;

	public:
		AssignmentNode(int _line_no, int _col_no,
			Node *_variable_reference_node, Node *_expression_node);
		~AssignmentNode();
		void accept(class &AssignmentNode &v){};
};

#endif