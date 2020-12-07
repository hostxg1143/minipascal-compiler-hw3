#ifndef __DECLARATION_H__
#define __DECLARATION_H__

#include "ast.hpp"

class DeclarationNode : public ASTNodeBase {
	public:
		NodeList *variables_node_list;

	public:
		DeclarationNode(int _line_no, int _col_no,
			NodeList *_variables_node_list);
		~DeclarationNode();
		void accept(class &DeclarationNode &v){};
};

#endif