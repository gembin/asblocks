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
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3parser.api.ISourceCode;

/**
 * Concrete implementation of the <code>ISourceFile</code> api.
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
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFile#name
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
	
	//----------------------------------
	//  extension
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _extension:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFile#extension
	 */
	public function get extension():String
	{
		return _extension;
	}
	
	/**
	 * @private
	 */
	public function set extension(value:String):void
	{
		_extension = value;
	}
	
	//----------------------------------
	//  filePath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _filePath:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFile#filePath
	 */
	public function get filePath():String
	{
		return _filePath;
	}
	
	/**
	 * @private
	 */
	public function set filePath(value:String):void
	{
		_filePath = value;
	}
	
	//----------------------------------
	//  classPath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _classPath:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFile#classPath
	 */
	public function get classPath():String
	{
		return _classPath;
	}
	
	/**
	 * @private
	 */
	public function set classPath(value:String):void
	{
		_classPath = value;
	}
	
	//----------------------------------
	//  sourceCode
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _sourceCode:ISourceCode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFile#sourceCode
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
	 * 
	 * @param sourceCode A <code>ISourceCode</code> instance holding the String
	 * data that will be parsed.
	 * @param classPath A <code>String</code> locating the root of the source file.
	 */
	public function SourceFile(sourceCode:ISourceCode, classPath:String)
	{
		super(null, parent);
		
		this.sourceCode = sourceCode;
		
		// /home/user/src/my/domain/Test.as
		this.filePath = cleanPath(sourceCode.filePath);
		// /home/user/src
		this.classPath = cleanPath(classPath);
		
		computeParts();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Computes the file pieces.
	 */
	protected function computeParts():void
	{
	}
	
	/**
	 * Cleans a path by default, removes the \ and replaces them with /.
	 * 
	 * @param path A String to clean.
	 * @return The cleaned String.
	 */
	protected function cleanPath(path:String):String
	{
		if (path == null)
			return null;
		
		return path.replace(/\\/g, "/");
	}
	
	//--------------------------------------------------------------------------
	//
	//  ISeeLinkAware API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISeeLinkAware#toLink()
	 */
	public function toLink():String
	{
		return filePath;
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
		return null;
	}
}
}