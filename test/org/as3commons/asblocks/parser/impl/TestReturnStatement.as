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
 * A <code>return</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestReturnStatement extends AbstractStatementTest
{
	[Test]
	public function testEmptyReturn():void
	{
		var input:String = "return";
		//assertStatementPrint(input);
		assertStatement("1", input,
			"<return line=\"1\" column=\"1\"><primary line=\"2\" " +
			"column=\"0\">__END__</primary></return>");
		
		input = "return;";
		//assertStatementPrint(input);
		assertStatement("2", input,
			"<return line=\"1\" column=\"1\"></return>");
	}
	
	[Test]
	public function testReturnArrayLiteral():void
	{
		var input:String = "return []";
		assertStatementPrint(input);
		assertStatement( "1",
			"return []",
			"<return line=\"1\" column=\"1\"><primary line=\"1\" column=\"8\">" +
			"<array line=\"1\" column=\"8\"></array></primary></return>" );
		
		input = "return [];";
		assertStatementPrint(input);
		assertStatement( "2",
			"return [];",
			"<return line=\"1\" column=\"1\"><primary line=\"1\" column=\"8\">" +
			"<array line=\"1\" column=\"8\"></array></primary></return>" );
	}
	
	[Test]
	public function testLabelBlock():void
	{
		var input:String = "foo : { }";
		assertStatementPrint(input);
		assertStatement("1",
			input,
			"<label line=\"1\" column=\"5\"><expr-stmnt line=\"1\" column=\"1\">" +
			"<primary line=\"1\" column=\"1\">foo</primary></expr-stmnt><block " +
			"line=\"1\" column=\"7\"></block></label>");
		
		input = "foo : { break foo; }";
		assertStatementPrint(input);
		assertStatement("2",
			input,
			"<label line=\"1\" column=\"5\"><expr-stmnt line=\"1\" column=\"1\">" +
			"<primary line=\"1\" column=\"1\">foo</primary></expr-stmnt><block " +
			"line=\"1\" column=\"7\"><break line=\"1\" column=\"9\"><primary " +
			"line=\"1\" column=\"15\">foo</primary></break></block></label>");
	}
	
	[Test]
	public function testBreak():void
	{
		var input:String = "break;";
		assertStatementPrint(input);
		assertStatement("1",
			input,
			"<break line=\"1\" column=\"1\"></break>");
		
		input = "break myLoop;";
		assertStatementPrint(input);
		assertStatement("2",
			input,
			"<break line=\"1\" column=\"1\"><primary line=\"1\" column=\"7\">myLoop" +
			"</primary></break>");
	}
	
	[Test]
	public function testContinue():void
	{
		var input:String = "continue;";
		assertStatementPrint(input);
		assertStatement("1",
			input,
			"<continue line=\"1\" column=\"1\"></continue>");
		
		input = "continue myLoop;";
		assertStatementPrint(input);
		assertStatement("2",
			input,
			"<continue line=\"1\" column=\"1\"><primary line=\"1\" column=\"10\">myLoop" +
			"</primary></continue>");
	}
	
	[Test]
	public function testThis():void
	{
		var input:String = "this;";
		assertStatementPrint(input);
		assertStatement("1",
			input,
			"<this line=\"1\" column=\"1\"></this>");
		
		input = "this.property = 42;";
		assertStatementPrint(input);
		assertStatement("2",
			input,
			"<this line=\"1\" column=\"1\"><assignment line=\"1\" column=\"6\">" +
			"<primary line=\"1\" column=\"6\">property</primary><assign line=\"1\" " +
			"column=\"15\">=</assign><number line=\"1\" column=\"17\">42</number>" +
			"</assignment></this>");
		
		input = "this.method(arg0, arg1);";
		assertStatementPrint(input);
		assertStatement("2",
			input,
			"<this line=\"1\" column=\"1\"><call line=\"1\" column=\"12\">" +
			"<primary line=\"1\" column=\"6\">method</primary><arguments line=\"1\" " +
			"column=\"12\"><primary line=\"1\" column=\"13\">arg0</primary><primary " +
			"line=\"1\" column=\"19\">arg1</primary></arguments></call></this>");
	}
	
	[Test]
	public function testSuper():void
	{
		var input:String = "super(arg0, arg1);";
		assertStatementPrint(input);
		assertStatement("1",
			input,
			"<super line=\"1\" column=\"1\"><arguments line=\"1\" column=\"6\"><primary " +
			"line=\"1\" column=\"7\">arg0</primary><primary line=\"1\" column=\"13\">" +
			"arg1</primary></arguments></super>");
	}
	
	[Test]
	public function testSuperInvocation():void
	{
		var input:String = "super.method(arg0, arg1);";
		assertStatementPrint(input);
		assertStatement("1",
			input,
			"<super line=\"1\" column=\"1\"><call line=\"1\" column=\"13\"><primary " +
			"line=\"1\" column=\"7\">method</primary><arguments line=\"1\" " +
			"column=\"13\"><primary line=\"1\" column=\"14\">arg0</primary><primary " +
			"line=\"1\" column=\"20\">arg1</primary></arguments></call></super>");
		
		input = "super.property = 42;";
		assertStatementPrint(input);
		assertStatement("2",
			input,
			"<super line=\"1\" column=\"1\"><assignment line=\"1\" column=\"7\">" +
			"<primary line=\"1\" column=\"7\">property</primary><assign line=\"1\" " +
			"column=\"16\">=</assign><number line=\"1\" column=\"18\">42</number>" +
			"</assignment></super>");
	}
	
	[Test]
	public function testThrow():void
	{
		var input:String = "throw new Error('error')";
		assertStatementPrint(input);
		assertStatement("1",
			input,
			"<throw line=\"1\" column=\"1\"><primary line=\"1\" " +
			"column=\"7\"><new line=\"1\" column=\"7\"><call line=\"1\" " +
			"column=\"16\"><primary line=\"1\" column=\"11\">Error</primary>" +
			"<arguments line=\"1\" column=\"16\"><string line=\"1\" " +
			"column=\"17\">'error'</string></arguments></call></new>" +
			"</primary></throw>");
	}
	
	[Test]
	public function testDefaultXMLNamespace():void
	{
		var input:String = "default xml namespace = foo_namespace";
		assertStatementPrint(input);
		assertStatement("1",
			input,
			"<df-xml-ns line=\"1\" column=\"1\"><primary line=\"1\" " +
			"column=\"25\">foo_namespace</primary></df-xml-ns>");
	}
}
}