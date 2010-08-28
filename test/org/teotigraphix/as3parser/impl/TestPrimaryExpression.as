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

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/*
primary

true
false
null
undefined

string
number
reg-exp
xml

array
object
lambda
throw
new
encapsulated

*/

/**
 * A <code>AS3Parser.parsePrimaryExpression()</code> expression unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestPrimaryExpression
{
	private var parser:AS3Parser2;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser2();
	}
	
	[Test]
	public function testPrimary():void
	{
		assertPrimary("myObj", "myObj");
		assertPrimaryPrint("myObj", "myObj");
	}
	
	[Test]
	public function testBooleans():void
	{
		assertPrimaryPrint("true", "true");
		assertPrimaryType("true", "true", "true");
		
		assertPrimaryPrint("false", "false");
		assertPrimaryType("false", "false", "false");
	}
	
	[Test]
	public function testNull():void
	{
		assertPrimaryPrint("null", "null");
		assertPrimaryType("null", "null", "null");
	}
	
	[Test]
	public function testUndefined():void
	{
		assertPrimaryPrint("undefined", "undefined");
		assertPrimaryType("undefined", "undefined", "undefined");
	}
	
	[Test]
	public function testStrings():void
	{
		assertPrimaryPrint("\"string\"", "\"string\"");
		assertPrimaryType("string", "\"string\"", "\"string\"");
		
		assertPrimaryPrint("'string'", "'string'");
		assertPrimaryType("string", "'string'", "'string'");
	}
	
	[Test]
	public function testNumbers():void
	{
		assertNumber("1", "1");
		assertPrimaryPrint("1", "1");
		
		assertNumber("0xff", "0xff");
		assertPrimaryPrint("0xff", "0xff");
		
		assertNumber("0420", "0420");
		assertPrimaryPrint("0420", "0420");
		
		assertNumber(".42E2", ".42E2");
		assertPrimaryPrint(".42E2", ".42E2");
	}
	
	[Test]
	public function testInfinity():void
	{
		assertNumber("Infinity", "Infinity");
		assertPrimaryPrint( "Infinity", "Infinity" );
		
		assertNumber("-Infinity", "-Infinity");
		assertPrimaryPrint( "-Infinity", "-Infinity" );
	}
	
	[Test]
	public function testRegularExpression():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testXML():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testArrayLiteral():void
	{
		var input:String = "[1,2,3]";
		assertPrimaryPrint(input, "[1,2,3]");
		assertPrimary(input,
			"<array line=\"1\" column=\"1\">" +
			"<number line=\"1\" column=\"2\">1</number><number line=\"1\" " +
			"column=\"4\">2</number><number line=\"1\" column=\"6\">3</number>" +
			"</array>");
	}
	
	[Test]
	public function testObjectLiteral():void
	{
		var input:String = "{a:1,b:2}";
		assertPrimaryPrint(input, "{a:1,b:2}");
		assertPrimary( input,
			"<object line=\"1\" column=\"1\">" +
			"<prop line=\"1\" column=\"2\"><name line=\"1\" column=\"2\">a</name>" +
			"<value line=\"1\" column=\"4\"><number line=\"1\" column=\"4\">1" +
			"</number></value></prop><prop line=\"1\" column=\"6\"><name line=\"1\" " +
			"column=\"6\">b</name><value line=\"1\" column=\"8\"><number line=\"1\" " +
			"column=\"8\">2</number></value></prop></object>");
	}
	
	[Test]
	public function testFunctionLiteral():void
	{
		var input:String = "function ( a : Object ) : * { trace('test'); }";
		assertPrimaryPrint(input, "function ( a : Object ) : * { trace('test'); }");
		assertPrimary( input,
			"<lambda line=\"1\" column=\"1\"><parameter-list line=\"1\" " +
			"column=\"10\"><parameter line=\"1\" column=\"12\"><name-type-init " +
			"line=\"1\" column=\"12\"><name line=\"1\" column=\"12\">a</name>" +
			"<type line=\"1\" column=\"16\">Object</type></name-type-init>" +
			"</parameter></parameter-list><type line=\"1\" column=\"27\">*</type>" +
			"<block line=\"1\" column=\"29\"><call line=\"1\" column=\"36\">" +
			"<primary line=\"1\" column=\"31\">trace</primary><arguments line=\"1\" " +
			"column=\"36\"><string line=\"1\" column=\"37\">'test'</string>" +
			"</arguments></call></block></lambda>");
	}
	
	[Test]
	public function testThrowLiteral():void
	{
		var input:String = "throw new Error('error')";
		assertPrimaryPrint(input, "throw new Error('error')");
		assertPrimary( input,
			"<throw line=\"1\" column=\"1\"><primary line=\"1\" " +
			"column=\"7\"><new line=\"1\" column=\"7\"><call line=\"1\" " +
			"column=\"16\"><primary line=\"1\" column=\"11\">Error</primary>" +
			"<arguments line=\"1\" column=\"16\"><string line=\"1\" " +
			"column=\"17\">'error'</string></arguments></call></new>" +
			"</primary></throw>");
	}
	
	[Test]
	public function testNewLiteral():void
	{
		var input:String = "new ClassA()";
		assertPrimaryPrint(input, "new ClassA()");
		assertPrimary( input,
			"<new line=\"1\" column=\"1\"><call line=\"1\" column=\"11\">" +
			"<primary line=\"1\" column=\"5\">ClassA</primary><arguments " +
			"line=\"1\" column=\"11\"></arguments></call></new>");
	}
	
	[Test]
	public function testEncapsulatedLiteral():void
	{
		var input:String = "( world as Ball )";
		assertPrimaryPrint(input, "( world as Ball )");
		assertPrimary( input,
			"<encapsulated line=\"1\" " +
			"column=\"1\"><relation line=\"1\" column=\"3\"><primary line=\"1\" " +
			"column=\"3\">world</primary><op line=\"1\" column=\"9\">as</op>" +
			"<primary line=\"1\" column=\"12\">Ball</primary></relation>" +
			"</encapsulated>");
		
		input = "( \"world\" in myBall )";
		assertPrimaryPrint(input, "( \"world\" in myBall )");
		assertPrimary( input,
			"<encapsulated line=\"1\" column=\"1\"><relation line=\"1\" " +
			"column=\"3\"><string line=\"1\" column=\"3\">\"world\"</string>" +
			"<op line=\"1\" column=\"11\">in</op><primary line=\"1\" " +
			"column=\"14\">myBall</primary></relation></encapsulated>");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private Utility :: Methods
	//
	//--------------------------------------------------------------------------
	
	private function assertNumber(input:String, 
								  expected:String):void
	{
		parser.scanner.setLines(ASTUtil.toVector([input]));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<number line=\"1\" column=\"1\">" + 
			expected + "</number>", result);
	}
	
	private function assertPrimaryType(type:String,
									   input:String, 
									   expected:String):void
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<" + type + " line=\"1\" column=\"1\">" + 
			expected + "</" + type + ">", result);
	}
	
	private function assertPrimary(input:String, 
								   expected:String):void
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<primary line=\"1\" column=\"1\">" + 
			expected + "</primary>", result);
	}
	
	private function assertPrimaryPrint(input:String, 
										expected:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parsePrimary(input));
		Assert.assertEquals(expected, printer.flush());
	}
	
	private function parsePrimary(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken();
		return parser.parsePrimaryExpression();
	}
	
	private function createPrinter():ASTPrinter
	{
		return new ASTPrinter(new SourceCode());
	}
}
}