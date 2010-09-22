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

package org.as3commons.asblocks.parser.impl
{

/**
 * A <code>const</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestConstStatement extends AbstractStatementTest
{
	[Test]
	public function testFullFeaturedConst():void
	{
		var input:String = "const a : int = 4";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" column=\"1\">" +
			"<const line=\"1\" column=\"1\"></const></dec-role><name-type-init " +
			"line=\"1\" column=\"7\"><name line=\"1\" column=\"7\">a</name>" +
			"<type line=\"1\" column=\"11\">int</type><init line=\"1\" " +
			"column=\"17\"><number line=\"1\" column=\"17\">4</number>" +
			"</init></name-type-init></dec-list>");
	}
	
	[Test]
	public function testFullFeaturedConstString():void
	{
		var input:String = "const a : String = \"Hello World\";";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" column=\"1\">" +
			"<const line=\"1\" column=\"1\"></const></dec-role><name-type-init " +
			"line=\"1\" column=\"7\"><name line=\"1\" column=\"7\">a</name><type " +
			"line=\"1\" column=\"11\">String</type><init line=\"1\" column=\"20\">" +
			"<string line=\"1\" column=\"20\">\"Hello World\"</string></init>" +
			"</name-type-init></dec-list>");
	}
	
	[Test]
	public function testInitializedConst():void
	{
		var input:String = "const a = 4";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" column=\"1\">" +
			"<const line=\"1\" column=\"1\"></const></dec-role><name-type-init " +
			"line=\"1\" column=\"7\"><name line=\"1\" column=\"7\">a</name><init " +
			"line=\"1\" column=\"11\"><number line=\"1\" column=\"11\">4</number>" +
			"</init></name-type-init></dec-list>" );
	}
	
	[Test]
	public function testSimpleConst():void
	{
		var input:String = "const a";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" column=\"1\">" +
			"<const line=\"1\" column=\"1\"></const></dec-role><name-type-init " +
			"line=\"1\" column=\"7\"><name line=\"1\" column=\"7\">a</name>" +
			"</name-type-init></dec-list>" );
	}
	
	[Test]
	public function testTypedConst():void
	{
		var input:String = "const a : Object";
		assertStatementPrint(input);
		assertStatement( "1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" column=\"1\">" +
			"<const line=\"1\" column=\"1\"></const></dec-role><name-type-init " +
			"line=\"1\" column=\"7\"><name line=\"1\" column=\"7\">a</name><type " +
			"line=\"1\" column=\"11\">Object</type></name-type-init></dec-list>" );
	}
	
	[Test]
	public function testFullyTypedConst():void
	{
		var input:String = "const a : flash.util.System";
		assertStatementPrint(input);
		assertStatement( "1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" column=\"1\">" +
			"<const line=\"1\" column=\"1\"></const></dec-role><name-type-init " +
			"line=\"1\" column=\"7\"><name line=\"1\" column=\"7\">a</name>" +
			"<type line=\"1\" column=\"11\">flash.util.System</type>" +
			"</name-type-init></dec-list>" );
	}
}
}