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

import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3parser.api.IParser;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.ISourceCode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class SourceFile extends NodeBase implements ISourceFile
{
	//--------------------------------------------------------------------------
	//
	//  ISourceFile API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  compilationNode
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _compilationNode:ICompilationNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFile#compilationNode
	 */
	public function get compilationNode():ICompilationNode
	{
		return _compilationNode;
	}
	
	/**
	 * @private
	 */	
	public function set compilationNode(value:ICompilationNode):void
	{
		_compilationNode = value;
	}
	
	//----------------------------------
	//  fileName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFile#fileName
	 */
	public function get fileName():String
	{
		if (!_sourceCode)
			return null;
		return _sourceCode.fileName;
	}
	
	//----------------------------------
	//  sourceCode
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _sourceCode:ISourceCode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFile#code
	 */
	public function get sourceCode():ISourceCode
	{
		return _sourceCode;
	}
	
	/**
	 * @private
	 */	
	public function set sourceCode(value:ISourceCode):void
	{
		_sourceCode = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function SourceFile(parent:INode, sourceCode:ISourceCode)
	{
		super(null, parent);
		
		_sourceCode = sourceCode;
	}
	
	//--------------------------------------------------------------------------
	//
	//  ISourceFile API :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFile#buildAst()
	 */
	public function buildAst():ICompilationNode
	{
		var parser:IParser = ParserFactory.instance.as3parser;
		
		var unit:IParserNode = parser.buildAst(
			Vector.<String>(sourceCode.code.split("\n")), 
			sourceCode.fileName);
		
		compilationNode = NodeFactory.instance.createCompilation(unit, this);
		
		return compilationNode;
	}
}
}