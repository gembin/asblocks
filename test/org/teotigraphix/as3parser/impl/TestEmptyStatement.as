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
 * A <code>;</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestEmptyStatement extends AbstractStatementTest
{
	[Test]
	public function testComplex():void
	{
		var input:String = "{;1;;}";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<block line=\"1\" column=\"1\"><stmt-empty line=\"1\" column=\"2\">;</stmt-empty><expr-stmnt line=\"1\" column=\"3\"><number line=\"1\" column=\"3\">1</number></expr-stmnt></block>" );
	}
	
	[Test]
	public function testSimple():void
	{
		var input:String = ";";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<stmt-empty line=\"1\" column=\"1\">;</stmt-empty>" );
	}
}
}