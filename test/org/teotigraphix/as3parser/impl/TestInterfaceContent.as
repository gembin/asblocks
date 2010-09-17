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

package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * A <code>parseInterfaceContent()</code> unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestInterfaceContent
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	// FIXME testConditionalCompilation()
	//[Test]
	public function testConditionalCompilation():void
	{
		assertInterfaceContent( "with conditional compilation",
			"CONFIG::DEBUG { function output():String; } ",
			"<function line=\"2\" column=\"43\"><name line=\"2\" column=\"26\">"
			+ "output</name><parameter-list line=\"2\" column=\"33\"></parameter-list>"
			+ "<type line=\"2\" column=\"35\">String</type></function>" );
	}
	
	[Test]
	public function testImports():void
	{
		assertInterfaceContent("1",
			"import a.b.c;",
			"<import line=\"2\" column=\"1\"><type line=\"2\" column=\"8\">a.b.c" +
			"</type></import>");
		
		assertInterfaceContent("2",
			"import a.b.c import x.y.z",
			"<import line=\"2\" column=\"1\"><type line=\"2\" column=\"8\">a.b.c</type>" +
			"</import><import line=\"2\" column=\"14\"><type line=\"2\" " +
			"column=\"21\">x.y.z</type></import>");
	}
	
	[Test]
	public function testMethods():void
	{
		assertInterfaceContent("1",
			"function a()",
			"<function line=\"2\" column=\"1\">" +
			"<accessor-role line=\"2\" column=\"10\"></accessor-role>" +
			"<name line=\"2\" column=\"10\">a</name><parameter-list line=\"2\" " +
			"column=\"11\"></parameter-list></function>");
		
		assertInterfaceContent("2",
			"function set a( value : int ) : void",
			"<function line=\"2\" column=\"1\"><accessor-role line=\"2\" column=\"10\">" +
			"<set line=\"2\" column=\"10\"></set></accessor-role><name line=\"2\" " +
			"column=\"14\">a</name><parameter-list line=\"2\" column=\"15\"><parameter " +
			"line=\"2\" column=\"17\"><name-type-init line=\"2\" column=\"17\"><name " +
			"line=\"2\" column=\"17\">value</name><type line=\"2\" column=\"25\">int</type>" +
			"</name-type-init></parameter></parameter-list><type line=\"2\" column=\"33\">" +
			"void</type></function>");
		
		assertInterfaceContent("3",
			"function get a() : int",
			"<function line=\"2\" column=\"1\">" +
			"<accessor-role line=\"2\" column=\"10\"><get line=\"2\" column=\"10\"></get>" +
			"</accessor-role><name line=\"2\" column=\"14\">a</name><parameter-list " +
			"line=\"2\" column=\"15\"></parameter-list><type line=\"2\" column=\"20\">" +
			"int</type></function>");
	}
	
	private function assertInterfaceContent(message:String, 
										  input:String, 
										  expected:String):void
	{
		var lines:Array = ["{", input, "}", "__END__"];
		
		parser.scanner.setLines(Vector.<String>(lines));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parseTypeContent());
		
		Assert.assertEquals("<content line=\"1\" column=\"1\">" + 
			expected + "</content>", result);
	}
}
}