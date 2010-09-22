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
	public function testConditionalCompilationIf():void
	{
		var input:String = "CONFIG :: DEBUG { if( true ){ trace( true ); } }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<config line=\"1\" column=\"1\"><name line=\"-1\" column=\"-1\">DEBUG" +
			"</name><block line=\"1\" column=\"17\"><if line=\"1\" column=\"19\">" +
			"<condition line=\"1\" column=\"21\"><true line=\"1\" column=\"23\">true" +
			"</true></condition><block line=\"1\" column=\"29\"><expr-stmnt line=\"1\" " +
			"column=\"31\"><call line=\"1\" column=\"36\"><primary line=\"1\" column=\"31\">" +
			"trace</primary><arguments line=\"1\" column=\"36\"><true line=\"1\" " +
			"column=\"38\">true</true></arguments></call></expr-stmnt></block></if>" +
			"</block></config>");
	}
	
	[Test]
	public function testIf():void
	{
		var input:String = "if( true ){ trace( true ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\"><true line=\"1\" column=\"5\">true</true></condition><block line=\"1\" column=\"11\"><expr-stmnt line=\"1\" column=\"13\"><call line=\"1\" column=\"18\"><primary line=\"1\" column=\"13\">trace</primary><arguments line=\"1\" column=\"18\"><true line=\"1\" column=\"20\">true</true></arguments></call></expr-stmnt></block></if>");
		
		input = "if( \"property\" in object ){ }";
		assertStatementPrint(input);
		assertStatement("2", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\"><relational line=\"1\" column=\"5\"><string line=\"1\" column=\"5\">\"property\"</string><in line=\"1\" column=\"16\">in</in><primary line=\"1\" column=\"19\">object</primary></relational></condition><block line=\"1\" column=\"27\"></block></if>");
		
		input = "if (obj.my_namespace::namespaceProperty) {obj.my_namespace::_prop = NaN;}";
		assertStatementPrint(input);
		assertStatement("3", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"4\"><dot line=\"1\" column=\"8\"><primary line=\"1\" column=\"5\">obj</primary><double-column line=\"1\" column=\"21\"><primary line=\"1\" column=\"9\">my_namespace</primary><primary line=\"1\" column=\"23\">namespaceProperty</primary></double-column></dot></condition><block line=\"1\" column=\"42\"><expr-stmnt line=\"1\" column=\"43\"><dot line=\"1\" column=\"46\"><primary line=\"1\" column=\"43\">obj</primary><double-column line=\"1\" column=\"59\"><primary line=\"1\" column=\"47\">my_namespace</primary><assignment line=\"1\" column=\"61\"><primary line=\"1\" column=\"61\">_prop</primary><assign line=\"1\" column=\"67\">=</assign><number line=\"1\" column=\"69\">NaN</number></assignment></double-column></dot></expr-stmnt></block></if>");
	}
	
	[Test]
	public function testIfElse():void
	{
		var input:String = "if( true ){ trace( true ); } else { trace( false )}";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\"><true line=\"1\" column=\"5\">true</true></condition><block line=\"1\" column=\"11\"><expr-stmnt line=\"1\" column=\"13\"><call line=\"1\" column=\"18\"><primary line=\"1\" column=\"13\">trace</primary><arguments line=\"1\" column=\"18\"><true line=\"1\" column=\"20\">true</true></arguments></call></expr-stmnt></block><else line=\"1\" column=\"30\"><block line=\"1\" column=\"35\"><expr-stmnt line=\"1\" column=\"37\"><call line=\"1\" column=\"42\"><primary line=\"1\" column=\"37\">trace</primary><arguments line=\"1\" column=\"42\"><false line=\"1\" column=\"44\">false</false></arguments></call></expr-stmnt></block></else></if>");
	}
	
	[Test]
	public function testIfElseIf():void
	{
		var input:String = "if( true ){ trace( true ); } else if ( false) { trace( false )}";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\"><true line=\"1\" column=\"5\">true</true></condition><block line=\"1\" column=\"11\"><expr-stmnt line=\"1\" column=\"13\"><call line=\"1\" column=\"18\"><primary line=\"1\" column=\"13\">trace</primary><arguments line=\"1\" column=\"18\"><true line=\"1\" column=\"20\">true</true></arguments></call></expr-stmnt></block><else line=\"1\" column=\"30\"><if line=\"1\" column=\"35\"><condition line=\"1\" column=\"38\"><false line=\"1\" column=\"40\">false</false></condition><block line=\"1\" column=\"47\"><expr-stmnt line=\"1\" column=\"49\"><call line=\"1\" column=\"54\"><primary line=\"1\" column=\"49\">trace</primary><arguments line=\"1\" column=\"54\"><false line=\"1\" column=\"56\">false</false></arguments></call></expr-stmnt></block></if></else></if>");
	}
	
	[Test]
	public function testIfElseIfElse():void
	{
		var input:String = "if( true ){ trace( true ); } else if ( false) { trace( false )} else { trace( false ) }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\"><true line=\"1\" column=\"5\">true</true></condition><block line=\"1\" column=\"11\"><expr-stmnt line=\"1\" column=\"13\"><call line=\"1\" column=\"18\"><primary line=\"1\" column=\"13\">trace</primary><arguments line=\"1\" column=\"18\"><true line=\"1\" column=\"20\">true</true></arguments></call></expr-stmnt></block><else line=\"1\" column=\"30\"><if line=\"1\" column=\"35\"><condition line=\"1\" column=\"38\"><false line=\"1\" column=\"40\">false</false></condition><block line=\"1\" column=\"47\"><expr-stmnt line=\"1\" column=\"49\"><call line=\"1\" column=\"54\"><primary line=\"1\" column=\"49\">trace</primary><arguments line=\"1\" column=\"54\"><false line=\"1\" column=\"56\">false</false></arguments></call></expr-stmnt></block><else line=\"1\" column=\"65\"><block line=\"1\" column=\"70\"><expr-stmnt line=\"1\" column=\"72\"><call line=\"1\" column=\"77\"><primary line=\"1\" column=\"72\">trace</primary><arguments line=\"1\" column=\"77\"><false line=\"1\" column=\"79\">false</false></arguments></call></expr-stmnt></block></else></if></else></if>");
	}
	
	[Test]
	public function testIfWithArrayAccessor():void
	{
		var input:String = "if ( a[ xField ] [ xy ] > targetXFieldValue ){}";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"4\"><relational line=\"1\" column=\"6\"><arr-acc line=\"1\" column=\"7\"><primary line=\"1\" column=\"6\">a</primary><primary line=\"1\" column=\"9\">xField</primary><primary line=\"1\" column=\"20\">xy</primary></arr-acc><gt line=\"1\" column=\"25\">&gt;</gt><primary line=\"1\" column=\"27\">targetXFieldValue</primary></relational></condition><block line=\"1\" column=\"46\"></block></if>");
		
		input = "if ( chart.getItemAt( 0 )[ xField ] [ xy ] > targetXFieldValue ){}";
		assertStatementPrint(input);
		assertStatement("2", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"4\"><dot line=\"1\" column=\"11\"><primary line=\"1\" column=\"6\">chart</primary><relational line=\"1\" column=\"12\"><call line=\"1\" column=\"21\"><primary line=\"1\" column=\"12\">getItemAt</primary><arguments line=\"1\" column=\"21\"><number line=\"1\" column=\"23\">0</number></arguments><array line=\"1\" column=\"26\"><primary line=\"1\" column=\"28\">xField</primary></array><array line=\"1\" column=\"37\"><primary line=\"1\" column=\"39\">xy</primary></array></call><gt line=\"1\" column=\"44\">&gt;</gt><primary line=\"1\" column=\"46\">targetXFieldValue</primary></relational></dot></condition><block line=\"1\" column=\"65\"></block></if>");
	}
	
	[Test]
	public function testIfWithEmptyStatement():void
	{
		var input:String = "if( i++ ); ";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\"><post-inc line=\"1\" column=\"6\"><primary line=\"1\" column=\"5\">i</primary></post-inc></condition><stmt-empty line=\"1\" column=\"10\">;</stmt-empty></if>");
	}
	
	[Test]
	public function testIfWithoutBlock():void
	{
		var input:String = "if( i++ ) trace( i ); ";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\"><post-inc line=\"1\" column=\"6\"><primary line=\"1\" column=\"5\">i</primary></post-inc></condition><expr-stmnt line=\"1\" column=\"11\"><call line=\"1\" column=\"16\"><primary line=\"1\" column=\"11\">trace</primary><arguments line=\"1\" column=\"16\"><primary line=\"1\" column=\"18\">i</primary></arguments></call></expr-stmnt></if>");
	}
	
	[Test]
	public function testIfWithReturn():void
	{
		var input:String = "if ( true )return;";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"4\"><true line=\"1\" column=\"6\">true</true></condition><return line=\"1\" column=\"12\"></return></if>");
		
		input = "if ( true )throw new Error();";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"4\"><true line=\"1\" column=\"6\">true</true></condition><throw line=\"1\" column=\"12\"><primary line=\"1\" column=\"18\"><new line=\"1\" column=\"18\"><call line=\"1\" column=\"27\"><primary line=\"1\" column=\"22\">Error</primary><arguments line=\"1\" column=\"27\"></arguments></call></new></primary></throw></if>");
	}
}
}