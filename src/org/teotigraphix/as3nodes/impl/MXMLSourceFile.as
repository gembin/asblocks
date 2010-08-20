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
import org.teotigraphix.as3nodes.api.IMXMLSourceFile;
import org.teotigraphix.as3parser.api.IParser;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.ISourceCode;

/**
 * Concrete implementation of the <code>IMXMLSourceFile</code> api.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MXMLSourceFile extends AS3SourceFile implements IMXMLSourceFile
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MXMLSourceFile(sourceCode:ISourceCode, 
								   classPath:String = null)
	{
		super(sourceCode, classPath);
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
		var parser:IParser = ParserFactory.instance.mxmlparser;
		
		var unit:IParserNode = parser.buildAst(
			Vector.<String>(sourceCode.code.split("\n")), 
			filePath);
		
		compilationNode = NodeFactory.instance.createCompilation(unit, this);
		
		return compilationNode;
	}
}
}