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
//	function get hasCode():Boolean;
	
	//----------------------------------
	//  statements
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
//	function get statements():Vector.<IStatementNode>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
//	function addComment(text:String):void;
	
	function addStatement(statement:String):IStatementNode;
	
	// then all the new factory methods
	
	/**
	 * TODO Docme
	 */
	function newExpressionStatement(statement:String):IExpressionStatementNode;
	
	/**
	 * TODO Docme
	 */
	function newBreak():IBreakStatementNode;
	
	/**
	 * TODO Docme
	 */
	function newContinue():IContinueStatementNode;
	
	/**
	 * TODO Docme
	 */
	function newDeclaration(assignment:IExpressionNode):IDeclarationStatementNode;
	
	/**
	 * TODO Docme
	 */
	function newDefaultXMLNamespace(namespace:String):IDefaultXMLNamespaceStatementNode;
	
	/**
	 * TODO Docme
	 */
	function newDoWhile(condition:IExpressionNode):IDoWhileStatementNode;
	
	/**
	 * TODO Docme
	 */
	function newIf(condition:IExpressionNode):IIfStatementNode;
	
	/**
	 * TODO Docme
	 */
	function newReturn(expression:IExpressionNode = null):IReturnStatementNode
	
	/**
	 * @private
	 */
	function newSwitch(condition:IExpressionNode):ISwitchStatementNode;
	
	/**
	 * @private
	 */
	function newThrow(expression:IExpressionNode):IThrowStatementNode;
}
}