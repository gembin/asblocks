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

package org.teotigraphix.asblocks
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.api.IArrayAccessExpression;
import org.teotigraphix.asblocks.api.IArrayLiteral;
import org.teotigraphix.asblocks.api.IAssignmentExpression;
import org.teotigraphix.asblocks.api.IBinaryExpression;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IBooleanLiteral;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IConditionalExpression;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IFieldAccessExpression;
import org.teotigraphix.asblocks.api.IFunctionLiteral;
import org.teotigraphix.asblocks.api.IINvocationExpression;
import org.teotigraphix.asblocks.api.IIfStatement;
import org.teotigraphix.asblocks.api.INewExpression;
import org.teotigraphix.asblocks.api.INullLiteral;
import org.teotigraphix.asblocks.api.INumberLiteral;
import org.teotigraphix.asblocks.api.IObjectLiteral;
import org.teotigraphix.asblocks.api.IPostfixExpression;
import org.teotigraphix.asblocks.api.IPrefixExpression;
import org.teotigraphix.asblocks.api.ISimpleNameExpression;
import org.teotigraphix.asblocks.api.IStringLiteral;
import org.teotigraphix.asblocks.api.IUndefinedLiteral;
import org.teotigraphix.asblocks.impl.ASParser;
import org.teotigraphix.asblocks.impl.ASTBuilder;
import org.teotigraphix.asblocks.impl.ASWriter;
import org.teotigraphix.asblocks.impl.ArrayAccessExpressionNode;
import org.teotigraphix.asblocks.impl.ArrayLiteralNode;
import org.teotigraphix.asblocks.impl.BooleanLiteralNode;
import org.teotigraphix.asblocks.impl.ConditionalExpressionNode;
import org.teotigraphix.asblocks.impl.ExpressionBuilder;
import org.teotigraphix.asblocks.impl.FieldAccessExpression;
import org.teotigraphix.asblocks.impl.FunctionLiteralNode;
import org.teotigraphix.asblocks.impl.IfStatementNode;
import org.teotigraphix.asblocks.impl.InvocationExpressionNode;
import org.teotigraphix.asblocks.impl.NewExpressionNode;
import org.teotigraphix.asblocks.impl.NullLiteralNode;
import org.teotigraphix.asblocks.impl.NumberLiteralNode;
import org.teotigraphix.asblocks.impl.ObjectLiteralNode;
import org.teotigraphix.asblocks.impl.PostfixExpressionNode;
import org.teotigraphix.asblocks.impl.PrefixExpressionNode;
import org.teotigraphix.asblocks.impl.SimpleNameExpressionNode;
import org.teotigraphix.asblocks.impl.StatementList;
import org.teotigraphix.asblocks.impl.StringLiteralNode;
import org.teotigraphix.asblocks.impl.TokenBuilder;
import org.teotigraphix.asblocks.impl.UndefinedLiteralNode;
import org.teotigraphix.asblocks.utils.ASTUtil;

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
	public function newAssignmentExpression(left:IExpression,
											right:IExpression):IAssignmentExpression
	{
		return ASTBuilder.newAssignmentExpression(TokenBuilder.newAssign(), left, right);
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
		return new FieldAccessExpression(ast);
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