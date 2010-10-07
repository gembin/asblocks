package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.api.IAssignmentExpression;
import org.as3commons.asblocks.api.IBinaryExpression;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.LinkedListToken;
import org.as3commons.asblocks.parser.core.TokenNode;
import org.as3commons.asblocks.utils.ASTUtil;

public class ASTExpressionBuilder
{
	public static function newConditionalExpression(conditionExpression:IParserNode, 
													thenExpression:IParserNode,
													elseExpression:IParserNode):IParserNode
	{
		var op:LinkedListToken = TokenBuilder.newQuestion();
		var colon:LinkedListToken = TokenBuilder.newColon();
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
		
		ASTBuilder.spaceEitherSide(op);
		ASTBuilder.spaceEitherSide(colon);
		
		return ast;
	}
	
	public static function newPostfixExpression(op:LinkedListToken, 
												subExpr:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newPostfixAST(op);
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
		var ast:IParserNode = ASTUtil.newPrefixAST(op);
		ast.addChild(subExpr);
		return ast;
	}
	
	public static function newAssignExpression(op:LinkedListToken, 
											   left:IExpression,
											   right:IExpression):IAssignmentExpression
	{
		// assignment[left,op(assign[=]),right]
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.ASSIGNMENT);
		
		var leftAST:IParserNode = left.node;
		var rightAST:IParserNode = right.node;
		
		if (ASTBuilder.precidence(ast) < ASTBuilder.precidence(leftAST))
		{
			leftAST = ASTBuilder.parenthise(leftAST);
		}
		if (ASTBuilder.precidence(ast) < ASTBuilder.precidence(rightAST))
		{
			rightAST = ASTBuilder.parenthise(rightAST);
		}
		
		ast.addChild(leftAST);
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.ASSIGN, op.text));
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(rightAST);
		
		return new AssignmentExpressionNode(ast);
	}
	
	
	public static function newBinaryExpression(op:LinkedListToken, 
											   left:IExpression,
											   right:IExpression):IBinaryExpression
	{
		var ast:IParserNode = ASTUtil.newBinaryAST(op);
		var opAST:IParserNode = ASTUtil.newTokenAST(op);
		
		var leftExpr:IParserNode = left.node;
		var rightExpr:IParserNode = right.node;
		
		if (ASTBuilder.precidence(opAST) < ASTBuilder.precidence(leftExpr))
		{
			leftExpr = ASTBuilder.parenthise(leftExpr);
		}
		if (ASTBuilder.precidence(opAST) < ASTBuilder.precidence(rightExpr))
		{
			rightExpr = ASTBuilder.parenthise(rightExpr);
		}
		
		TokenNode(ast).noUpdate = true;
		ast.addChild(leftExpr);
		ast.addChild(opAST);
		ast.addChild(rightExpr);
		TokenNode(ast).noUpdate = false;
		
		leftExpr.stopToken.next = op;
		rightExpr.startToken.previous = op;
		
		ast.startToken = leftExpr.startToken;
		ast.stopToken = rightExpr.stopToken;
		
		ASTBuilder.spaceEitherSide(op);
		
		return new BinaryExpressionNode(ast);
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
}
}