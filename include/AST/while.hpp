#ifndef __WHILENODE_H__
#define __WHILENODE_H__

#include "ast.hpp"

class WhileNode : public ASTNodeBase {
	public:
		Node *condition;
		Node *body;

	public:
		WhileNode(int _line_no, int _col_no,
			Node *_condition, Node *_body);
		~WhileNode();
		void accept(class &WhileNode &v){};
};

#endif