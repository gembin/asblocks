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

package org.teotigraphix.asblocks.api
{
import org.teotigraphix.as3parser.api.IToken;

/**
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IStatementContainer
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  hasCode
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get hasCode():Boolean;
	
	//----------------------------------
	//  statements
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get statements():Vector.<IStatement>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	function addComment(text:String):IToken;
	
	function removeComment(statement:IStatement):IToken;
	
	function addStatement(statement:String):IStatement;
	
	function removeStatement(statement:IStatement):IStatement;
	
	function removeStatementAt(index:int):IStatement;
	
	// then all the new factory methods
	
	
	
	/**
	 * TODO Docme
	 */
	function newBreak(label:String = null):IBreakStatement;
	
	/**
	 * TODO Docme
	 */
	function newContinue(label:String = null):IContinueStatement;
	
	/**
	 * TODO Docme
	 */
	function newDeclaration(declaration:String):IDeclarationStatement;
	
	/**
	 * TODO Docme
	 */
	function newDefaultXMLNamespace(namespace:String):IDefaultXMLNamespaceStatement;
	
	/**
	 * TODO Docme
	 */
	function newDoWhile(condition:IExpression):IDoWhileStatement;
	
	/**
	 * TODO Docme
	 */
	function newExpressionStatement(statement:String):IExpressionStatement;
	
	/**
	 * TODO Docme
	 */
	function newFor(initializer:IExpression, 
					condition:IExpression, 
					iterater:IExpression):IForStatement;
	
	/**
	 * TODO Docme
	 */
	function parseNewFor(initializer:String, 
						 condition:String, 
						 iterater:String):IForStatement;
	
	/**
	 * TODO Docme
	 */
	function newForEachIn(declaration:IScriptNode, 
						  target:IExpression):IForEachInStatement;
	
	/**
	 * TODO Docme
	 */
	//function parseNewForEachIn(declaration:String, 
	//						   target:String):IForEachInStatement;
	
	/**
	 * TODO Docme
	 */
	function newForIn(declaration:IScriptNode, 
					  target:IExpression):IForInStatement;
	
	/**
	 * TODO Docme
	 */
	//function parseNewForIn(declaration:String, 
	//					   target:String):IForInStatement;
	
	/**
	 * TODO Docme
	 */
	function newIf(condition:IExpression):IIfStatement;
	
	/**
	 * TODO Docme
	 */
	function newLabel(name:String):ILabelStatement;
	
	/**
	 * TODO Docme
	 */
	function newForLabel(name:String, kind:String):ILabelStatement;
	
	/**
	 * TODO Docme
	 */
	//function newWhileLabel(name:String):ILabelStatement;
	
	/**
	 * TODO Docme
	 */
	function newReturn(expression:IExpression = null):IReturnStatement
	
	/**
	 * TODO Docme
	 */
	function newSuper(arguments:Vector.<IArgument>):ISuperStatement;
		
	/**
	 * @private
	 */
	function newSwitch(condition:IExpression):ISwitchStatement;
	
	/**
	 * @private
	 */
	function newThrow(expression:IExpression):IThrowStatement;
	
	/**
	 * @private
	 */
	function newTryCatch(name:String, type:String):ITryStatement;
	
	/**
	 * @private
	 */
	function newTryFinally():ITryStatement;
	
	/**
	 * @private
	 */
	function newWhile(condition:IExpression):IWhileStatement;
	
	/**
	 * @private
	 */
	function newWith(condition:IExpression):IWithStatement;
}
}