#include "operator.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

OperatorNode::OperatorNode(int _line_no, int _col_no, EnumOperator _op, 
			Node *_operand, Node *_left_operand, Node *_right_operand){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->op = _op;
	this->operand = _operand;
	this->left_operand = _left_operand;
	this->right_operand = _right_operand;
}