package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.TokenNode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.api.IAssignmentExpressionNode;
import org.teotigraphix.asblocks.api.IBinaryExpressionNode;
import org.teotigraphix.asblocks.api.ICompilationUnitNode;
import org.teotigraphix.asblocks.api.IExpressionNode;
import org.teotigraphix.asblocks.api.IMethodNode;
import org.teotigraphix.asblocks.api.Visibility;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class ASTBuilder
{
	
	public static function newMethod(name:String, 
									 visibility:Visibility, 
									 returnType:String):IMethodNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FUNCTION);
		var mods:IParserNode = ASTUtil.newAST(AS3NodeKind.MOD_LIST);
		mods.addChild(ASTUtil.newAST(AS3NodeKind.MODIFIER, visibility.name));
		ast.addChild(mods);
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newFunction());
		ast.appendToken(TokenBuilder.newSpace());
		var n:IParserNode = ASTUtil.newAST(AS3NodeKind.NAME, name);
		ast.addChild(n);
		var params:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.PARAMETER_LIST,
			AS3NodeKind.LPAREN, "(",
			AS3NodeKind.RPAREN, ")");
		ast.addChild(params);
		if (returnType)
		{
			ast.appendToken(TokenBuilder.newColumn());
			ast.addChild(AS3FragmentParser.parseType(returnType));
		}
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock();
		ast.addChild(block);
		
		return new MethodNode(ast);
	}
	
	public static function synthesizeClass(qualifiedName:String):ICompilationUnitNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.COMPILATION_UNIT);
		var past:IParserNode = ASTUtil.newAST(AS3NodeKind.PACKAGE, "package");
		
		//past.appendToken(TokenBuilder.newSpace());
		ast.addChild(past);
		past.appendToken(TokenBuilder.newSpace());
		
		var packageName:String = packageNameFrom(qualifiedName);
		if (packageName)
		{
			past.addChild(AS3FragmentParser.parseName(packageName));
			past.appendToken(TokenBuilder.newSpace());
		}
		
		var block:IParserNode = newBlock(AS3NodeKind.CONTENT);
		past.addChild(block);
		
		var className:String = typeNameFrom(qualifiedName);
		var clazz:IParserNode = synthesizeAS3Class(className);
		ASTUtil.addChildWithIndentation(block, clazz);
		
		return new CompilationUnitNode(ast);
	}
	
	public static function synthesizeInterface(qualifiedName:String):ICompilationUnitNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.COMPILATION_UNIT);
		var past:IParserNode = ASTUtil.newAST(AS3NodeKind.PACKAGE, "package");
		
		ast.addChild(past);
		past.appendToken(TokenBuilder.newSpace());
		
		var packageName:String = packageNameFrom(qualifiedName);
		if (packageName)
		{
			past.addChild(AS3FragmentParser.parseName(packageName));
			past.appendToken(TokenBuilder.newSpace());
		}
		
		var block:IParserNode = newBlock(AS3NodeKind.CONTENT);
		past.addChild(block);
		
		var interfaceName:String = typeNameFrom(qualifiedName);
		var interfaze:IParserNode = synthesizeAS3Interface(interfaceName);
		ASTUtil.addChildWithIndentation(block, interfaze);
		
		return new CompilationUnitNode(ast);
	}
	
	
	private static function synthesizeAS3Class(className:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.CLASS);
		var mods:IParserNode = ASTUtil.newAST(AS3NodeKind.MOD_LIST);
		mods.addChild(ASTUtil.newAST(AS3NodeKind.MODIFIER, "public"));
		ast.addChild(mods);
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newClass());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.NAME, className));
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newBlock(AS3NodeKind.CONTENT));
		return ast;
	}
	
	private static function synthesizeAS3Interface(name:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.INTERFACE);
		var mods:IParserNode = ASTUtil.newAST(AS3NodeKind.MOD_LIST);
		mods.addChild(ASTUtil.newAST(AS3NodeKind.MODIFIER, "public"));
		ast.addChild(mods);
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newInterface());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.NAME, name));
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newBlock(AS3NodeKind.CONTENT));
		return ast;
	}
	
	private static function packageNameFrom(qualifiedName:String):String
	{
		var p:int = qualifiedName.lastIndexOf(".");
		if (p == -1) 
		{
			return null;
		}
		return qualifiedName.substring(0, p);
	}
	
	private static function typeNameFrom(qualifiedName:String):String
	{
		var p:int = qualifiedName.lastIndexOf('.');
		if (p == -1) 
		{
			return qualifiedName;
		}
		return qualifiedName.substring(p + 1);
	}
	
	
	public static function newBreak():IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.BREAK, "break");
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newContinue():IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.CONTINUE, "continue");
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newDeclaration(assignment:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.VAR_LIST, "var");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(assignment);
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newDefaultXMLNamespace(namespace:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.XML_NAMESPACE);
		ast.appendToken(TokenBuilder.newDefault());
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newXML());
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newNamespace());
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newAssign());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(namespace);
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newDoWhile(condition:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.DO, "do");
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock();
		ast.addChild(block);
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newWhile());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newCondition(condition));
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	public static function newObjectField(name:String, 
										  node:IParserNode):IParserNode
	{
		var field:IParserNode = ASTUtil.newAST(AS3NodeKind.PROP);
		field.addChild(AS3FragmentParser.parsePrimaryExpression(name));
		field.appendToken(TokenBuilder.newColumn());
		field.appendToken(TokenBuilder.newSpace());
		field.addChild(node);
		return field;
	}
	
	public static function newBlock(kind:String = null):IParserNode
	{
		if (!kind)
		{
			kind = AS3NodeKind.BLOCK;
		}
		
		var ast:IParserNode = ASTUtil.newParentheticAST(
			kind, 
			AS3NodeKind.LCURLY, "{", 
			AS3NodeKind.RCURLY, "}");
		var nl:LinkedListToken = TokenBuilder.newNewline();
		// insert the \n after the {
		ast.initialInsertionAfter.afterInsert(nl);
		// set new insertion point after \n
		ast.initialInsertionAfter = nl;
		return ast;
		
	}
	
	public static function newIf(ast:IParserNode):IParserNode
	{
		//var ast:IParserNode = AS3FragmentParser.parseExpression(condition);
		
		var ifStmnt:IParserNode = ASTUtil.newAST(AS3NodeKind.IF, "if");
		ifStmnt.appendToken(TokenBuilder.newSpace());
		ifStmnt.addChild(newCondition(ast));
		ifStmnt.appendToken(TokenBuilder.newSpace());
		ifStmnt.addChild(newBlock());
		
		return ifStmnt;
	}
	
	public static function newReturn(expression:IParserNode = null):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.RETURN, "return");
		if (expression)
		{
			ast.appendToken(TokenBuilder.newSpace());
			ast.addChild(expression);
		}
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newSwitch(condition:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.SWITCH, "switch");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newCondition(condition));
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock();
		ast.addChild(block);
		return ast;
	}
	
	public static function newThrow(expression:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.THROW, "throw");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(expression);
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newCondition(expr:IParserNode):IParserNode
	{
		var cond:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.CONDITION, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		cond.addChild(expr);
		return cond;
	}
	
	public static function newArrayLiteral():IParserNode
	{
		var ast:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ARRAY, 
			AS3NodeKind.LBRACKET, "[", 
			AS3NodeKind.RBRACKET, "]");
		return ast;
		
	}
	
	public static function newObjectLiteral():IParserNode
	{
		var ast:IParserNode = newBlock(AS3NodeKind.OBJECT);
		return ast;
	}
	
	public static function newFunctionLiteral():IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.LAMBDA);
		ast.appendToken(TokenBuilder.newFunction());
		//ast.appendToken(TokenBuilder.newSpace());
		// TODO: placeholder for name?
		var paren:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.PARAMETER_LIST, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		ast.addChild(paren);
		// added, best practices say put :void as default
		ast.appendToken(TokenBuilder.newColumn());
		var voidType:IParserNode = AS3FragmentParser.parseType("void");
		var nti:IParserNode = ASTUtil.newAST(AS3NodeKind.NAME_TYPE_INIT);
		nti.addChild(voidType);
		ast.addChild(nti);
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock();
		ast.addChild(block);
		return ast;
	}
	
	public static function newInvocationExpression(subExpr:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.CALL);
		ast.addChild(subExpr);
		var arguments:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ARGUMENTS, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		ast.addChild(arguments);
		return ast;
	}
	
	public static function newNewExpression(subExpr:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.NEW, "new");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(subExpr);
		var arguments:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ARGUMENTS, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		ast.addChild(arguments);
		return ast;
	}
	
	
	public static function newPostfixExpression(op:LinkedListToken, 
												subExpr:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.OP, op.text);
		TokenNode(ast).noUpdate = true;
		ast.addChild(subExpr);
		TokenNode(ast).noUpdate = false;
		ast.startToken = subExpr.startToken;
		subExpr.stopToken.next = op;
		return ast;
	}
	
	public static function newPrefixExpression(op:LinkedListToken, 
											   subExpr:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.OP, op.text);
		ast.addChild(subExpr);
		return ast;
	}
	
	public static function newFieldAccessExpression(target:IParserNode, 
													name:IParserNode):IParserNode
	{
		var op:LinkedListToken = TokenBuilder.newDot();
		var ast:IParserNode = ASTUtil.newTokenAST(op);
		
		TokenNode(ast).noUpdate = true;
		ast.addChild(target);
		ast.addChild(name);
		TokenNode(ast).noUpdate = false;
		
		target.stopToken.next = op;
		name.startToken.previous = op;
		
		ast.startToken = target.startToken;
		ast.stopToken = name.stopToken;
		
		return ast;
	}
	
	public static function newConditionalExpression(conditionExpression:IParserNode, 
													thenExpression:IParserNode,
													elseExpression:IParserNode):IParserNode
	{
		var op:LinkedListToken = TokenBuilder.newQuestion();
		var colon:LinkedListToken = TokenBuilder.newColumn();
		var ast:IParserNode = ASTUtil.newTokenAST(op);
		
		TokenNode(ast).noUpdate = true;
		ast.addChild(conditionExpression);
		conditionExpression.stopToken.next = op;
		ast.addChild(thenExpression);
		thenExpression.startToken.previous = op;
		thenExpression.stopToken.next = colon;
		ast.addChild(elseExpression);
		elseExpression.startToken.previous = colon;
		ast.startToken = conditionExpression.startToken;
		ast.stopToken = elseExpression.stopToken;
		TokenNode(ast).noUpdate = false;
		
		spaceEitherSide(op);
		spaceEitherSide(colon);
		
		return ast;
	}
	
	
	public static function newAssignmentExpression(op:LinkedListToken, 
												   left:IExpressionNode,
												   right:IExpressionNode):IAssignmentExpressionNode
	{
		var ast:IParserNode = ASTUtil.newTokenAST(op);
		var leftExpr:IParserNode = left.node;
		var rightExpr:IParserNode = right.node;
		
		if (precidence(ast) < precidence(leftExpr))
		{
			leftExpr = parenthise(leftExpr);
		}
		if (precidence(ast) < precidence(rightExpr))
		{
			rightExpr = parenthise(rightExpr);
		}
		
		TokenNode(ast).noUpdate = true;
		ast.addChild(leftExpr);
		ast.addChild(rightExpr);
		TokenNode(ast).noUpdate = false;
		
		leftExpr.stopToken.next = op;
		rightExpr.startToken.previous = op;
		
		ast.startToken = leftExpr.startToken;
		ast.stopToken = rightExpr.stopToken;
		
		spaceEitherSide(op);
		
		return new AssignmentExpressionNode(ast);
	}
	
	
	public static function newBinaryExpression(op:LinkedListToken, 
											   left:IExpressionNode,
											   right:IExpressionNode):IBinaryExpressionNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.OP, op.text);
		
		var leftExpr:IParserNode = left.node;
		var rightExpr:IParserNode = right.node;
		
		if (precidence(ast) < precidence(leftExpr))
		{
			leftExpr = parenthise(leftExpr);
		}
		if (precidence(ast) < precidence(rightExpr))
		{
			rightExpr = parenthise(rightExpr);
		}
		
		TokenNode(ast).noUpdate = true;
		ast.addChild(leftExpr);
		ast.addChild(rightExpr);
		TokenNode(ast).noUpdate = false;
		
		leftExpr.stopToken.next = op;
		rightExpr.startToken.previous = op;
		
		ast.startToken = leftExpr.startToken;
		ast.stopToken = rightExpr.stopToken;
		
		spaceEitherSide(op);
		
		return new BinaryOperatorNode(ast);
	}
	
	
	
	
	
	private static function spaceEitherSide(token:LinkedListToken):void
	{
		token.beforeInsert(TokenBuilder.newSpace());
		token.afterInsert(TokenBuilder.newSpace());
	}
	
	/**
	 * Escape the given String and place within double quotes so that it
	 * will be a valid ActionScript string literal.
	 */
	public static function escapeString(string:String):String
	{
		var result:String = "\"";
		
		var len:int = string.length;
		for (var i:int = 0; i < len; i++) 
		{
			var c:String = string.charAt(i);
			
			switch (c) 
			{
				case '\n':
					result += "\\n";
					break;
				case '\t':
					result += "\\t";
					break;
				case '\r':
					result += "\\r";
					break;
				case '"':
					result += "\\\"";
					break;
				case '\\':
					result += "\\\\";
					break;
				default:
					result += c;
			}
		}
		result += '"';
		
		return result;
	}
	
	private static function parenthise(expression:IParserNode):IParserNode
	{
		var result:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ENCAPSULATED, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		result.addChild(expression);
		return result;
	}
	
	
	private static function precidence(ast:IParserNode):int
	{
		switch (ast.kind) 
		{
			case AS3NodeKind.ASSIGN:
				return 13;
			case AS3NodeKind.CONDITIONAL:
				return 12;
			default:
				return 1;
				
				/*
				case AS3Parser.ASSIGN:
				case AS3Parser.STAR_ASSIGN:
				case AS3Parser.DIV_ASSIGN:
				case AS3Parser.MOD_ASSIGN:
				case AS3Parser.PLUS_ASSIGN:
				case AS3Parser.MINUS_ASSIGN:
				case AS3Parser.SL_ASSIGN:
				case AS3Parser.SR_ASSIGN:
				case AS3Parser.BSR_ASSIGN:
				case AS3Parser.BAND_ASSIGN:
				case AS3Parser.BXOR_ASSIGN:
				case AS3Parser.BOR_ASSIGN:
				case AS3Parser.LAND_ASSIGN:
				case AS3Parser.LOR_ASSIGN:
				return 13;
				case AS3Parser.QUESTION:
				return 12;
				case AS3Parser.LOR:
				return 11;
				case AS3Parser.LAND:
				return 10;
				case AS3Parser.BOR:
				return 9;
				case AS3Parser.BXOR:
				return 8;
				case AS3Parser.BAND:
				return 7;
				case AS3Parser.STRICT_EQUAL:
				case AS3Parser.STRICT_NOT_EQUAL:
				case AS3Parser.NOT_EQUAL:
				case AS3Parser.EQUAL:
				return 6;
				case AS3Parser.IN:
				case AS3Parser.LT:
				case AS3Parser.GT:
				case AS3Parser.LE:
				case AS3Parser.GE:
				case AS3Parser.IS:
				case AS3Parser.AS:
				case AS3Parser.INSTANCEOF:
				return 5;
				case AS3Parser.SL:
				case AS3Parser.SR:
				case AS3Parser.BSR:
				return 4;
				case AS3Parser.PLUS:
				case AS3Parser.MINUS:
				return 3;
				case AS3Parser.STAR:
				case AS3Parser.DIV:
				case AS3Parser.MOD:
				return 2;
				default:
				return 1;
				*/
		}
	}
}
}