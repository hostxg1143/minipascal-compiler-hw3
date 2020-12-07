#include "costant_value.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

ConstantValueNode::ConstantValueNode(int _line_no, int _col_no,
			VariableInfo *_constant_info){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->constant_info = _constant_info;
}