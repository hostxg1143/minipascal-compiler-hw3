#include "while.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

WhileNode::WhileNode(int _line_no, int _col_no,
			Node *_condition, Node *_body){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->condition = _condition;
	this->body = _body;
}