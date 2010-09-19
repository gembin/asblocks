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
		assertStatement("1",
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
}
}