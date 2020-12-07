#ifndef __IFNODE_H__
#define __IFNODE_H__

#include "ast.hpp"

class IfNode : public ASTNodeBase {
	public:
		Node *condition;
		Node *if_body;
		Node *else_body;

	public:
		IfNode(int _line_no, int _col_no,
			Node *_condition, Node *_if_body, Node *_else_body);
		~IfNode();
		void accept(class &IfNode &v){};
};

#endif