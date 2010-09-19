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
 * A binary expression; <code>a == b;</code>, <code>a != b;</code>
 * or <code>a + b;</code>.
 * 
 * <pre>
 * var left:IExpression = factory.newExpression("a");
 * var right:IExpression = factory.newExpression("b");
 * var expression:IBinaryExpression = factory.newAndExpression(left, right);
 * </pre>
 * 
 * <p>Will produce <code>a && b</code>.</p>
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 * 
 * @see org.teotigraphix.asblocks.api.BinaryOperator
 * 
 * @see org.teotigraphix.asblocks.ASFactory#newAddExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newAndExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newBitAndExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newBitOrExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newBitXorExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newDivisionExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newEqualsExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newGreaterEqualsExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newGreaterThanExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newLessEqualsExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newLessThanExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newModuloExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newMultiplyExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newNotEqualsExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newOrExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newShiftLeftExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newShiftRightExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newShiftRightUnsignedExpression()
 * @see org.teotigraphix.asblocks.ASFactory#newSubtractExpression()
 */
public interface IBinaryExpression extends IExpression
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
	 * The <code>IExpression</code> contained on the left side of the binary relation.
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
	 * The relation's binrary operator eg; <code>+</code>, <code>==</code>,
	 * <code>!=</code>, ect.
	 */
	function get operator():BinaryOperator;
	
	/**
	 * @private
	 */
	function set operator(value:BinaryOperator):void;
	
	//----------------------------------
	//  rightExpression
	//----------------------------------
	
	/**
	 * The <code>IExpression</code> contained on the right side of the binary relation.
	 */
	function get rightExpression():IExpression;
	
	/**
	 * @private
	 */
	function set rightExpression(value:IExpression):void;
}
}