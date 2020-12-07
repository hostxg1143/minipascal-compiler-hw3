#include "declaration.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

DeclarationNode::DeclarationNode(int _line_no, int _col_no,
			NodeList *_variable_node_list){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->variables_node_list = _variable_node_list;
}