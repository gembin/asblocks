package org.as3commons.asblocks.parser.impl
{

import org.as3commons.asblocks.parser.api.IScanner;

public class TestMXMLCompilationUnit extends AbstractMXMLTest
{
	[Test]
	public function testBasic():void
	{
		var input:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<Application>" +
			"</Application>";
		
		assertUnitPrint(input);
		assertUnit("1", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?" +
			"&gt;</proc-inst><tag-list line=\"1\" column=\"39\"><local-name line=\"1\" " +
			"column=\"40\">Application</local-name></tag-list></compilation-unit>");
	}
	
	[Test]
	public function testXMLNS():void
	{
		var input:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<s:Application xmlns:s=\"library://ns.adobe.com/flex/spark\">" +
			"</s:Application>";
		
		assertUnitPrint(input);
		assertUnit("1", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"39\"><binding line=\"1\" " +
			"column=\"40\">s</binding><local-name line=\"1\" column=\"42\">Application" +
			"</local-name><xml-ns line=\"1\" column=\"54\"><local-name line=\"1\" " +
			"column=\"60\">s</local-name><uri line=\"1\" column=\"62\">" +
			"library://ns.adobe.com/flex/spark</uri></xml-ns></tag-list>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testBasicXMLNSWithBinding():void
	{
		var input:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<s:Application>" +
			"</s:Application>";
		
		assertUnitPrint(input);
		assertUnit("1", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"39\"><binding line=\"1\" " +
			"column=\"40\">s</binding><local-name line=\"1\" column=\"42\">Application" +
			"</local-name></tag-list></compilation-unit>");
		
		input =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"< s : Application xmlns : s = \"library://ns.adobe.com/flex/spark\" >" +
			"</ s : Application >";
		
		assertUnitPrint(input);
		assertUnit("2", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"39\"><binding line=\"1\" " +
			"column=\"41\">s</binding><local-name line=\"1\" column=\"45\">Application" +
			"</local-name><xml-ns line=\"1\" column=\"57\"><local-name line=\"1\" " +
			"column=\"65\">s</local-name><uri line=\"1\" column=\"69\">" +
			"library://ns.adobe.com/flex/spark</uri></xml-ns></tag-list>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testBasicAttribute():void
	{
		var input:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<s:Application id=\"foo\">" +
			"</s:Application>";
		
		assertUnitPrint(input);
		assertUnit("1", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"39\"><binding line=\"1\" " +
			"column=\"40\">s</binding><local-name line=\"1\" column=\"42\">Application" +
			"</local-name><att line=\"1\" column=\"54\"><name line=\"1\" column=\"54\">" +
			"id</name><value line=\"1\" column=\"57\">foo</value></att></tag-list>" +
			"</compilation-unit>");
		
		input =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
			"<s:Application id=\"foo\">\n" +
			"	<s:Button id=\"button1\"/>\n" +
			"	<s:VGroup id=\"group1\" horizontalGap=\"{get('gap')}\">\n" +
			"		<s:Button id=\"button2\"/>\n" +
			"	</s:VGroup>\n" +
			"</s:Application>";
		
		assertUnitPrint(input);
		assertUnit("2", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"40\"><binding line=\"1\" " +
			"column=\"41\">s</binding><local-name line=\"1\" column=\"43\">Application" +
			"</local-name><att line=\"1\" column=\"55\"><name line=\"1\" column=\"55\">" +
			"id</name><value line=\"1\" column=\"58\">foo</value></att><tag-list " +
			"line=\"1\" column=\"66\"><binding line=\"1\" column=\"67\">s</binding>" +
			"<local-name line=\"1\" column=\"69\">Button</local-name><att line=\"1\" " +
			"column=\"76\"><name line=\"1\" column=\"76\">id</name><value line=\"1\" " +
			"column=\"79\">button1</value></att></tag-list><tag-list line=\"1\" " +
			"column=\"92\"><binding line=\"1\" column=\"93\">s</binding><local-name " +
			"line=\"1\" column=\"95\">VGroup</local-name><att line=\"1\" column=\"102\">" +
			"<name line=\"1\" column=\"102\">id</name><value line=\"1\" column=\"105\">" +
			"group1</value></att><att line=\"1\" column=\"114\"><name line=\"1\" " +
			"column=\"114\">horizontalGap</name><value line=\"1\" column=\"128\">" +
			"{get('gap')}</value></att><tag-list line=\"1\" column=\"146\"><binding " +
			"line=\"1\" column=\"147\">s</binding><local-name line=\"1\" " +
			"column=\"149\">Button</local-name><att line=\"1\" column=\"156\">" +
			"<name line=\"1\" column=\"156\">id</name><value line=\"1\" " +
			"column=\"159\">button2</value></att></tag-list></tag-list></tag-list>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testAttributeStates():void
	{
		var input:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<s:Button visible=\"false\" visible.up=\"true\" visible.over=\"true\">" +
			"</s:Button>";
		
		assertUnitPrint(input);
		assertUnit("1", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"39\"><binding line=\"1\" " +
			"column=\"40\">s</binding><local-name line=\"1\" column=\"42\">Button" +
			"</local-name><att line=\"1\" column=\"49\"><name line=\"1\" column=\"49\">" +
			"visible</name><value line=\"1\" column=\"57\">false</value></att>" +
			"<att line=\"1\" column=\"65\"><name line=\"1\" column=\"65\">visible</name>" +
			"<state line=\"1\" column=\"73\">up</state><value line=\"1\" column=\"76\">" +
			"true</value></att><att line=\"1\" column=\"83\"><name line=\"1\" " +
			"column=\"83\">visible</name><state line=\"1\" column=\"91\">over</state>" +
			"<value line=\"1\" column=\"96\">true</value></att></tag-list>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testBasicDocComment():void
	{
		var input:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<!--- Application doc comment. -->" +
			"<s:Application>" +
			"</s:Application>";
		
		assertUnitPrint(input);
		assertUnit("1", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"73\"><as-doc line=\"1\" " +
			"column=\"39\">&lt;!--- Application doc comment. --&gt;</as-doc><binding " +
			"line=\"1\" column=\"74\">s</binding><local-name line=\"1\" column=\"76\">" +
			"Application</local-name></tag-list></compilation-unit>");
	}
	
	[Test]
	public function testComplexNested():void
	{
		var input:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<s:Application>" +
			"    <s:Button/>" +
			"    <s:VGroup>" +
			"        <s:Button/>" +
			"    </s:VGroup>" +
			"</s:Application>";
		
		assertUnitPrint(input);
		assertUnit("1", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"39\"><binding line=\"1\" " +
			"column=\"40\">s</binding><local-name line=\"1\" column=\"42\">Application" +
			"</local-name><tag-list line=\"1\" column=\"58\"><binding line=\"1\" " +
			"column=\"59\">s</binding><local-name line=\"1\" column=\"61\">Button" +
			"</local-name></tag-list><tag-list line=\"1\" column=\"73\"><binding " +
			"line=\"1\" column=\"74\">s</binding><local-name line=\"1\" column=\"76\">" +
			"VGroup</local-name><tag-list line=\"1\" column=\"91\"><binding line=\"1\" " +
			"column=\"92\">s</binding><local-name line=\"1\" column=\"94\">Button" +
			"</local-name></tag-list></tag-list></tag-list></compilation-unit>");
	}
	
	[Test]
	public function testComplexNestedWithDocComments():void
	{
		var input:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
			"<!--- App doc comment. -->\n" +
			"<s:Application>\n" +
			"	<!--- First button doc comment. -->\n" +
			"	<s:Button/>\n" +
			"	<!-- Garbage comment. -->\n" +
			"	<s:VGroup>\n" +
			"		<!--- Second button doc comment. -->\n" +
			"		<s:Button/>\n" +
			"	</s:VGroup>\n" +
			"</s:Application>";
		
		assertUnitPrint(input);
		assertUnit("1", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"67\"><as-doc line=\"1\" " +
			"column=\"40\">&lt;!--- App doc comment. --&gt;</as-doc><binding line=\"1\" " +
			"column=\"68\">s</binding><local-name line=\"1\" column=\"70\">Application" +
			"</local-name><tag-list line=\"1\" column=\"121\"><as-doc line=\"1\" " +
			"column=\"84\">&lt;!--- First button doc comment. --&gt;</as-doc><binding " +
			"line=\"1\" column=\"122\">s</binding><local-name line=\"1\" column=\"124\">" +
			"Button</local-name></tag-list><tag-list line=\"1\" column=\"161\"><binding " +
			"line=\"1\" column=\"162\">s</binding><local-name line=\"1\" column=\"164\">" +
			"VGroup</local-name><tag-list line=\"1\" column=\"213\"><as-doc line=\"1\" " +
			"column=\"174\">&lt;!--- Second button doc comment. --&gt;</as-doc><binding " +
			"line=\"1\" column=\"214\">s</binding><local-name line=\"1\" column=\"216\">" +
			"Button</local-name></tag-list></tag-list></tag-list></compilation-unit>");
	}
	
	[Test]
	public function testCData():void
	{
		var input:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
			"<s:Application>\n" +
			"	<fx:Script>\n" +
			"		<![CDATA[\n" +
			"			private var foo:int = 42;\n" +
			"		]]>\n" +
			"	</fx:Script>\n" +
			"</s:Application>";
		
		assertUnitPrint(input);
		assertUnit("1", input, "<compilation-unit line=\"-1\" column=\"-1\"><proc-inst " +
			"line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" +
			"</proc-inst><tag-list line=\"1\" column=\"40\"><binding line=\"1\" " +
			"column=\"41\">s</binding><local-name line=\"1\" column=\"43\">Application" +
			"</local-name><tag-list line=\"1\" column=\"57\"><binding line=\"1\" " +
			"column=\"58\">fx</binding><local-name line=\"1\" column=\"61\">Script" +
			"</local-name><cdata line=\"1\" column=\"114\">\n			" +
			"private var foo:int = 42;\n		</cdata></tag-list></tag-list>" +
			"</compilation-unit>");
	}
}
}