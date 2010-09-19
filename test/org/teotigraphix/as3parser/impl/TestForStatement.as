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
 * A <code>for(){}</code>, <code>for(in){}</code> and <code>for each(in){}</code> 
 * statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestForStatement extends AbstractStatementTest
{
	[Test]
	public function testSimpleFor():void
	{
		var input:String = "for( var i : int = 0; i < length; i++ ){ trace( i ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<for line=\"1\" column=\"1\"><init line=\"1\" column=\"6\"><dec-list line=\"1\" column=\"6\"><dec-role line=\"1\" column=\"6\"><var line=\"1\" column=\"6\"></var></dec-role><name-type-init line=\"1\" column=\"10\"><name line=\"1\" column=\"10\">i</name><type line=\"1\" column=\"14\">int</type><init line=\"1\" column=\"20\"><number line=\"1\" column=\"20\">0</number></init></name-type-init></dec-list></init><cond line=\"1\" column=\"23\"><relational line=\"1\" column=\"23\"><primary line=\"1\" column=\"23\">i</primary><lt line=\"1\" column=\"25\">&lt;</lt><primary line=\"1\" column=\"27\">length</primary></relational></cond><iter line=\"1\" column=\"35\"><post-inc line=\"1\" column=\"36\"><primary line=\"1\" column=\"35\">i</primary></post-inc></iter><block line=\"1\" column=\"40\"><expr-stmnt line=\"1\" column=\"42\"><call line=\"1\" column=\"47\"><primary line=\"1\" column=\"42\">trace</primary><arguments line=\"1\" column=\"47\"><primary line=\"1\" column=\"49\">i</primary></arguments></call></expr-stmnt></block></for>");
		
		input = "for (i = 0; i < n; i++)";
		//assertStatementPrint(input);
		assertStatement("2", input,
			"<for line=\"1\" column=\"1\"><init line=\"1\" column=\"6\"><assignment line=\"1\" column=\"6\"><primary line=\"1\" column=\"6\">i</primary><assign line=\"1\" column=\"8\">=</assign><number line=\"1\" column=\"10\">0</number></assignment></init><cond line=\"1\" column=\"13\"><relational line=\"1\" column=\"13\"><primary line=\"1\" column=\"13\">i</primary><lt line=\"1\" column=\"15\">&lt;</lt><primary line=\"1\" column=\"17\">n</primary></relational></cond><iter line=\"1\" column=\"20\"><post-inc line=\"1\" column=\"21\"><primary line=\"1\" column=\"20\">i</primary></post-inc></iter><expr-stmnt line=\"2\" column=\"0\"><primary line=\"2\" column=\"0\">__END__</primary></expr-stmnt></for>");
	}
	
	[Test]
	public function testSimpleForWithLabel():void
	{
		var input:String = "myLoop : for( var i : int = 0; i < length; i++ ){ }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<label line=\"1\" column=\"8\"><expr-stmnt line=\"1\" column=\"1\"><primary " +
			"line=\"1\" column=\"1\">myLoop</primary></expr-stmnt><for line=\"1\" " +
			"column=\"10\"><init line=\"1\" column=\"15\"><dec-list line=\"1\" " +
			"column=\"15\"><dec-role line=\"1\" column=\"15\"><var line=\"1\" " +
			"column=\"15\"></var></dec-role><name-type-init line=\"1\" column=\"19\">" +
			"<name line=\"1\" column=\"19\">i</name><type line=\"1\" column=\"23\">" +
			"int</type><init line=\"1\" column=\"29\"><number line=\"1\" column=\"29\">" +
			"0</number></init></name-type-init></dec-list></init><cond line=\"1\" " +
			"column=\"32\"><relational line=\"1\" column=\"32\"><primary line=\"1\" " +
			"column=\"32\">i</primary><lt line=\"1\" column=\"34\">&lt;</lt>" +
			"<primary line=\"1\" column=\"36\">length</primary></relational></cond>" +
			"<iter line=\"1\" column=\"44\"><post-inc line=\"1\" column=\"45\">" +
			"<primary line=\"1\" column=\"44\">i</primary></post-inc></iter>" +
			"<block line=\"1\" column=\"49\"></block></for></label>");
	}
	
	[Test]
	public function testSimpleForEach():void
	{
		var input:String = "for each( var obj : Object in list ){ obj.print( i ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<foreach line=\"1\" column=\"1\"><dec-list line=\"1\" column=\"11\"><dec-role line=\"1\" column=\"11\"><var line=\"1\" column=\"11\"></var></dec-role><name-type-init line=\"1\" column=\"15\"><name line=\"1\" column=\"15\">obj</name><type line=\"1\" column=\"21\">Object</type></name-type-init></dec-list><in line=\"1\" column=\"28\"><primary line=\"1\" column=\"31\">list</primary></in><block line=\"1\" column=\"37\"><expr-stmnt line=\"1\" column=\"39\"><dot line=\"1\" column=\"42\"><primary line=\"1\" column=\"39\">obj</primary><call line=\"1\" column=\"48\"><primary line=\"1\" column=\"43\">print</primary><arguments line=\"1\" column=\"48\"><primary line=\"1\" column=\"50\">i</primary></arguments></call></dot></expr-stmnt></block></foreach>");
		
		input = "for each( obj in list ){}";
		assertStatementPrint(input);
		assertStatement( "2", input,
			"<foreach line=\"1\" column=\"1\"><name line=\"1\" column=\"11\">obj</name><in line=\"1\" column=\"15\"><primary line=\"1\" column=\"18\">list</primary></in><block line=\"1\" column=\"24\"></block></foreach>" );
		
		input = "for each (var a:XML in xml.classInfo..accessor) {}";
		assertStatementPrint(input);
		assertStatement("3", input,
			"<foreach line=\"1\" column=\"1\"><dec-list line=\"1\" column=\"11\"><dec-role line=\"1\" column=\"11\"><var line=\"1\" column=\"11\"></var></dec-role><name-type-init line=\"1\" column=\"15\"><name line=\"1\" column=\"15\">a</name><type line=\"1\" column=\"17\">XML</type></name-type-init></dec-list><in line=\"1\" column=\"21\"><dot line=\"1\" column=\"27\"><primary line=\"1\" column=\"24\">xml</primary><e4x-descendent line=\"1\" column=\"37\"><primary line=\"1\" column=\"28\">classInfo</primary><primary line=\"1\" column=\"39\">accessor</primary></e4x-descendent></dot></in><block line=\"1\" column=\"49\"></block></foreach>");
	}
	
	[Test]
	public function testSimpleForIn():void
	{
		var input:String = "for( var s : String in obj ){ trace( s, obj[ s ]); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<forin line=\"1\" column=\"1\"><init line=\"1\" column=\"6\"><dec-list line=\"1\" column=\"6\"><dec-role line=\"1\" column=\"6\"><var line=\"1\" column=\"6\"></var></dec-role><name-type-init line=\"1\" column=\"10\"><name line=\"1\" column=\"10\">s</name><type line=\"1\" column=\"14\">String</type></name-type-init></dec-list></init><in line=\"1\" column=\"21\"><primary line=\"1\" column=\"24\">obj</primary></in><block line=\"1\" column=\"29\"><expr-stmnt line=\"1\" column=\"31\"><call line=\"1\" column=\"36\"><primary line=\"1\" column=\"31\">trace</primary><arguments line=\"1\" column=\"36\"><primary line=\"1\" column=\"38\">s</primary><arr-acc line=\"1\" column=\"44\"><primary line=\"1\" column=\"41\">obj</primary><primary line=\"1\" column=\"46\">s</primary></arr-acc></arguments></call></expr-stmnt></block></forin>");
		
		input = "for (p in events);";
		assertStatementPrint(input);
		assertStatement("2", input,
			"<forin line=\"1\" column=\"1\"><init line=\"1\" column=\"6\"><primary line=\"1\" column=\"6\">p</primary></init><in line=\"1\" column=\"8\"><primary line=\"1\" column=\"11\">events</primary></in><stmt-empty line=\"1\" column=\"18\">;</stmt-empty></forin>");
	}
}
}