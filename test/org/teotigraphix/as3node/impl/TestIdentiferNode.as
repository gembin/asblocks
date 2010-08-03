package org.teotigraphix.as3node.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.impl.CompilationNode;
import org.teotigraphix.as3nodes.impl.IdentifierNode;
import org.teotigraphix.as3nodes.impl.PackageNode;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3Parser;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestIdentiferNode
{
	private var unit:IParserNode;
	
	private var parser:AS3Parser;
	
	private var compilationNode:CompilationNode;
	
	private var packageNode:PackageNode;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
		
		var lines:Array =
			[
				"package my.domain {",
				"    import flash.events.IEventDispatcher",
				"    public final class Test extends my.domain.OtherTest ",
				"        implements flash.events.IEventDispatcher, my.domain.ITest",
				"    {",
				"        public var variable:my.domain.StringBuffer;",
				"        public static function method(arg0:my.domain.StringBuffer):my.domain.StringBuffer",
				"        {",
				"            return null;",
				"        }",
				"    }",
				"}",
			];
		
		unit = parser.buildAst(ASTUtil.toVector(lines), "internal");
		
		compilationNode = new CompilationNode(unit, null);
		packageNode = compilationNode.packageNode as PackageNode;
	}
	
	[Test]
	public function testBasic():void
	{
		var uid:IIdentifierNode = IdentifierNode.createName("my.domain.core");
		
		Assert.assertEquals("core", uid.localName);
		Assert.assertEquals("my.domain", uid.packageName);
		Assert.assertEquals("my.domain.core", uid.qualifiedName);
		
		uid = IdentifierNode.createName("my.domain.core.MyClass");
		
		Assert.assertEquals("MyClass", uid.localName);
		Assert.assertEquals("my.domain.core", uid.packageName);
		Assert.assertEquals("my.domain.core.MyClass", uid.qualifiedName);
		
		uid = IdentifierNode.createName("my.domain.core.MyClass#myVariable");
		
		Assert.assertEquals("MyClass", uid.localName);
		Assert.assertEquals("my.domain.core", uid.packageName);
		Assert.assertNull(uid.fragmentType);
		Assert.assertEquals("myVariable", uid.fragmentName);
		Assert.assertEquals("my.domain.core.MyClass#myVariable", uid.qualifiedName);
		
		uid = IdentifierNode.createName("my.domain.core.MyClass#style:myStyle");
		
		Assert.assertEquals("MyClass", uid.localName);
		Assert.assertEquals("my.domain.core", uid.packageName);
		Assert.assertEquals("style", uid.fragmentType);
		Assert.assertEquals("myStyle", uid.fragmentName);
		Assert.assertEquals("my.domain.core.MyClass#style:myStyle", uid.qualifiedName);
		
		uid = IdentifierNode.createName("toplevel");
		
		Assert.assertNull(uid.packageName);
		Assert.assertEquals("toplevel", uid.localName);
		Assert.assertEquals("toplevel", uid.qualifiedName);
		
		uid = IdentifierNode.createName("MyClass#myVariable");
		
		Assert.assertNull(uid.packageName);
		Assert.assertEquals("MyClass", uid.localName);
		Assert.assertNull(uid.fragmentType);
		Assert.assertEquals("myVariable", uid.fragmentName);
		Assert.assertEquals("MyClass#myVariable", uid.qualifiedName);
		
		uid = IdentifierNode.createName("MyClass#style:myStyle");
		
		Assert.assertNull(uid.packageName);
		Assert.assertEquals("MyClass", uid.localName);
		Assert.assertEquals("style", uid.fragmentType);
		Assert.assertEquals("myStyle", uid.fragmentName);
		Assert.assertEquals("MyClass#style:myStyle", uid.qualifiedName);
	}
	
	[Test]
	public function testPackageElements():void
	{
		var imports:Vector.<IIdentifierNode> = packageNode.imports;
	}
}
}