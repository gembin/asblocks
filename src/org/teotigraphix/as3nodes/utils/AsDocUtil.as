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

package org.teotigraphix.as3nodes.utils
{

import org.teotigraphix.as3nodes.api.ICommentAware;
import org.teotigraphix.as3nodes.impl.CommentNode;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class AsDocUtil
{
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO DOCME
	 */
	public static function computeAsDoc(node:ICommentAware, 
										child:IParserNode):void
	{
		if (!child)
			return;
		
		node.comment = new CommentNode(child, node);
	}
	
	/**
	 * TODO DOCME
	 */
	public static function returnString(child:IParserNode):String
	{
		var result:String = "";
		
		if (child.isKind(ASDocNodeKind.TEXT))
		{
			return child.stringValue;
		}
		
		return result;
	}
}
}