#ifndef __FUNCTIONCALL_H__
#define __FUNCTIONCALL_H__

#include "ast.hpp"

class FunctionORProcedureCallNode : public ASTNodeBase {
	public:
		NodeList *arguments;

	public:
		FunctionORProcedureCallNode(int _line_no, int _col_no,
			string _name, NodeList *_arguments);
		~FunctionORProcedureCallNode();
		void accept(class &FunctionORProcedureCallNode &v){};
};

#endif