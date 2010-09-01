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

package org.teotigraphix.as3blocks.api
{
import org.teotigraphix.as3parser.api.AS3NodeKind;
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
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	public static const ADD:BinaryOperator = BinaryOperator.create("+");
	
	public static const AND:BinaryOperator = BinaryOperator.create("&&");
	
	public static const BITAND:BinaryOperator = BinaryOperator.create("&");
	
	public static const BITOR:BinaryOperator = BinaryOperator.create("|");
	
	public static const BITXOR:BinaryOperator = BinaryOperator.create("^");
	
	public static const DIV:BinaryOperator = BinaryOperator.create("/");
	
	public static const EQ:BinaryOperator = BinaryOperator.create("==");
	
	public static const GE:BinaryOperator = BinaryOperator.create(">=");
	
	public static const GT:BinaryOperator = BinaryOperator.create(">");
	
	public static const LE:BinaryOperator = BinaryOperator.create("<=");
	
	public static const LT:BinaryOperator = BinaryOperator.create("<");
	
	public static const MOD:BinaryOperator = BinaryOperator.create("%");
	
	public static const MUL:BinaryOperator = BinaryOperator.create("*");
	
	public static const NE:BinaryOperator = BinaryOperator.create("!=");
	
	public static const OR:BinaryOperator = BinaryOperator.create("||");
	
	public static const SL:BinaryOperator = BinaryOperator.create("<<");
	
	public static const SR:BinaryOperator = BinaryOperator.create(">>");
	
	public static const SRU:BinaryOperator = BinaryOperator.create(">>>");
	
	public static const SUB:BinaryOperator = BinaryOperator.create("-");
	
	private static var list:Array =
		[
			ADD,
			AND,
			BITAND,
			BITOR,
			BITXOR,
			DIV,
			EQ,
			GE,
			GT,
			LE,
			MOD,
			MUL,
			NE,
			OR,
			SL,
			SR,
			SRU,
			SUB
		];
	
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
	public static function create(name:String):BinaryOperator
	{
		for each (var element:BinaryOperator in list) 
		{
			if (element.name == name)
				return element;
		}
		
		return new BinaryOperator(name);
	}
	
	public static function find(type:String):BinaryOperator
	{
		for each (var element:BinaryOperator in list) 
		{
			if (element.name == type)
				return element;
		}
		return null;
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