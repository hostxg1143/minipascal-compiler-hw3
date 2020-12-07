#include "assignment.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

AssignmentNode::AssignmentNode(int _line_no, int _col_no,
			Node *_variable_reference_node, Node *_expression_node){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->variable_reference_node = _variable_reference_node;
	this->expression_node = _expression_node;
}