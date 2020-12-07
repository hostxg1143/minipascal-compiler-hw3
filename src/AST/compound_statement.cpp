#include "compound_statement.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

CompoundStatementNode::CompoundStatementNode(int _line_no, int _col_no,
			NodeList *_statement_list){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->statement_list = _statement_list;
}