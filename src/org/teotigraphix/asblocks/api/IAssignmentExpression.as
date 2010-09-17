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
 * An assigment expression; <code>a = b;</code>, <code>a += b;</code>
 * or <code>a -= b;</code>.
 * 
 * <pre>
 * var left:IExpression = factory.newExpression("myAnswer");
 * var right:IExpression = factory.newExpression("4");
 * var expression:IAssignmentExpression = factory.newAssignmentExpression(left, right);
 * </pre>
 * 
 * <p>Will produce <code>myAnswer = 4</code>.</p>
 * 
 * <pre>
 * var left:IExpression = factory.newExpression("myAnswer");
 * var right:IExpression = factory.newExpression("4");
 * var expression:IAssignmentExpression = factory.newAssignmentExpression(left, right);
 * expression.rightExpression = factory.newExpression("otherAnswer = 4");
 * </pre>
 * 
 * <p>Will produce <code>myAnswer = otherAnswer = 4</code>.</p>
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IAssignmentExpression extends IExpression
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  leftExpression
	//----------------------------------
	
	/**
	 * The <code>IExpression</code> contained on the left side of the assignment.
	 */
	function get leftExpression():IExpression;
	
	/**
	 * @private
	 */
	function set leftExpression(value:IExpression):void;
	
	//----------------------------------
	//  operator
	//----------------------------------
	
	/**
	 * The assignment's operator.
	 */
	function get operator():String;
	
	/**
	 * @private
	 */
	function set operator(value:String):void;
	
	//----------------------------------
	//  rightExpression
	//----------------------------------
	
	/**
	 * The <code>IExpression</code> contained on the right side of the assignment.
	 */
	function get rightExpression():IExpression;
	
	/**
	 * @private
	 */
	function set rightExpression(value:IExpression):void;
}
}