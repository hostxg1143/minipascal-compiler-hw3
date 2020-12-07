#ifndef __SUB_HEAD_H__
#define __SUB_HEAD_H__

#include "ast.hpp"

class SubprogramHeadNode : public ASTNodeBase {
	public:
		string subprogram_name;
		vector<NodeWithType *> *arguments;
		VariableInfo *return_type;

	public:
		SubprogramHeadNode(int _line_no, int _col_no, string _subprogram_name, 
			vector<NodeWithType *> *_arguments, VariableInfo *_return_type);
		~SubprogramHeadNode();
		void accept(class &SubprogramHeadNode &v){};
};

#endif