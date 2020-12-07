#ifndef __VARIABLE_H__
#define __VARIABLE_H__

#include "ast.hpp"

class VariableNode : public ASTNodeBase {
	public:
		string variable_name;
		VariableInfo *type;

	public:
		VariableNode(int _line_no, int _col_no,
			string _variable_name, VariableInfo *_type);
		~VariableNode();
		void accept(class &VariableNode &v){};
};

#endif