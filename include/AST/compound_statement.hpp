#ifndef __COMPOUND_H__
#define __COMPOUND_H__

#include "ast.hpp"

class CompoundStatementNode : public ASTNodeBase {
	public:
		NodeList *statement_list;

	public:
		CompoundStatementNode(int _line_no, int _col_no,
			NodeList *_statement_list);
		~CompoundStatementNode();
		void accept(class &CompoundStatementNode &v){};
};

#endif