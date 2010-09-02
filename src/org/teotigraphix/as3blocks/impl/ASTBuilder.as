package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.IAssignmentExpressionNode;
import org.teotigraphix.as3blocks.api.IBinaryExpressionNode;
import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3blocks.utils.ASTUtil2;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.TokenNode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;

public class ASTBuilder
{
	
	
	public static function newObjectField(name:String, 
										  node:IParserNode):IParserNode
	{
		var field:IParserNode = ASTUtil2.newAST(AS3NodeKind.PROP);
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
		
		var ast:IParserNode = ASTUtil2.newParentheticAST(
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
	
	public static function newArrayLiteral():IParserNode
	{
		var ast:IParserNode = ASTUtil2.newParentheticAST(
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
		var ast:IParserNode = ASTUtil2.newAST(AS3NodeKind.LAMBDA);
		ast.appendToken(TokenBuilder.newFunction());
		//ast.appendToken(TokenBuilder.newSpace());
		// TODO: placeholder for name?
		var paren:IParserNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.PARAMETER_LIST, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		ast.addChild(paren);
		// added, best practices say put :void as default
		ast.appendToken(TokenBuilder.newColumn());
		var voidType:IParserNode = AS3FragmentParser.parseType("void");
		var nti:IParserNode = ASTUtil2.newAST(AS3NodeKind.NAME_TYPE_INIT);
		nti.addChild(voidType);
		ast.addChild(nti);
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock();
		ast.addChild(block);
		return ast;
	}
	
	public static function newConditionalExpression(conditionExpression:IParserNode, 
													thenExpression:IParserNode,
													elseExpression:IParserNode):IParserNode
	{
		var op:LinkedListToken = TokenBuilder.newQuestion();
		var colon:LinkedListToken = TokenBuilder.newColumn();
		var ast:IParserNode = ASTUtil2.newTokenAST(op);
		
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
		var ast:IParserNode = ASTUtil2.newTokenAST(op);
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
		var ast:IParserNode = ASTUtil2.newAST(AS3NodeKind.OP, op.text);
		
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
		var result:IParserNode = ASTUtil2.newParentheticAST(
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