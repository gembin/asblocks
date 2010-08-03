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

import org.teotigraphix.as3parser.api.ISourceCode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface ISourceFile extends INode, ISeeLinkAware
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  compilationNode
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get compilationNode():ICompilationNode;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get name():String;
	
	//----------------------------------
	//  fileName
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get fileName():String;
	
	//----------------------------------
	//  sourceCode
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get sourceCode():ISourceCode;
	
	/**
	 * @private
	 */
	function set sourceCode(value:ISourceCode):void;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	function buildAst():ICompilationNode;
}
}