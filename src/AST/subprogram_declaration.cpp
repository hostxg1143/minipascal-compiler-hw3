#include "subprogram_declaration.hpp"

#include <cstdlib>
#include <iomanip>
#include <iostream>

SubprogramDeclarationNode::SubprogramDeclarationNode(int _line_no, int _col_no, Node *_subprogram_head,
			 vector<struct NodeWithType *> *_var_daclarations, NodeList *_subprogram_declarations, Node *_compound_statement){
	this->line_no = _line_no;
	this->col_no = _col_no;
	this->subprogram_head = _subprogram_head;
	this->var_daclarations = _var_daclarations;
	this->subprogram_declarations = _subprogram_declarations;
	this->compound_statement = _compound_statement;
}