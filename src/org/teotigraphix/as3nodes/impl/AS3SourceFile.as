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

import org.teotigraphix.as3nodes.api.IAS3SourceFile;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.ITypeNode;
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
public class AS3SourceFile extends SourceFile implements IAS3SourceFile
{
	//--------------------------------------------------------------------------
	//
	//  IAS3SourceFile API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  packageNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3SourceFile#packageNode
	 */
	public function get packageNode():IPackageNode
	{
		if (!compilationNode)
			return null;
		return compilationNode.packageNode;
	}
	
	//----------------------------------
	//  typeNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3SourceFile#typeNode
	 */
	public function get typeNode():ITypeNode
	{
		if (!compilationNode)
			return null;
		return compilationNode.typeNode;
	}
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3SourceFile#packageName
	 */
	public function get packageName():String
	{
		if (!sourceCode)
			return null;
		return sourceCode.packageName;
	}
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3SourceFile#qualifiedName
	 */
	public function get qualifiedName():String
	{
		if (!sourceCode)
			return null;
		return sourceCode.qualifiedName;
	}
	
	//----------------------------------
	//  classPath
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3SourceFile#classPath
	 */
	public function get classPath():String
	{
		if (!sourceCode)
			return null;
		return sourceCode.classPath;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3SourceFile(parent:INode, sourceCode:ISourceCode)
	{
		super(parent, sourceCode);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function buildAst():ICompilationNode
	{
		var parser:IParser = ParserFactory.instance.as3parser;
		
		var unit:IParserNode = parser.buildAst(
			Vector.<String>(sourceCode.code.split("\n")), 
			sourceCode.filePath);
		
		compilationNode = NodeFactory.instance.createCompilation(unit, this);
		
		return compilationNode;
	}
}
}