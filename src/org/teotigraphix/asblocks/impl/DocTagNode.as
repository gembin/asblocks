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

package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.api.IDocTag;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The <code>IDocTag</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class DocTagNode extends ScriptNode 
	implements IDocTag
{
	//--------------------------------------------------------------------------
	//
	//  IDocTag API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDocTag#name
	 */
	public function get name():String
	{
		return ASTUtil.nameText(node.getKind(ASDocNodeKind.NAME));
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
	}
	
	//----------------------------------
	//  body
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDocTag#body
	 */
	public function get body():String
	{
		return ASTUtil.nameText(node.getKind(ASDocNodeKind.BODY));
	}
	
	/**
	 * @private
	 */	
	public function set body(value:String):void
	{
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function DocTagNode(node:IParserNode)
	{
		super(node);
	}
}
}