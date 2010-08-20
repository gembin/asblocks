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
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3parser.api.IParser;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.ISourceCode;

/**
 * Concrete implementation of the <code>IAS3SourceFile</code> api.
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
	 * @private
	 */
	private var _packageName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3SourceFile#packageName
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
	 * @copy org.teotigraphix.as3nodes.api.IAS3SourceFile#qualifiedName
	 */
	public function get qualifiedName():String
	{
		return _qualifiedName;
	}
	
	/**
	 * @private
	 */	
	public function set qualifiedName(value:String):void
	{
		_qualifiedName = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3SourceFile(sourceCode:ISourceCode, 
								  classPath:String = null)
	{
		super(sourceCode, classPath);
		
		computeParts();
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
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Computes the file pieces.
	 */
	override protected function computeParts():void
	{
		super.computeParts();
		
		var calcName:String;
		var calcPackageName:String;
		var calcQualifiedName:String;
		
		var head:String = filePath;
		
		if (filePath && classPath)
		{
			head = filePath.replace(classPath, "");
		}
		
		if (filePath)
		{
			var split:Array = head.split(".");
			
			extension = split.pop();
			
			// /my/domain/Test
			calcQualifiedName = split.pop();
			// remove first slash
			if (calcQualifiedName.indexOf("/") == 0)
				calcQualifiedName = calcQualifiedName.substring(1, calcQualifiedName.length);
			
			if (calcQualifiedName)
			{
				calcPackageName = ""; // toplevel
				// my.domain.Test
				calcQualifiedName = calcQualifiedName.split("/").join(".");
				
				var dot:int = calcQualifiedName.lastIndexOf(".");
				if (dot != -1)
				{
					calcPackageName = calcQualifiedName.substring(0, dot);
				}
			}
			
			var last:int = calcQualifiedName.lastIndexOf(".");
			if (last != -1)
			{
				calcName = calcQualifiedName.substring(last + 1, calcQualifiedName.length);
			}
			else
			{
				calcName = calcQualifiedName;
			}
		}
		
		name = calcName;
		packageName = calcPackageName;
		qualifiedName = calcQualifiedName;
	}
}
}