#include "prog.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

ProgNode::ProgNode(int _line_no, int _col_no,
			string _prog_name, vector<IdentifierInfo> *_arguments,
			vector<struct NodeWithType *> *_var_daclarations,
			NodeList *_subprogram_declarations, Node *_compound_statement){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->prog_name = _prog_name;
	this->arguments = _arguments;
	this->var_daclarations = _var_daclarations;
	this->subprogram_declarations = _subprogram_declarations;
	this->compound_statement = _compound_statement;
}