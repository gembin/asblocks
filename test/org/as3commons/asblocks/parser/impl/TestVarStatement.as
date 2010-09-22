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
 * A <code>var</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestVarStatement extends AbstractStatementTest
{
	[Test]
	public function testFullFeaturedVar():void
	{
		var input:String = "var a : int = 4";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" column=\"1\">" +
			"<var line=\"1\" column=\"1\"></var></dec-role><name-type-init " +
			"line=\"1\" column=\"5\"><name line=\"1\" column=\"5\">a</name>" +
			"<type line=\"1\" column=\"9\">int</type><init line=\"1\" " +
			"column=\"15\"><number line=\"1\" column=\"15\">4</number></init>" +
			"</name-type-init></dec-list>");
		
		input = "var a : int = 4, b : int = 2;";
		assertStatementPrint(input);
		assertStatement("2", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" " +
			"column=\"1\"><var line=\"1\" column=\"1\"></var></dec-role>" +
			"<name-type-init line=\"1\" column=\"5\"><name line=\"1\" column=\"5\">" +
			"a</name><type line=\"1\" column=\"9\">int</type><init line=\"1\" " +
			"column=\"15\"><number line=\"1\" column=\"15\">4</number></init>" +
			"</name-type-init><name-type-init line=\"1\" column=\"18\"><name " +
			"line=\"1\" column=\"18\">b</name><type line=\"1\" column=\"22\">" +
			"int</type><init line=\"1\" column=\"28\"><number line=\"1\" " +
			"column=\"28\">2</number></init></name-type-init></dec-list>");
		
		input = "var colors:Array = [0x2bc9f6, 0x0086ad];";
		assertStatementPrint(input);
		assertStatement("3", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" " +
			"column=\"1\"><var line=\"1\" column=\"1\"></var></dec-role>" +
			"<name-type-init line=\"1\" column=\"5\"><name line=\"1\" " +
			"column=\"5\">colors</name><type line=\"1\" column=\"12\">Array" +
			"</type><init line=\"1\" column=\"20\"><primary line=\"1\" " +
			"column=\"20\"><array line=\"1\" column=\"20\"><number line=\"1\" " +
			"column=\"21\">0x2bc9f6</number><number line=\"1\" column=\"31\">" +
			"0x0086ad</number></array></primary></init></name-type-init>" +
			"</dec-list>");
	}
	
	[Test]
	public function testInitializedVar():void
	{
		var input:String = "var a = 4";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" " +
			"column=\"1\"><var line=\"1\" column=\"1\"></var></dec-role>" +
			"<name-type-init line=\"1\" column=\"5\"><name line=\"1\" " +
			"column=\"5\">a</name><init line=\"1\" column=\"9\"><number " +
			"line=\"1\" column=\"9\">4</number></init></name-type-init>" +
			"</dec-list>");
	}
	
	[Test]
	public function testSimpleVar():void
	{
		var input:String = "var a";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" " +
			"column=\"1\"><var line=\"1\" column=\"1\"></var></dec-role>" +
			"<name-type-init line=\"1\" column=\"5\"><name line=\"1\" " +
			"column=\"5\">a</name></name-type-init></dec-list>");
	}
	
	[Test]
	public function testTypedVar():void
	{
		var input:String = "var a : Object";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" " +
			"column=\"1\"><var line=\"1\" column=\"1\"></var></dec-role>" +
			"<name-type-init line=\"1\" column=\"5\"><name line=\"1\" " +
			"column=\"5\">a</name><type line=\"1\" column=\"9\">Object" +
			"</type></name-type-init></dec-list>");
	}
	
	[Test]
	public function testVector():void
	{
		var input:String = "var v:Vector.<DisplayObject> = new Vector.<Sprite>();";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" " +
			"column=\"1\"><var line=\"1\" column=\"1\"></var></dec-role>" +
			"<name-type-init line=\"1\" column=\"5\"><name line=\"1\" " +
			"column=\"5\">v</name><vector line=\"1\" column=\"7\"><type " +
			"line=\"1\" column=\"15\">DisplayObject</type></vector><init " +
			"line=\"1\" column=\"32\"><primary line=\"1\" column=\"32\">" +
			"<new line=\"1\" column=\"32\"><primary line=\"1\" column=\"36\">" +
			"Vector</primary><arguments line=\"1\" column=\"51\"></arguments>" +
			"</new></primary></init></name-type-init></dec-list>");
		
		input = "var v:Vector.< Vector.< String > >";
		assertStatementPrint(input);
		assertStatement("3", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" " +
			"column=\"1\"><var line=\"1\" column=\"1\"></var></dec-role>" +
			"<name-type-init line=\"1\" column=\"5\"><name line=\"1\" " +
			"column=\"5\">v</name><vector line=\"1\" column=\"7\"><vector " +
			"line=\"1\" column=\"16\"><type line=\"1\" column=\"25\">String" +
			"</type></vector></vector></name-type-init></dec-list>");
		
		input = "var v:Vector.<Vector.<String>>;";
		assertStatementPrint(input);
		assertStatement("3", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" column=\"1\">" +
			"<var line=\"1\" column=\"1\"></var></dec-role><name-type-init " +
			"line=\"1\" column=\"5\"><name line=\"1\" column=\"5\">v</name>" +
			"<vector line=\"1\" column=\"7\"><vector line=\"1\" column=\"15\">" +
			"<type line=\"1\" column=\"23\">String</type></vector></vector>" +
			"</name-type-init></dec-list>");
		
		input = "var HT:Vector.<BitString> = new Vector.<BitString>(251, true);";
		assertStatementPrint(input);
		assertStatement("3", input,
			"<dec-list line=\"1\" column=\"1\"><dec-role line=\"1\" column=\"1\">" +
			"<var line=\"1\" column=\"1\"></var></dec-role><name-type-init " +
			"line=\"1\" column=\"5\"><name line=\"1\" column=\"5\">HT</name>" +
			"<vector line=\"1\" column=\"8\"><type line=\"1\" column=\"16\">" +
			"BitString</type></vector><init line=\"1\" column=\"29\"><primary " +
			"line=\"1\" column=\"29\"><new line=\"1\" column=\"29\"><primary " +
			"line=\"1\" column=\"33\">Vector</primary><arguments line=\"1\" " +
			"column=\"51\"><number line=\"1\" column=\"52\">251</number><true " +
			"line=\"1\" column=\"57\">true</true></arguments></new></primary>" +
			"</init></name-type-init></dec-list>");
	}
}
}