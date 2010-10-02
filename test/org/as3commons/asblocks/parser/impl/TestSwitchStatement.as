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
 * A <code>switch(){case:default:}</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestSwitchStatement extends AbstractStatementTest
{
	[Test]
	public function testFullFeatured():void
	{
		var input:String = "switch( x ) { case 1 : trace('one'); break; default : trace('unknown'); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<switch line=\"1\" column=\"1\"><condition line=\"1\" column=\"7\"><primary line=\"1\" column=\"9\">x</primary></condition><cases line=\"1\" column=\"13\"><case line=\"1\" column=\"15\"><number line=\"1\" column=\"20\">1</number><switch-block line=\"1\" column=\"24\"><expr-stmnt line=\"1\" column=\"24\"><call line=\"1\" column=\"29\"><primary line=\"1\" column=\"24\">trace</primary><arguments line=\"1\" column=\"29\"><string line=\"1\" column=\"30\">'one'</string></arguments></call></expr-stmnt><break line=\"1\" column=\"38\"></break></switch-block></case><case line=\"1\" column=\"45\"><default line=\"1\" column=\"45\"></default><switch-block line=\"1\" column=\"55\"><expr-stmnt line=\"1\" column=\"55\"><call line=\"1\" column=\"60\"><primary line=\"1\" column=\"55\">trace</primary><arguments line=\"1\" column=\"60\"><string line=\"1\" column=\"61\">'unknown'</string></arguments></call></expr-stmnt></switch-block></case></cases></switch>");
		
		input = "switch( x ) { case 1 : break; default:}";
		assertStatementPrint(input);
		assertStatement("2", input,
			"<switch line=\"1\" column=\"1\"><condition line=\"1\" column=\"7\"><primary line=\"1\" column=\"9\">x</primary></condition><cases line=\"1\" column=\"13\"><case line=\"1\" column=\"15\"><number line=\"1\" column=\"20\">1</number><switch-block line=\"1\" column=\"24\"><break line=\"1\" column=\"24\"></break></switch-block></case><case line=\"1\" column=\"31\"><default line=\"1\" column=\"31\"></default><switch-block line=\"1\" column=\"39\"></switch-block></case></cases></switch>");
	}
}
}