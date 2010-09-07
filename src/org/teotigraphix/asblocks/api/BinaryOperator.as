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

import com.ericfeminella.collections.HashMap;
import com.ericfeminella.collections.IMap;

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.Token;

/**
 * Binary operators.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public final class BinaryOperator
{
	private static var map:IMap;
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	public static const ADD:BinaryOperator = BinaryOperator.create(Operators.PLUS);
	
	public static const AND:BinaryOperator = BinaryOperator.create(Operators.LOGICAL_AND);
	
	public static const BITAND:BinaryOperator = BinaryOperator.create(Operators.B_AND);
	
	public static const BITOR:BinaryOperator = BinaryOperator.create(Operators.B_OR);
	
	public static const BITXOR:BinaryOperator = BinaryOperator.create(Operators.B_XOR);
	
	public static const DIV:BinaryOperator = BinaryOperator.create(Operators.SLASH);
	
	public static const EQ:BinaryOperator = BinaryOperator.create(Operators.DOUBLE_EQUAL);
	
	public static const GE:BinaryOperator = BinaryOperator.create(Operators.SUPERIOR_OR_EQUAL);
	
	public static const GT:BinaryOperator = BinaryOperator.create(Operators.SUPERIOR);
	
	public static const LE:BinaryOperator = BinaryOperator.create(Operators.INFERIOR_OR_EQUAL);
	
	public static const LT:BinaryOperator = BinaryOperator.create(Operators.INFERIOR);
	
	public static const MOD:BinaryOperator = BinaryOperator.create(Operators.MODULO);
	
	public static const MUL:BinaryOperator = BinaryOperator.create(Operators.TIMES);
	
	public static const NE:BinaryOperator = BinaryOperator.create(Operators.NON_EQUAL);
	
	public static const OR:BinaryOperator = BinaryOperator.create(Operators.LOGICAL_OR);
	
	public static const SL:BinaryOperator = BinaryOperator.create(Operators.DOUBLE_SHIFT_LEFT);
	
	public static const SR:BinaryOperator = BinaryOperator.create(Operators.DOUBLE_SHIFT_RIGHT);
	
	public static const SRU:BinaryOperator = BinaryOperator.create(Operators.TRIPLE_SHIFT_RIGHT);
	
	public static const SUB:BinaryOperator = BinaryOperator.create(Operators.MINUS);
	
	private static var intialized:Boolean = false;
	
	private static function init():void
	{
		if (intialized)
			return;
		
		map = new HashMap();
		map.put(AS3NodeKind.ADD, ADD);
		map.put(AS3NodeKind.AND, AND);
		
		intialized = true;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * The operator name.
	 */
	public function get name():String
	{
		return _name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function BinaryOperator(name:String)
	{
		_name = name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function toString():String
	{
		return _name;
	}
	
	/**
	 * @private
	 */
	public function equals(other:BinaryOperator):Boolean
	{
		return _name == other.name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new BinaryOperator.
	 * 
	 * @param name A String indicating the name of the BinaryOperator.
	 * @return A new BinaryOperator instance.
	 */
	private static function create(name:String):BinaryOperator
	{
		if (!map)
			map = new HashMap();
		
		var op:BinaryOperator = map.getValue(name);
		if (op)
			return op;
		
		return new BinaryOperator(name);
	}
	
	public static function find(type:String):BinaryOperator
	{
		if (!intialized)
			init();
		
		return map.getValue(type);
	}
	
	public static function initialize(operator:BinaryOperator, token:Token):void
	{
		var ltok:LinkedListToken = token as LinkedListToken;
		var op:BinaryOperator = find(operator.name);
		if (!op)
			return;
		
		ltok.text = op.name;
		ltok.kind = AS3NodeKind.OP;
	}
}
}