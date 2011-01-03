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

package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3Parser;
import org.as3commons.asblocks.parser.impl.AS3Scanner;
import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.IASParser;
import org.as3commons.asblocks.api.IScriptNode;
import org.as3commons.asblocks.utils.ASTUtil;

/**
 * Base ASFactory test case.
 * 
 * @author Michael Schmalle
 */
public class BaseASFactoryTest
{
	protected var printer:ASTPrinter;
	
	protected var factory:ASFactory;
	
	protected var project:ASProject;
	
	protected var asparser:IASParser;
	
	protected var parser:AS3Parser;
	
	protected var scanner:AS3Scanner;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
		scanner = parser.scanner as AS3Scanner;
		printer = new ASTPrinter(new SourceCode());
		factory = new ASFactory();
		project = new ASProject(factory);
		asparser = factory.newParser();
	}
	
	[After]
	public function tearDown():void
	{
		parser = null;
		scanner = null;
		printer = null;
		factory = null;
		project = null;
		asparser = null;
	}
	
	protected function assertPrint(expected:String, 
								   expression:IScriptNode):void
	{
		printer.print(expression.node);
		var result:String = printer.flush();
		Assert.assertEquals(expected, result);
	}
	
	protected function assertCompilationUnit(message:String, 
											 input:String, 
											 expected:String):void
	{
		var result:String = ASTUtil.convert(parseCompilationUnit(input), false);
		Assert.assertEquals(message, expected, result);
	}
	
	protected function parseCompilationUnit(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		return parser.parseCompilationUnit();
	}
	
	protected function toElementString(element:Object):String
	{
		var node:IParserNode = (element is IScriptNode) 
			? IScriptNode(element).node 
			: element as IParserNode;
		return ASTUtil.convert(node, false);
	}
}
}