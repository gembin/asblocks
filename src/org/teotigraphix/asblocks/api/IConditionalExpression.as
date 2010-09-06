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
 * Conditional expression; <code>(a != b) ? true : false</code>.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IConditionalExpression 
	extends IExpression, IScriptNode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  conditionExpression
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get conditionExpression():IExpression;
	
	/**
	 * @private
	 */
	function set conditionExpression(value:IExpression):void;
	
	//----------------------------------
	//  thenExpression
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get thenExpression():IExpression;
	
	/**
	 * @private
	 */
	function set thenExpression(value:IExpression):void;
	
	//----------------------------------
	//  elseExpression
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get elseExpression():IExpression;
	
	/**
	 * @private
	 */
	function set elseExpression(value:IExpression):void;
}
}