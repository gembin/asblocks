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

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * A <code>interface</code> unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestInterface
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	[Test]
	public function testExtends():void
	{
		assertPackageContent("1",
			"public interface A extends B { } ",
			"<content line=\"1\" column=\"1\"><mod line=\"2\" column=\"1\">" +
			"public</mod><interface line=\"2\" column=\"8\"><name line=\"2\" " +
			"column=\"18\">A</name><extends line=\"2\" column=\"20\"><type " +
			"line=\"2\" column=\"28\">B</type></extends><content line=\"2\" " +
			"column=\"30\"></content></interface></content>");
		
		assertPackageContent("2",
			"   public interface ITimelineEntryRenderer extends IFlexDisplayObject, IDataRenderer{}",
			"<content line=\"1\" column=\"1\"><mod line=\"2\" column=\"4\">" +
			"public</mod><interface line=\"2\" column=\"11\"><name line=\"2\" " +
			"column=\"21\">ITimelineEntryRenderer</name><extends line=\"2\" " +
			"column=\"44\"><type line=\"2\" column=\"52\">IFlexDisplayObject" +
			"</type><type line=\"2\" column=\"72\">IDataRenderer</type></extends>" +
			"<content line=\"2\" column=\"85\"></content></interface></content>");
	}
	
	[Test]
	public function testInclude():void
	{
		assertPackageContent("1",
			"public interface A extends B { include \"ITextFieldInterface.asz\" } ",
			"<content line=\"1\" column=\"1\"><mod line=\"2\" column=\"1\">" +
			"public</mod><interface line=\"2\" column=\"8\"><name line=\"2\" " +
			"column=\"18\">A</name><extends line=\"2\" column=\"20\"><type " +
			"line=\"2\" column=\"28\">B</type></extends><content line=\"2\" " +
			"column=\"30\"><include line=\"2\" column=\"32\"><string line=\"2\" " +
			"column=\"40\">\"ITextFieldInterface.asz\"</string></include>" +
			"</content></interface></content>" );
	}
	
	private function assertPackageContent(message:String, 
										  input:String, 
										  expected:String):void
	{
		var lines:Array = ["{", input, "}", "__END__"];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePackageContent());
		
		Assert.assertEquals(expected, result);
	}
}
}