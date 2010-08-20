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
 * An abstract source file containing source code and a file path location.
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
	 * The file's root compilation node.
	 */
	function get compilationNode():ICompilationNode;
	
	//----------------------------------
	//  extension
	//----------------------------------
	
	/**
	 * The file name extension such as; <strong>as</strong> or <strong>mxml</strong>.
	 */
	function get extension():String;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The file name; <code>MyFile</code>.
	 */
	function get name():String;
	
	//----------------------------------
	//  fileName
	//----------------------------------
	
	/**
	 * The file path; <code>/home/user/src/my/domain/MyFile.as</code>.
	 */
	function get filePath():String;
	
	//----------------------------------
	//  classPath
	//----------------------------------
	
	/**
	 * The file base path; <code>/home/user/src</code>.
	 */
	function get classPath():String;
	
	//----------------------------------
	//  sourceCode
	//----------------------------------
	
	/**
	 * The file's source code.
	 */
	function get sourceCode():ISourceCode;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Builds the file's AST based on the subclass implementation.
	 * 
	 * <p>When the <code>extension</code> is <strong>.as</strong>, the AST
	 * will be build with the <code>AS3Parser</code>, when the <code>extension</code> 
	 * is <strong>.mxml</strong> the AST will be build with the 
	 * <code>MXMLParser</code>.</p>
	 * 
	 * @param Returns a <code>ICompilationNode</code> wrapping the file's AST
	 * root <strong>compilation-unit</strong> parser node.
	 */
	function buildAst():ICompilationNode;
}
}