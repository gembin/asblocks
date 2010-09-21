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
 * A member, method or field.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IMember 
	extends IScriptNode, IDocCommentAware, IMetaDataAware
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  visibility
	//----------------------------------
	
	/**
	 * The <code>Visibility</code> of the member.
	 * 
	 * <p>This can be one of the <code>Visibility</code> enumerations or a
	 * custom namespace <code>Visibility</code>.</p>
	 */
	function get visibility():Visibility;
	
	/**
	 * @private
	 */
	function set visibility(value:Visibility):void;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The name of the member.
	 * 
	 * <p><strong>Note:</strong> This name cannot contain a period.</p>
	 */
	function get name():String;
	
	/**
	 * @private
	 */
	function set name(value:String):void;
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * The type of the member.
	 * 
	 * <p><strong>Note:</strong> This name can contain a period, if a period
	 * is present, the type will be considered a qualified name not a simple
	 * name.</p>
	 */
	function get type():String;
	
	/**
	 * @private
	 */
	function set type(value:String):void;
	
	//----------------------------------
	//  isStatic
	//----------------------------------
	
	/**
	 * Whether the member constains the <code>static</code> keyword.
	 * 
	 * <p>Setting this property to <code>true</code> will add the <code>static</code>
	 * keyword, setting the property to <code>false</code> will remove the 
	 * <code>static</code> keyword.</p>
	 */
	function get isStatic():Boolean;
	
	/**
	 * @private
	 */
	function set isStatic(value:Boolean):void;
}
}