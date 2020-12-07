#ifndef __SUB_DECLARATION_H__
#define __SUB_DECLARATION_H__

#include "ast.hpp"

class SubprogramDeclarationNode : public ASTNodeBase {
	public:
		Node *subprogram_head;
		vector<struct NodeWithType *> *var_daclarations;
		NodeList *subprogram_declarations;
		Node *compound_statement;

	public:
		SubprogramDeclarationNode(int _line_no, int _col_no, Node *_subprogram_head,
			 vector<struct NodeWithType *> *_var_daclarations, NodeList *_subprogram_declarations, Node *_compound_statement);
		~SubprogramDeclarationNode();
		void accept(class &SubprogramDeclarationNode &v){};
};

#endif