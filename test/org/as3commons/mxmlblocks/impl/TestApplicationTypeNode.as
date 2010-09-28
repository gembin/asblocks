package org.as3commons.mxmlblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.IScriptNode;
import org.as3commons.asblocks.api.Visibility;
import org.as3commons.asblocks.impl.ASTPrinter;
import org.as3commons.asblocks.impl.ApplicationUnitNode;
import org.as3commons.asblocks.impl.BaseASFactoryTest;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.utils.ASTUtil;
import org.as3commons.mxmlblocks.api.IAttribute;
import org.as3commons.mxmlblocks.api.IBlockTag;
import org.as3commons.mxmlblocks.api.IScriptTag;
import org.as3commons.mxmlblocks.api.IXMLNamespace;
import org.as3commons.mxmlblocks.parser.impl.MXMLFragmentParser;
import org.flexunit.Assert;

public class TestApplicationTypeNode extends BaseASFactoryTest
{
	private var unit:ApplicationUnitNode;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
	}
	
	[After]
	override public function tearDown():void
	{
		if (unit)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = ApplicationUnitNode(unit).mxml;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = MXMLFragmentParser.parseCompilationUnit(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
			//CodeMirror.assertReflection(factory, unit);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		unit = project.newApplication("my.domain.MyApplication", "mx.core.WindowedApplication") as ApplicationUnitNode;
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>\n" +
			"</WindowedApplication>", unit);
		
		var ctype:IClassType = unit.typeNode as IClassType;
		
		Assert.assertEquals("my.domain", unit.packageName);
		Assert.assertEquals("MyApplication", ctype.name);
		Assert.assertTrue(ctype.visibility.equals(Visibility.PUBLIC));
		Assert.assertEquals("mx.core.WindowedApplication", ctype.superClass);
		
	}
	
	[Test]
	public function testScriptTag():void
	{
		unit = project.newApplication("my.domain.MyApplication", "mx.core.WindowedApplication") as ApplicationUnitNode;
		
		var stag:IScriptTag = unit.mxmlNode.newScriptTag(null);
		stag.block.newMethod("foo", Visibility.PROTECTED, "void");
		
		// FIXME there is an extra \t after <fx:Script>
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>" +
			"\n\t<fx:Script>\n\t<![CDATA[\n\t\tprotected function foo():void {" +
			"\n\t\t}\n\t]]>\n\t</fx:Script>\n</WindowedApplication>", unit);
	}
	
	//[Test]
	public function _estBasic():void
	{
		unit = project.newApplication("my.domain.MyApplication", "mx.core.WindowedApplication") as ApplicationUnitNode;
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>\n" +
			"</WindowedApplication>", unit);
		
		var ctype:IClassType = unit.typeNode as IClassType;
		
		Assert.assertEquals("my.domain", unit.packageName);
		Assert.assertEquals("MyApplication", ctype.name);
		Assert.assertTrue(ctype.visibility.equals(Visibility.PUBLIC));
		Assert.assertEquals("mx.core.WindowedApplication", ctype.superClass);
		
		unit.mxmlNode.binding = "s";
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<s:WindowedApplication>" +
			"\n</s:WindowedApplication>", unit);
		
		unit.mxmlNode.binding = "mx";
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<mx:WindowedApplication>" +
			"\n</mx:WindowedApplication>", unit);
		
		var xml:IXMLNamespace = unit.mxmlNode.newXMLNS("s", "library://ns.adobe.com/flex/spark");
		Assert.assertEquals("s", xml.localName);
		Assert.assertEquals("library://ns.adobe.com/flex/spark", xml.uri);
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<mx:WindowedApplication " +
			"xmlns:s=\"library://ns.adobe.com/flex/spark\">\n</mx:WindowedApplication>", unit);
		
		xml.localName = "foo";
		Assert.assertEquals("foo", xml.localName);
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<mx:WindowedApplication " +
			"xmlns:foo=\"library://ns.adobe.com/flex/spark\">\n</mx:WindowedApplication>", unit);
		
		xml.uri = "foo.bar.*";
		Assert.assertEquals("foo.bar.*", xml.uri);
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<mx:WindowedApplication " +
			"xmlns:foo=\"foo.bar.*\">\n</mx:WindowedApplication>", unit);
		
		xml.localName = null;
		Assert.assertNull(xml.localName);
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<mx:WindowedApplication " +
			"xmlns=\"foo.bar.*\">\n</mx:WindowedApplication>", unit);
		
		unit.mxmlNode.newXMLNS("s", "library://ns.adobe.com/flex/spark");
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<mx:WindowedApplication " +
			"xmlns=\"foo.bar.*\" xmlns:s=\"library://ns.adobe.com/flex/spark\">\n" +
			"</mx:WindowedApplication>", unit);
	}
	
	//[Test]
	public function testBasicNested():void
	{
		unit = project.newApplication("my.domain.MyApplication", "mx.core.WindowedApplication") as ApplicationUnitNode;
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>\n" +
			"</WindowedApplication>", unit);
		
		var ctype:IClassType = unit.typeNode as IClassType;
		
		Assert.assertEquals("my.domain", unit.packageName);
		Assert.assertEquals("MyApplication", ctype.name);
		Assert.assertTrue(ctype.visibility.equals(Visibility.PUBLIC));
		Assert.assertEquals("mx.core.WindowedApplication", ctype.superClass);
		
		var mxml:IBlockTag = unit.mxmlNode;
		
		var group:IBlockTag = mxml.newTag("VGroup");
		var button:IBlockTag = group.newTag("Button");
		var link:IBlockTag = button.newTag("Link");
		//var att:IAttribute = button.newAttribute("id", "button");
		
		var result:String = ASTUtil.convert(unit.mxml, false);
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>" +
			"\n\t<VGroup>\n\t\t<Button>\n\t\t\t<Link>\n\t\t\t</Link>\n\t\t</Button>" +
			"\n\t</VGroup>\n</WindowedApplication>", unit);
	}
	
	//[Test]
	public function testBasicBinding():void
	{
		unit = project.newApplication("my.domain.MyApplication", "mx.core.WindowedApplication") as ApplicationUnitNode;
		
		var ctype:IClassType = unit.typeNode as IClassType;

		var mxml:IBlockTag = unit.mxmlNode;
		
		var group:IBlockTag = mxml.newTag("VGroup", "s");
		var button:IBlockTag = group.newTag("Button", "s");
		
		var result:String = ASTUtil.convert(unit.mxml, false);
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>" +
			"\n\t<s:VGroup>\n\t\t<s:Button>\n\t\t</s:Button>\n\t</s:VGroup>\n" +
			"</WindowedApplication>", unit);
	}
	
	//[Test]
	public function testBasicAttribute():void
	{
		unit = project.newApplication("my.domain.MyApplication", "mx.core.WindowedApplication") as ApplicationUnitNode;
		var mxml:IBlockTag = unit.mxmlNode;
		var group:IBlockTag = mxml.newTag("VGroup", "s");
		var ia:IAttribute = group.newAttribute("id", "myGroup");
		
		Assert.assertEquals("id", ia.name);
		Assert.assertNull(ia.state);
		Assert.assertEquals("myGroup", ia.value);
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>" +
			"\n\t<s:VGroup id=\"myGroup\">\n\t</s:VGroup>\n</WindowedApplication>", unit);
		
		group.newAttribute("width", "42");
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>" +
			"\n\t<s:VGroup id=\"myGroup\" width=\"42\">\n\t</s:VGroup>\n" +
			"</WindowedApplication>", unit);
	}
	
	//[Test]
	public function testBasicAttributeWithState():void
	{
		unit = project.newApplication("my.domain.MyApplication", "mx.core.WindowedApplication") as ApplicationUnitNode;
		var mxml:IBlockTag = unit.mxmlNode;
		var group:IBlockTag = mxml.newTag("VGroup", "s");
		var vs:IAttribute = group.newAttribute("visible", "true");
		vs.state = "normal";
		
		Assert.assertEquals("visible", vs.name);
		Assert.assertEquals("normal", vs.state);
		Assert.assertEquals("true", vs.value);
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>" +
			"\n\t<s:VGroup visible.normal=\"true\">\n\t</s:VGroup>\n</WindowedApplication>", unit);
		
		// remove state
		vs.state = null;
		Assert.assertNull(vs.state);
		
		assertPrint("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<WindowedApplication>" +
			"\n\t<s:VGroup visible=\"true\">\n\t</s:VGroup>\n</WindowedApplication>", unit);
	}
		
	override protected function assertPrint(expected:String, 
											expression:IScriptNode):void
	{
		printer.print(ApplicationUnitNode(expression).mxml);
		var result:String = printer.flush();
		Assert.assertEquals(expected, result);
	}
	
}
}