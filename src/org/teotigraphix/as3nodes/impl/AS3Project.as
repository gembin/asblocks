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

import org.teotigraphix.as3nodes.api.IAS3Project;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IFunctionNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.Node;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.FileUtil;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class AS3Project implements IAS3Project
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * doc
	 */
	public function get name():String
	{
		return _name;
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
		_name = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IAS3Project API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  output
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _output:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#output
	 */
	public function get output():String
	{
		return _output;
	}
	
	/**
	 * @private
	 */
	public function set output(value:String):void
	{
		_output = FileUtil.normalizePath(value);
	}
	
	//----------------------------------
	//  classPaths
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#output
	 */
	public function get classPaths():Vector.<String>
	{
		return null;
	}
	
	//----------------------------------
	//  sourceFiles
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#output
	 */
	public function get sourceFiles():Vector.<ISourceFile>
	{
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3Project(output:String)
	{
		super();
		
		this.output = output;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#addClassPath()
	 */
	public function addClassPath(classPath:String):void
	{
		
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#removeClassPath()
	 */
	public function removeClassPath(classPath:String):void
	{
		
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#addSourceFile()
	 */
	public function addSourceFile(file:ISourceFile):void
	{
		
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#removeSourceFile()
	 */
	public function removeSourceFile(file:ISourceFile):void
	{
		
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#write()
	 */
	public function write():void
	{
		
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#newClass()
	 */
	public function newClass(qualifiedName:String):ISourceFile
	{
		// what has to happen here?
		
		var uid:IIdentifierNode = IdentifierNode.createName(qualifiedName);
		
		var source:String = "";
		var name:String = uid.localName + ".as";
		var classPath:String = output + "/src";
		
		var code:SourceCode = new SourceCode(source, name);
		// An .as SourceFile has to be returned
		var file:AS3SourceFile = new AS3SourceFile(code, classPath);
		
		// The CompilationNode in the file has to be created
		var compilationUnitNode:IParserNode = ASTNodeUtil.createEmptyClass(uid);
		
		// The PackageNode in the CompilationNode has to be created
		// The TypeNode in the PackageNode has to be created
		var compilationNode:ICompilationNode = new CompilationNode(compilationUnitNode, file);
		AS3SourceFile(file).compilationNode = compilationNode;
		
		// add public modifier
		compilationNode.typeNode.addModifier(Modifier.PUBLIC);
		
		return file;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#newInterface()
	 */
	public function newInterface(qualifiedName:String):ISourceFile
	{
		var uid:IIdentifierNode = IdentifierNode.createName(qualifiedName);
		
		var source:String = "";
		var name:String = uid.localName + ".as";
		var classPath:String = output + "/src";
		
		var code:SourceCode = new SourceCode(source, name);
		// An .as SourceFile has to be returned
		var file:AS3SourceFile = new AS3SourceFile(code, classPath);
		
		// The CompilationNode in the file has to be created
		var compilationUnitNode:IParserNode = ASTNodeUtil.createEmptyInterface(uid);
		
		// The PackageNode in the CompilationNode has to be created
		// The TypeNode in the PackageNode has to be created
		var compilationNode:ICompilationNode = new CompilationNode(compilationUnitNode, file);
		AS3SourceFile(file).compilationNode = compilationNode;
		
		// add empty comment
		compilationNode.typeNode.setComment(NodeFactory.instance.
			createComment(null, compilationNode.typeNode));
		
		// add public modifier
		compilationNode.typeNode.addModifier(Modifier.PUBLIC);
		
		return file;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Project#newInterface()
	 */
	public function newFunction(qualifiedName:String):ISourceFile
	{
		var uid:IIdentifierNode = IdentifierNode.createName(qualifiedName);
		
		var source:String = "";
		var name:String = uid.localName + ".as";
		var classPath:String = output + "/src";
		
		var code:SourceCode = new SourceCode(source, name);
		// An .as SourceFile has to be returned
		var file:AS3SourceFile = new AS3SourceFile(code, classPath);
		
		// The CompilationNode in the file has to be created
		var compilationUnitNode:IParserNode = ASTNodeUtil.createEmptyFunction(uid);
		
		// The PackageNode in the CompilationNode has to be created
		// The TypeNode in the PackageNode has to be created
		var compilationNode:ICompilationNode = new CompilationNode(compilationUnitNode, file);
		AS3SourceFile(file).compilationNode = compilationNode;
		
		// add empty comment
		compilationNode.typeNode.setComment(NodeFactory.instance.
			createComment(null, compilationNode.typeNode));
		
		// add public modifier
		compilationNode.typeNode.addModifier(Modifier.PUBLIC);
		// add default void type
		IFunctionNode(compilationNode.typeNode).type = IdentifierNode.createType("void");
		
		return file;
	}
}
}