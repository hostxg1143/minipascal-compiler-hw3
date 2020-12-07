#ifndef __VAR_REF_H__
#define __VAR_REF_H__

#include "ast.hpp"

class VariableReferenceNode : public ASTNodeBase {
	public:
		string variable_name;
		NodeList *expression_node_list;

	public:
		VariableReferenceNode(int _line_no, int _col_no,
			string _variable_name, NodeList *_expression_node_list)
		~VariableReferenceNode();
		void accept(class &VariableReferenceNode &v){};
};

#endif