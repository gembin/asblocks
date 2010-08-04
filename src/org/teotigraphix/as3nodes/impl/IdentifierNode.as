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

package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.Node;

/**
 * An identifier name node.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class IdentifierNode extends NodeBase implements IIdentifierNode
{
	//--------------------------------------------------------------------------
	//
	//  INameAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  localName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _localName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#name
	 */
	public function get localName():String
	{
		return _localName;
	}
	
	/**
	 * @private
	 */	
	public function set localName(value:String):void
	{
		_localName = value;
	}
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _packageName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#packageName
	 */
	public function get packageName():String
	{
		return _packageName;
	}
	
	/**
	 * @private
	 */	
	public function set packageName(value:String):void
	{
		_packageName = value;
	}
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _qualifiedName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#qualifiedName
	 */
	public function get qualifiedName():String
	{
		if (isQualified)
		{
			if (hasFragment)
			{
				if (hasFragmentType)
				{
					return _packageName + "." + _localName + "#" + _fragmentType + ":"
						+ _fragmentName;
				}
				else
				{
					return _packageName + "." + _localName + "#" + _fragmentName;
				}
			}
			else
			{
				if (_packageName == "")
				{
					return _localName;
				}
				else
				{
					return _packageName + "." + _localName;
				}
			}
		}
		else
		{
			if (hasFragment)
			{
				if (hasFragmentType)
				{
					return _localName + "#" + _fragmentType + ":" + _fragmentName;
				}
				else
				{
					return _localName + "#" + _fragmentName;
				}
			}
			else
			{
				return _localName;
			}
		}
	}
	
	/**
	 * @private
	 */	
	public function set qualifiedName(value:String):void
	{
		var string:String = value;
		
		var pos:int = string.lastIndexOf('.');
		if (pos != -1)
		{
			_packageName = string.substring(0, pos);
			parse(string.substring(pos + 1));
		}
		else
		{
			_packageName = null;
			parse(string);
		}
	}
	
	//----------------------------------
	//  parentQualifiedName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#parentQualifiedName
	 */
	public function get parentQualifiedName():String
	{
		if (!isQualified)
			return _localName;
		
		if (!hasFragment)
			return _packageName;
		
		return _packageName + "." + _localName;
	}
	
	//----------------------------------
	//  fragmentName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _fragmentName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#fragmentName
	 */
	public function get fragmentName():String
	{
		return _fragmentName;
	}
	
	/**
	 * @private
	 */	
	public function set fragmentName(value:String):void
	{
		_fragmentName = value;
	}
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _fragmentType:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#fragmentType
	 */
	public function get fragmentType():String
	{
		return _fragmentType;
	}
	
	/**
	 * @private
	 */	
	public function set fragmentType(value:String):void
	{
		_fragmentType = value;
	}
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#isQualified
	 */
	public function get isQualified():Boolean
	{
		return _packageName != null;
	}
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#hasFragment
	 */
	public function get hasFragment():Boolean
	{
		return _fragmentName != null;
	}
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#hasFragmentType
	 */
	public function get hasFragmentType():Boolean
	{
		return _fragmentType != null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function IdentifierNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
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
		return _qualifiedName;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function compute():void
	{
		qualifiedName = node.stringValue;
	}
	
	private function parse(data:String):void
	{
		var pos:int = data.indexOf('#');
		if (pos != -1)
		{
			// next :: MyClass#myVariable
			_localName = data.substring(0, pos);
			_fragmentName = data.substring(pos + 1);
			
			pos = _fragmentName.indexOf(':');
			if (pos != -1)
			{
				_fragmentType = _fragmentName.substring(0, pos);
				_fragmentName = _fragmentName.substring(pos + 1);
			}
		}
		else
		{
			_localName = data;
		}
	}
	
	public static function createName(qualifiedName:String, 
									  parent:INode = null):IIdentifierNode
	{
		var node:IParserNode = Node.create(AS3NodeKind.NAME, -1, -1, qualifiedName);
		return new IdentifierNode(node, parent);
	}
	
	public static function createType(qualifiedName:String, 
									  parent:INode = null):IIdentifierNode
	{
		var node:IParserNode = Node.create(AS3NodeKind.TYPE, -1, -1, qualifiedName);
		return new IdentifierNode(node, parent);
	}
}
}