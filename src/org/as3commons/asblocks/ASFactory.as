////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package org.as3commons.asblocks
{

import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.api.KeyWords;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.api.IArrayAccessExpression;
import org.as3commons.asblocks.api.IArrayLiteral;
import org.as3commons.asblocks.api.IAssignmentExpression;
import org.as3commons.asblocks.api.IBinaryExpression;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IBooleanLiteral;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IConditionalExpression;
import org.as3commons.asblocks.api.IDeclarationStatement;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.IFieldAccessExpression;
import org.as3commons.asblocks.api.IFunctionLiteral;
import org.as3commons.asblocks.api.IINvocationExpression;
import org.as3commons.asblocks.api.INewExpression;
import org.as3commons.asblocks.api.INullLiteral;
import org.as3commons.asblocks.api.INumberLiteral;
import org.as3commons.asblocks.api.IObjectLiteral;
import org.as3commons.asblocks.api.IPostfixExpression;
import org.as3commons.asblocks.api.IPrefixExpression;
import org.as3commons.asblocks.api.ISimpleNameExpression;
import org.as3commons.asblocks.api.IStatement;
import org.as3commons.asblocks.api.IStringLiteral;
import org.as3commons.asblocks.api.IUndefinedLiteral;
import org.as3commons.asblocks.impl.ASParser;
import org.as3commons.asblocks.impl.ASProject;
import org.as3commons.asblocks.impl.ASTBuilder;
import org.as3commons.asblocks.impl.ASWriter;
import org.as3commons.asblocks.impl.ArrayAccessExpressionNode;
import org.as3commons.asblocks.impl.ArrayLiteralNode;
import org.as3commons.asblocks.impl.BooleanLiteralNode;
import org.as3commons.asblocks.impl.ConditionalExpressionNode;
import org.as3commons.asblocks.impl.DeclarationStatementNode;
import org.as3commons.asblocks.impl.ExpressionBuilder;
import org.as3commons.asblocks.impl.FieldAccessExpressionNode;
import org.as3commons.asblocks.impl.FunctionLiteralNode;
import org.as3commons.asblocks.impl.InvocationExpressionNode;
import org.as3commons.asblocks.impl.NewExpressionNode;
import org.as3commons.asblocks.impl.NullLiteralNode;
import org.as3commons.asblocks.impl.NumberLiteralNode;
import org.as3commons.asblocks.impl.ObjectLiteralNode;
import org.as3commons.asblocks.impl.PostfixExpressionNode;
import org.as3commons.asblocks.impl.PrefixExpressionNode;
import org.as3commons.asblocks.impl.SimpleNameExpressionNode;
import org.as3commons.asblocks.impl.StatementBuilder;
import org.as3commons.asblocks.impl.StatementList;
import org.as3commons.asblocks.impl.StringLiteralNode;
import org.as3commons.asblocks.impl.TokenBuilder;
import org.as3commons.asblocks.impl.UndefinedLiteralNode;
import org.as3commons.asblocks.utils.ASTUtil;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASFactory
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASFactory()
	{
		super();
	}
	
	//----------------------------------
	//  Types
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newClass(qualifiedName:String):ICompilationUnit
	{
		return ASTBuilder.synthesizeClass(qualifiedName);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newInterface(qualifiedName:String):ICompilationUnit
	{
		return ASTBuilder.synthesizeInterface(qualifiedName);
	}
	
	//----------------------------------
	//  Literals
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newNumberLiteral(number:Number):INumberLiteral
	{
		return new NumberLiteralNode(ASTUtil.newAST(AS3NodeKind.NUMBER, number.toString()));
	}
	
	/**
	 * TODO DOCME
	 */
	public function newNullLiteral():INullLiteral
	{
		return new NullLiteralNode(ASTUtil.newAST(AS3NodeKind.NULL, KeyWords.NULL));
	}
	
	/**
	 * TODO DOCME
	 */
	public function newUndefinedLiteral():IUndefinedLiteral
	{
		return new UndefinedLiteralNode(ASTUtil.newAST(AS3NodeKind.UNDEFINED, KeyWords.UNDEFINED));
	}
	
	/**
	 * TODO DOCME
	 */
	public function newBooleanLiteral(boolean:Boolean):IBooleanLiteral
	{
		var kind:String = (boolean) ? AS3NodeKind.TRUE : AS3NodeKind.FALSE;
		var text:String = (boolean) ? KeyWords.TRUE : KeyWords.FALSE;
		return new BooleanLiteralNode(ASTUtil.newAST(kind, text));
	}
	
	/**
	 * TODO DOCME
	 */
	public function newStringLiteral(string:String):IStringLiteral
	{
		return new StringLiteralNode(ASTUtil.newAST(AS3NodeKind.STRING, ASTBuilder.escapeString(string)));
	}
	
	/**
	 * TODO DOCME
	 */
	public function newArrayLiteral():IArrayLiteral
	{
		var ast:IParserNode = ASTBuilder.newArrayLiteral();
		return new ArrayLiteralNode(ast);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newObjectLiteral():IObjectLiteral
	{
		var ast:IParserNode = ASTBuilder.newObjectLiteral();
		return new ObjectLiteralNode(ast);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newFunctionLiteral():IFunctionLiteral
	{
		var ast:IParserNode = ASTBuilder.newFunctionLiteral();
		return new FunctionLiteralNode(ast);
	}
	
	//----------------------------------
	//  Expressions
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newExpression(expression:String):IExpression
	{
		var ast:IParserNode = AS3FragmentParser.parseExpression(expression);
		ast.parent = null;
		return ExpressionBuilder.build(ast);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newStatement(expression:String):IStatement
	{
		var ast:IParserNode = AS3FragmentParser.parseStatement(expression);
		ast.parent = null;
		return StatementBuilder.build(ast);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newDeclaration(declaration:String):IDeclarationStatement
	{
		var ast:IParserNode = AS3FragmentParser.parseDecList(declaration);
		ast.parent = null;
		return StatementBuilder.build(ast) as IDeclarationStatement;
	}
	
	//----------------------------------
	//  Assignment Expressions
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newAssignExpression(left:IExpression,
										right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newAddAssignExpression(left:IExpression,
										   right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newAddAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newBitAndAssignExpression(left:IExpression,
											  right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newBitAndAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newBitOrAssignExpression(left:IExpression,
											 right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newBitOrAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newBitXorAssignExpression(left:IExpression,
											  right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newBitXorAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newDivideAssignExpression(left:IExpression,
											  right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newDivAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newModuloAssignExpression(left:IExpression,
											  right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newModAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newMultiplyAssignExpression(left:IExpression,
												right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newStarAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newShiftLeftAssignExpression(left:IExpression,
												 right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newSLAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newShiftRightAssignExpression(left:IExpression,
												  right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newSRAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newShiftRightUnsignedAssignExpression(left:IExpression,
														  right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newSRUAssign(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newSubtractAssignExpression(left:IExpression,
												right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignExpression(TokenBuilder.newSubAssign(), left, right);
	}
	
	//----------------------------------
	//  Binary Expressions
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newAddExpression(left:IExpression, 
									 right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newPlus(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newAndExpression(left:IExpression, 
									 right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newAnd(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newBitAndExpression(left:IExpression, 
										right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newBitAnd(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newBitOrExpression(left:IExpression, 
									   right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newBitOr(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newBitXorExpression(left:IExpression, 
										right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newBitXor(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newDivisionExpression(left:IExpression, 
										  right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newDiv(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newEqualsExpression(left:IExpression, 
										right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newEquals(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newGreaterEqualsExpression(left:IExpression, 
											   right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newGreaterEquals(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newGreaterThanExpression(left:IExpression, 
											 right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newGreater(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newLessEqualsExpression(left:IExpression, 
											right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newLessEquals(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newLessThanExpression(left:IExpression, 
										  right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newLess(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newModuloExpression(left:IExpression, 
										right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newModulo(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newMultiplyExpression(left:IExpression, 
										  right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newMult(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newNotEqualsExpression(left:IExpression, 
										   right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newNotEquals(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newOrExpression(left:IExpression, 
									right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newOr(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newShiftLeftExpression(left:IExpression, 
										   right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newShiftLeft(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newShiftRightExpression(left:IExpression, 
											right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newShiftRight(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newShiftRightUnsignedExpression(left:IExpression, 
													right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newShiftRightUnsigned(), left, right);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newSubtractExpression(left:IExpression, 
										  right:IExpression):IBinaryExpression
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newMinus(), left, right);
	}
	
	//----------------------------------
	//  Conditional Expression
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newConditionalExpression(conditionExpression:IExpression, 
											 thenExpression:IExpression,
											 elseExpression:IExpression):IConditionalExpression
	{
		var ast:IParserNode = ASTBuilder.newConditionalExpression(
			conditionExpression.node, thenExpression.node, elseExpression.node);
		return new ConditionalExpressionNode(ast);
	}
	
	//----------------------------------
	//  Invocation Expressions
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newInvocationExpression(target:IExpression, 
											args:Vector.<IExpression>):IINvocationExpression
	{
		var ast:IParserNode = ASTBuilder.newInvocationExpression(target.node);
		var result:IINvocationExpression = new InvocationExpressionNode(ast);
		result.arguments = args;
		return result;
	}
	
	/**
	 * TODO DOCME
	 */
	public function newNewExpression(target:IExpression, 
									 args:Vector.<IExpression>):INewExpression
	{
		var ast:IParserNode = ASTBuilder.newNewExpression(target.node);
		var result:INewExpression = new NewExpressionNode(ast);
		result.arguments = args;
		return result;
	}
	
	//----------------------------------
	//  Post & Prefix Expressions
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newPostDecExpression(sub:IExpression):IPostfixExpression
	{
		var ast:IParserNode = ASTBuilder.newPostfixExpression(
			TokenBuilder.newPostDec(), sub.node);
		return new PostfixExpressionNode(ast);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newPostIncExpression(sub:IExpression):IPostfixExpression
	{
		var ast:IParserNode = ASTBuilder.newPostfixExpression(
			TokenBuilder.newPostInc(), sub.node);
		return new PostfixExpressionNode(ast);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newPreDecExpression(sub:IExpression):IPrefixExpression
	{
		var ast:IParserNode = ASTBuilder.newPrefixExpression(
			TokenBuilder.newPreDec(), sub.node);
		return new PrefixExpressionNode(ast);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newPreIncExpression(sub:IExpression):IPrefixExpression
	{
		var ast:IParserNode = ASTBuilder.newPrefixExpression(
			TokenBuilder.newPreInc(), sub.node);
		return new PrefixExpressionNode(ast);
	}
	
	//----------------------------------
	//  Access Expressions
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newFieldAccessExpression(target:IExpression, 
											 name:String):IFieldAccessExpression
	{
		var ast:IParserNode = ASTBuilder.newFieldAccessExpression(
			target.node, ASTUtil.newAST(AS3NodeKind.NAME, name));
		return new FieldAccessExpressionNode(ast);
	}
	
	/**
	 * TODO DOCME
	 */
	public function newArrayAccessExpression(target:IExpression, 
											 subscript:IExpression):IArrayAccessExpression
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.ARRAY_ACCESSOR);
		var targetAST:IParserNode = target.node;
		ast.addChild(targetAST);
		ast.appendToken(TokenBuilder.newLeftBracket());
		var subAST:IParserNode = subscript.node;
		ast.addChild(subAST);
		ast.appendToken(TokenBuilder.newRightBracket());
		
		var result:ArrayAccessExpressionNode = new ArrayAccessExpressionNode(ast);
		
		return result;
	}
	
	//----------------------------------
	//  Name Expressions
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newSimpleNameExpression(name:String):ISimpleNameExpression
	{
		var ast:IParserNode = AS3FragmentParser.parsePrimaryExpression(name);
		var result:ISimpleNameExpression = new SimpleNameExpressionNode(ast);
		return result;
	}
	
	//----------------------------------
	//  Statements
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	public function newBlock():IBlock
	{
		var ast:IParserNode = ASTBuilder.newBlock();
		return new StatementList(ast);
	}
	
	/**
	 * TODO DOCME
	 */
	public function parseDeclarationStatement(assignment:String):IDeclarationStatement
	{
		var ast:IParserNode = AS3FragmentParser.parseDecList(assignment);
		return new DeclarationStatementNode(ast);
	}
	
	
	
	
	/**
	 * TODO DOCME
	 */
	public function newEmptyASProject(outputLocation:String):IASProject
	{
		var result:IASProject = new ASProject(this);
		result.outputLocation = outputLocation;
		return result;
	}
	
	/**
	 * TODO DOCME
	 */
	public function newParser():IASParser
	{
		return new ASParser();
	}
	
	/**
	 * TODO DOCME
	 */
	public function newWriter():IASWriter
	{
		return new ASWriter();
	}
	
	
}
}