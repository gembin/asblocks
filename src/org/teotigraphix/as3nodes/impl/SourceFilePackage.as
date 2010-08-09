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

import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ISourceFilePackage;
import org.teotigraphix.as3parser.utils.FileUtil;

/**
 * The <strong>SourceFileCollection</strong> class holds a list of
 * <code>ISourceFile</code> contained in it's source path.
 * 
 * <p>The <code>classPath</code> is the base directory of the package not 
 * including the package's actual structure IE <code>my.domain.core</code>.</p>
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class SourceFilePackage extends NodeBase implements ISourceFilePackage
{
	//--------------------------------------------------------------------------
	//
	//  INameAware API :: Properties
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
	 * @copy org.teotigraphix.as3nodes.api.INameAware#name
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
	//  ISourceFilePackage API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  classPath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _classPath:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFilePackage#classPath
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
		if(value == null)
			return;
		
		_classPath = FileUtil.normalizePath(value);
	}
	
	//----------------------------------
	//  directoryPath
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFilePackage#directoryPath
	 */
	public function get directoryPath():String
	{
		if (!name)
			return classPath;
		
		if (name.indexOf(".") != -1)
		{
			return classPath + "/" + name.replace(/\./g, "/");
		}
		
		return classPath;
	}
	
	//----------------------------------
	//  sourceFiles
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _sourceFiles:Vector.<ISourceFile> = new Vector.<ISourceFile>();
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFilePackage#sourceFiles
	 */
	public function get sourceFiles():Vector.<ISourceFile>
	{
		return _sourceFiles;
	}
	
	/**
	 * @private
	 */	
	public function set sourceFiles(value:Vector.<ISourceFile>):void
	{
		_sourceFiles = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function SourceFilePackage(classPath:String, name:String)
	{
		super(null, null);
		
		this.classPath = FileUtil.normalizePath(classPath);
		this.name = name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  ISourceFilePackage API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceFilePackage#addSourceFile()
	 */
	public function addSourceFile(sourceFile:ISourceFile):void
	{
		sourceFiles.push(sourceFile);
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
		return directoryPath;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function toString():String
	{
		return directoryPath;
	}
}
}