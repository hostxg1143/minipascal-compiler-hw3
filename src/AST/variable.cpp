#include "variable.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

VariableNode::VariableNode(int _line_no, int _col_no,
			string _variable_name, VariableInfo *_type){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->variable_name = _variable_name;
	this->type = _type;
}