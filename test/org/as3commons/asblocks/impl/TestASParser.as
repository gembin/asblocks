////////////////////////////////////////////////////////////////////////////////
// Copyright 2011 Michael Schmalle - Teoti Graphix, LLC
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

import flash.events.Event;

import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IParserInfo;
import org.as3commons.asblocks.api.Visibility;
import org.as3commons.asblocks.parser.api.ISourceCode;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.flexunit.asserts.fail;
import org.flexunit.async.Async;

/**
 * Tests the IASParser impl.
 * 
 * @author Michael Schmalle
 */
public class TestASParser extends BaseASFactoryTest
{
	private var code:String = "package foo.bar { public class Baz { } }";
	
	private var sourceCode:ISourceCode;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		sourceCode = factory.newSourceCode(code, "internal");
	}
	
	[After]
	override public function tearDown():void
	{
		super.tearDown();
		
		sourceCode = null;
	}
	
	[Test(async)]
	public function test_parseAsync():void
	{
		var info:IParserInfo = asparser.parseAsync(sourceCode);
		info.addEventListener(Event.COMPLETE, Async.asyncHandler(this, parseCompleteHandler, 500));
		info.parse();
	}
	
	private function parseCompleteHandler(event:Event, data:Object):void
	{
		var info:IParserInfo = event.target as IParserInfo;
		assertNotNull(info.unit);
		assertTrue(info.unit.typeNode.visibility.equals(Visibility.PUBLIC));
		assertEquals("Baz", info.unit.typeName);
		assertEquals("foo.bar", info.unit.packageName);
	}
	
	[Test]
	public function test_parse():void
	{
		var unit:ICompilationUnit = asparser.parse(sourceCode);
		
		assertNotNull(unit);
		assertTrue(unit.typeNode.visibility.equals(Visibility.PUBLIC));
		assertEquals("Baz", unit.typeName);
		assertEquals("foo.bar", unit.packageName);
	}
	
	[Test]
	public function test_parserThrowError():void
	{
		sourceCode.code = "package { Foo { } }";
		
		var unit:ICompilationUnit;
		try {
			unit = asparser.parse(sourceCode, false);
		}
		catch (e:ASBlocksSyntaxError)
		{
			assertNull(unit);
			return;
		}
		
		fail("parser should have thrown ASBlocksSyntaxError");
	}
	
	[Test]
	public function test_parseString():void
	{
		var unit:ICompilationUnit = asparser.parseString(code);
		
		assertNotNull(unit);
		assertTrue(unit.typeNode.visibility.equals(Visibility.PUBLIC));
		assertEquals("Baz", unit.typeName);
		assertEquals("foo.bar", unit.packageName);
	}
}
}