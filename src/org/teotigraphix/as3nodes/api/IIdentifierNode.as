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

package org.teotigraphix.as3nodes.api
{

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IIdentifierNode extends INode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  localName
	//----------------------------------
	
	/**
	 * The short name for the node; given <code>my.domain.Test</code>, 
	 * returns <code>Test</code>.
	 * 
	 * <p>When a fragment exists; given <code>my.package.Test#style:myStyle</code>
	 * returns <code>myStyle</code>.</p>
	 */
	function get localName():String;
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * The package name for the node; given <code>my.package.Test</code>, 
	 * returns <code>my.package</code>.
	 * 
	 * <p>When a fragment exists; given <code>my.package.Test#style:myStyle</code>
	 * returns <code>my.package</code>.</p>
	 */
	function get packageName():String;
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * The qualified name for the node; given <code>my.package.File</code>, 
	 * returns <code>my.package.File</code>.
	 * 
	 * <p>When a fragment exists; given <code>my.package.Test#style:myStyle</code>
	 * returns <code>my.package.File#fragementType:fragementName</code>.</p>
	 */
	function get qualifiedName():String;
	
	/**
	 * @private
	 */
	function set qualifiedName(value:String):void;
	
	//----------------------------------
	//  parentQualifiedName
	//----------------------------------
	
	/**
	 * The qualified name for the node; given <code>my.package.File</code>, 
	 * returns <code>my.package</code>.
	 * 
	 * <p>When a fragment exists; given <code>my.package.Test#style:myStyle</code>
	 * returns <code>my.package.File</code>.</p>
	 */
	function get parentQualifiedName():String;
	
	//----------------------------------
	//  fragmentName
	//----------------------------------
	
	/**
	 * The qualified name for the node; given <code>my.package.Test#style:myStyle</code>, 
	 * returns <code>myStyle</code>.
	 */
	function get fragmentName():String;
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * The qualified name for the node; given <code>my.package.Test#style:myStyle</code>, 
	 * returns <code>style</code>.
	 */
	function get fragmentType():String;
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * Returns whether the <code>qualifiedName</code> contains a 
	 * <code>packageName</code>.
	 */
	function get isQualified():Boolean;
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * Returns whether the <code>fragmentName</code> is not <code>null</code>.
	 */
	function get hasFragment():Boolean;
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * Returns whether the <code>fragmentType</code> is not <code>null</code>.
	 */
	function get hasFragmentType():Boolean;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns whether another <code>uid</code> is condidered identical.
	 * 
	 * Param object The comparable <code>IIDentifierNode</code>.
	 */
	function equals(object:Object):Boolean;
}
}