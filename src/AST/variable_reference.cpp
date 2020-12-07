#include "variable_reference.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

VariableReferenceNode::VariableReferenceNode(int _line_no, int _col_no,
	string _variable_name, NodeList *_expression_node_list){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->variable_name = _variable_name;
	this->expression_node_list = _expression_node_list;
}