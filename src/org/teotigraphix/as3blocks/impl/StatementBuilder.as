package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.IStatementNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

public class StatementBuilder
{
	public static function build(ast:IParserNode):IStatementNode
	{
		switch (ast.kind)
		{
			case AS3NodeKind.EXPR_STMNT:
				return new ExpressionStatementNode(ast);
				
			default:
				throw new Error("unhandled expression node type: " + ast.kind);
				
				/*
				
				
				*/
				
				/*
				case AS3Parser.BLOCK:
				return new ASTStatementList(ast);
				case AS3Parser.DO:
				return new ASTASDoWhileStatement(ast);
				case AS3Parser.EXPR_STMNT:
				return new ASTASExpressionStatement(ast);
				case AS3Parser.FOR_EACH:
				return new ASTASForEachInStatement(ast);
				case AS3Parser.FOR_IN:
				return new ASTASForInStatement(ast);
				case AS3Parser.FOR:
				return new ASTASForStatement(ast);
				case AS3Parser.IF:
				return new ASTASIfStatement(ast);
				case AS3Parser.SWITCH:
				return new ASTASSwitchStatement(ast);
				case AS3Parser.CONST:
				case AS3Parser.VAR:
				return new ASTASDeclarationStatement(ast);
				case AS3Parser.WHILE:
				return new ASTASWhileStatement(ast);
				case AS3Parser.WITH:
				return new ASTASWithStatement(ast);
				case AS3Parser.RETURN:
				return new ASTASReturnStatement(ast);
				case AS3Parser.SUPER:
				return new ASTASSuperStatement(ast);
				case AS3Parser.BREAK:
				return new ASTASBreakStatement(ast);
				case AS3Parser.TRY:
				return new ASTASTryStatement(ast);
				case AS3Parser.DEFAULT_XML_NAMESPACE:
				return new ASTASDefaultXMLNamespaceStatement(ast);
				case AS3Parser.CONTINUE:
				return new ASTASContinueStatement(ast);
				case AS3Parser.THROW:
				return new ASTASThrowStatement(ast);
				*/
		}
	}
}
}