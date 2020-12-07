#include "subprogram_head.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

SubprogramHeadNode::SubprogramHeadNode(int _line_no, int _col_no, string _subprogram_name, 
			vector<NodeWithType *> *_arguments, VariableInfo *_return_type){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->subprogram_name = _subprogram_name;
	this->arguments = _arguments;
	this->return_type = _return_type;
}