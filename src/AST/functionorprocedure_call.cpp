#include "function_call.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

FunctionORProcedureCallNode::FunctionORProcedureCallNode(int _line_no, int _col_no,
			string _name, NodeList *_arguments){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->name = _name;
	this->arguments = _arguments;
}