#include "if.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

IfNode::IfNode(int _line_no, int _col_no,
			Node *_condition, Node *_if_body, Node *_else_body){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->condition = _condition;
	this->if_body = _if_body;
	this->else_body = _else_body;
}