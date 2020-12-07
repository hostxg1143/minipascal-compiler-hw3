#ifndef __OPERATOR_H__
#define __OPERATOR_H__

#include "ast.hpp"

class OperatorNode : public ASTNodeBase {
	public:
		EnumOperator op;
		Node *operand;
		Node *left_operand;
		Node *right_operand;

	public:
		OperatorNode(int _line_no, int _col_no, EnumOperator _op, 
			Node *_operand, Node *_left_operand, Node *_right_operand);
		~OperatorNode();
		void accept(class &OperatorNode &v){};
};

#endif