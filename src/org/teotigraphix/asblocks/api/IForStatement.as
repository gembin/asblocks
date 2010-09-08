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
 * TODO Docme
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IForStatement extends IStatement, IStatementContainer
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  initializer
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get initializer():IExpression;
	
	/**
	 * @private
	 */
	function set initializer(value:IExpression):void;
	
	//----------------------------------
	//  condition
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get condition():IExpression;
	
	/**
	 * @private
	 */
	function set condition(value:IExpression):void;
	
	//----------------------------------
	//  update
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get update():IExpression;
	
	/**
	 * @private
	 */
	function set update(value:IExpression):void;
}
}