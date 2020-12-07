#ifndef __PROG_H__
#define __PROG_H__

#include "ast.hpp"

class ProgNode : public ASTNodeBase {
	public:
		string prog_name;
		vector<IdentifierInfo> *arguments;
		vector<struct NodeWithType *> *var_daclarations;
		NodeList *subprogram_declarations;
		Node *compound_statement;

	public:
		ProgNode(int _line_no, int _col_no,
			string _prog_name, vector<IdentifierInfo> *_arguments,
			vector<struct NodeWithType *> *_var_daclarations,
			NodeList *_subprogram_declarations, Node *_compound_statement);
		~ProgNode();
		void accept(class &ProgNode &v){};
};

#endif