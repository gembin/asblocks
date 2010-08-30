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
 * A <code>if(){}</code>, <code>if(){}else{}</code> and 
 * <code>if(){}else if(){}else{}</code> 
 * statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestIfStatement extends AbstractStatementTest
{
	[Test]
	public function testIf():void
	{
		var input:String = "if( true ){ trace( true ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\">" +
			"<true line=\"1\" column=\"5\">true</true></condition><block " +
			"line=\"1\" column=\"11\"><call line=\"1\" column=\"18\"><primary " +
			"line=\"1\" column=\"13\">trace</primary><arguments line=\"1\" " +
			"column=\"18\"><true line=\"1\" column=\"20\">true</true></arguments>" +
			"</call></block></if>");
		
		input = "if( \"property\" in object ){ }";
		assertStatementPrint(input);
		assertStatement("2", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\">" +
			"<relation line=\"1\" column=\"5\"><string line=\"1\" column=\"5\">" +
			"\"property\"</string><op line=\"1\" column=\"16\">in</op><primary " +
			"line=\"1\" column=\"19\">object</primary></relation></condition>" +
			"<block line=\"1\" column=\"27\"></block></if>");
		
		input = "if (obj.my_namespace::namespaceProperty) {obj.my_namespace::_prop = NaN;}";
		assertStatementPrint(input);
		assertStatement("3", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"4\">" +
			"<dot line=\"1\" column=\"8\"><primary line=\"1\" column=\"5\">obj" +
			"</primary><double-column line=\"1\" column=\"21\"><primary line=\"1\" " +
			"column=\"9\">my_namespace</primary><primary line=\"1\" column=\"23\">" +
			"namespaceProperty</primary></double-column></dot></condition><block " +
			"line=\"1\" column=\"42\"><dot line=\"1\" column=\"46\"><primary line=\"1\" " +
			"column=\"43\">obj</primary><double-column line=\"1\" column=\"59\">" +
			"<primary line=\"1\" column=\"47\">my_namespace</primary><assign line=\"1\" " +
			"column=\"61\"><primary line=\"1\" column=\"61\">_prop</primary><op " +
			"line=\"1\" column=\"67\">=</op><primary line=\"1\" column=\"69\">NaN</primary>" +
			"</assign></double-column></dot></block></if>");
	}
	
	[Test]
	public function testIfElse():void
	{
		var input:String = "if( true ){ trace( true ); } else { trace( false )}";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\">" +
			"<true line=\"1\" column=\"5\">true</true></condition><block " +
			"line=\"1\" column=\"11\"><call line=\"1\" column=\"18\"><primary " +
			"line=\"1\" column=\"13\">trace</primary><arguments line=\"1\" " +
			"column=\"18\"><true line=\"1\" column=\"20\">true</true></arguments>" +
			"</call></block><block line=\"1\" column=\"35\"><call line=\"1\" " +
			"column=\"42\"><primary line=\"1\" column=\"37\">trace</primary>" +
			"<arguments line=\"1\" column=\"42\"><false line=\"1\" column=\"44\">" +
			"false</false></arguments></call></block></if>");
	}
	
	[Test]
	public function testIfWithArrayAccessor():void
	{
		var input:String = "if ( chart.getItemAt( 0 )[ xField ] [ xy ] > targetXFieldValue ){}";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\">" +
			"<true line=\"1\" column=\"5\">true</true></condition><block " +
			"line=\"1\" column=\"11\"><call line=\"1\" column=\"18\"><primary " +
			"line=\"1\" column=\"13\">trace</primary><arguments line=\"1\" " +
			"column=\"18\"><true line=\"1\" column=\"20\">true</true></arguments>" +
			"</call></block><block line=\"1\" column=\"35\"><call line=\"1\" " +
			"column=\"42\"><primary line=\"1\" column=\"37\">trace</primary>" +
			"<arguments line=\"1\" column=\"42\"><false line=\"1\" column=\"44\">" +
			"false</false></arguments></call></block></if>");
	}
	
	[Test]
	public function testIfWithEmptyStatement():void
	{
		assertStatement( "1",
			"if( i++ ); ",
			"<if line=\"1\" column=\"3\"><condition line=\"1\" column=\"5\">"
			+ "<post-inc line=\"1\" column=\"9\"><primary line=\"1\" column=\"5\">"
			+ "i</primary></post-inc></condition><stmt-empty line=\"1\" column=\"10\">;"
			+ "</stmt-empty></if>" );
	}
	
	[Test]
	public function testIfWithoutBlock():void
	{
		assertStatement( "1",
			"if( i++ ) trace( i ); ",
			"<if line=\"1\" column=\"3\"><condition line=\"1\" column=\"5\">"
			+ "<post-inc line=\"1\" column=\"9\"><primary line=\"1\" column=\"5\">i"
			+ "</primary></post-inc></condition><call line=\"1\" column=\"16\">"
			+ "<primary line=\"1\" column=\"11\">trace</primary><arguments line=\"1\" "
			+ "column=\"18\"><primary line=\"1\" column=\"18\">i</primary>"
			+ "</arguments></call></if>" );
	}
	
	[Test]
	public function testIfWithReturn():void
	{
		assertStatement( "",
			"if ( true )return;",
			"<if line=\"1\" column=\"4\"><condition line=\"1\" column=\"6\"><primary line=\"1\" "
			+ "column=\"6\">true</primary></condition><return line=\"2\" "
			+ "column=\"1\"></return></if>" );
		
		assertStatement( "",
			"if ( true )throw new Error();",
			"<if line=\"1\" column=\"4\"><condition line=\"1\" column=\"6\"><primary line=\"1\" "
			+ "column=\"6\">true</primary></condition><primary line=\"1\" column=\"12\">"
			+ "throw</primary></if>" );
	}
}
}