package org.teotigraphix.as3nodes.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
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
				"    import flash.events.EventDispatcher",
				"    public final class Test extends my.domain.OtherTest ",
				"        implements flash.events.IEventDispatcher, my.domain.ITest",
				"    {",
				"        public var myVar:my.domain.StringBuffer;",
				"        public static function methodA(arg0:my.domain.ParamType):my.domain.ReturnType",
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
	public function test_createQualifiedName():void
	{
		var uid:IIdentifierNode;
		
		uid = IdentifierNode.createQualifiedName(null, "my", "package");
		Assert.assertEquals("package", uid.localName);
		Assert.assertEquals("my", uid.packageName);
		Assert.assertEquals("my.package", uid.qualifiedName);
		Assert.assertEquals("my", uid.parentQualifiedName);
		Assert.assertFalse(uid.hasFragmentType);
		Assert.assertFalse(uid.hasFragment);
		// shortcut
		uid = IdentifierNode.createQualifiedName(null, "my.package");
		Assert.assertEquals("package", uid.localName);
		Assert.assertEquals("my", uid.packageName);
		Assert.assertEquals("my.package", uid.qualifiedName);
		Assert.assertEquals("my", uid.parentQualifiedName);
		Assert.assertFalse(uid.hasFragmentType);
		Assert.assertFalse(uid.hasFragment);
		
		uid = IdentifierNode.createQualifiedName(null, "my.package", "Test");
		Assert.assertEquals("Test", uid.localName);
		Assert.assertEquals("my.package", uid.packageName);
		Assert.assertEquals("my.package.Test", uid.qualifiedName);
		Assert.assertEquals("my.package", uid.parentQualifiedName);
		Assert.assertFalse(uid.hasFragmentType);
		Assert.assertFalse(uid.hasFragment);
		// shortcut
		uid = IdentifierNode.createQualifiedName(null, "my.package.Test");
		Assert.assertEquals("Test", uid.localName);
		Assert.assertEquals("my.package", uid.packageName);
		Assert.assertEquals("my.package.Test", uid.qualifiedName);
		Assert.assertEquals("my.package", uid.parentQualifiedName);
		Assert.assertFalse(uid.hasFragmentType);
		Assert.assertFalse(uid.hasFragment);
		
		// no shortcut for fragments
		uid = IdentifierNode.createQualifiedName(null, "", "Test", "style", "myStyle");
		Assert.assertEquals("myStyle", uid.localName);
		Assert.assertNull(uid.packageName);
		Assert.assertEquals("Test#style:myStyle", uid.qualifiedName);
		Assert.assertEquals("Test", uid.parentQualifiedName);
		Assert.assertTrue(uid.hasFragmentType);
		Assert.assertTrue(uid.hasFragment);
		Assert.assertEquals("style", uid.fragmentType);
		Assert.assertEquals("myStyle", uid.fragmentName);
	}
	
	[Test]
	public function testBasic():void
	{
		var name:IParserNode = ASTNodeUtil.createName("my.package");
		var uid:IIdentifierNode = NodeFactory.instance.createIdentifier(name, null);
		
		Assert.assertEquals("package", uid.localName);
		Assert.assertEquals("my", uid.packageName);
		Assert.assertEquals("my.package", uid.qualifiedName);
		Assert.assertEquals("my", uid.parentQualifiedName);
		Assert.assertFalse(uid.hasFragmentType);
		Assert.assertFalse(uid.hasFragment);
		
		name = ASTNodeUtil.createName("my.package.File");
		uid = NodeFactory.instance.createIdentifier(name, null);
		
		Assert.assertEquals("File", uid.localName);
		Assert.assertEquals("my.package", uid.packageName);
		Assert.assertEquals("my.package.File", uid.qualifiedName);
		Assert.assertEquals("my.package", uid.parentQualifiedName);
		Assert.assertFalse(uid.hasFragmentType);
		Assert.assertFalse(uid.hasFragment);
		
		name = ASTNodeUtil.createName("my.package.File#style:myStyle");
		uid = NodeFactory.instance.createIdentifier(name, null);
		
		Assert.assertEquals("myStyle", uid.localName);
		Assert.assertEquals("my.package", uid.packageName);
		Assert.assertEquals("my.package.File#style:myStyle", uid.qualifiedName);
		Assert.assertEquals("my.package.File", uid.parentQualifiedName);
		Assert.assertTrue(uid.hasFragmentType);
		Assert.assertTrue(uid.hasFragment);
		Assert.assertEquals("style", uid.fragmentType);
		Assert.assertEquals("myStyle", uid.fragmentName);
	}
	
	[Test]
	public function testBasicParse():void
	{
		var uid:IIdentifierNode = IdentifierNode.createName("my.domain.core");
		
		Assert.assertEquals("core", uid.localName);
		Assert.assertEquals("my.domain", uid.packageName);
		Assert.assertEquals("my.domain.core", uid.qualifiedName);
		
		uid = IdentifierNode.createName("my.domain.core.MyClass");
		
		Assert.assertEquals("MyClass", uid.localName);
		Assert.assertEquals("my.domain.core", uid.packageName);
		Assert.assertEquals("my.domain.core", uid.parentQualifiedName);
		Assert.assertEquals("my.domain.core.MyClass", uid.qualifiedName);
		
		uid = IdentifierNode.createName("my.domain.core.MyClass#myVariable");
		
		Assert.assertEquals("MyClass", uid.localName);
		Assert.assertEquals("my.domain.core", uid.packageName);
		Assert.assertNull(uid.fragmentType);
		Assert.assertEquals("myVariable", uid.fragmentName);
		Assert.assertEquals("my.domain.core.MyClass", uid.parentQualifiedName);
		Assert.assertEquals("my.domain.core.MyClass#myVariable", uid.qualifiedName);
		
		uid = IdentifierNode.createName("my.domain.core.MyClass#style:myStyle");
		
		Assert.assertEquals("myStyle", uid.localName);
		Assert.assertEquals("my.domain.core", uid.packageName);
		Assert.assertEquals("style", uid.fragmentType);
		Assert.assertEquals("myStyle", uid.fragmentName);
		Assert.assertEquals("my.domain.core.MyClass", uid.parentQualifiedName);
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
		Assert.assertEquals("MyClass", uid.parentQualifiedName);
		Assert.assertEquals("MyClass#myVariable", uid.qualifiedName);
		
		uid = IdentifierNode.createName("MyClass#style:myStyle");
		
		Assert.assertNull(uid.packageName);
		Assert.assertEquals("myStyle", uid.localName);
		Assert.assertEquals("style", uid.fragmentType);
		Assert.assertEquals("myStyle", uid.fragmentName);
		Assert.assertEquals("MyClass", uid.parentQualifiedName);
		Assert.assertEquals("MyClass#style:myStyle", uid.qualifiedName);
	}
	
	[Test]
	public function testBasicConstant():void
	{
		var uid:IIdentifierNode = IdentifierNode.
			createName("org.example.core.ClassA#constant:aPublicStaticConst");
		
		Assert.assertEquals("aPublicStaticConst", uid.localName);
		Assert.assertEquals("org.example.core", uid.packageName);
		Assert.assertEquals("org.example.core.ClassA", uid.parentQualifiedName);
		
		Assert.assertEquals("constant", uid.fragmentType);
		Assert.assertEquals("aPublicStaticConst", uid.fragmentName);
		Assert.assertEquals("org.example.core.ClassA#constant:aPublicStaticConst", uid.qualifiedName);
	}
	
	[Test]
	public function testPackageElements():void
	{
		var imports:Vector.<IIdentifierNode> = packageNode.imports;
		Assert.assertEquals(2, imports.length);
		
		Assert.assertTrue(imports[0].isQualified);
		Assert.assertEquals("IEventDispatcher", imports[0].localName);
		Assert.assertEquals("flash.events", imports[0].packageName);
		Assert.assertEquals("flash.events.IEventDispatcher", imports[0].qualifiedName);
		
		Assert.assertTrue(imports[1].isQualified);
		Assert.assertEquals("EventDispatcher", imports[1].localName);
		Assert.assertEquals("flash.events", imports[1].packageName);
		Assert.assertEquals("flash.events.EventDispatcher", imports[1].qualifiedName);
		
		var type:IClassTypeNode = packageNode.typeNode as IClassTypeNode;
		Assert.assertTrue(type.superClass.isQualified);
		Assert.assertEquals("OtherTest", type.superClass.localName);
		Assert.assertEquals("my.domain", type.superClass.packageName);
		Assert.assertEquals("my.domain.OtherTest", type.superClass.qualifiedName);
		
		var implementations:Vector.<IIdentifierNode> = type.implementList;
		Assert.assertEquals(2, implementations.length);
		
		Assert.assertTrue(implementations[0].isQualified);
		Assert.assertEquals("IEventDispatcher", implementations[0].localName);
		Assert.assertEquals("flash.events", implementations[0].packageName);
		Assert.assertEquals("flash.events.IEventDispatcher", implementations[0].qualifiedName);
		
		Assert.assertTrue(implementations[1].isQualified);
		Assert.assertEquals("ITest", implementations[1].localName);
		Assert.assertEquals("my.domain", implementations[1].packageName);
		Assert.assertEquals("my.domain.ITest", implementations[1].qualifiedName);
		
		var attributes:Vector.<IAttributeNode> = type.attributes;
		Assert.assertEquals(1, attributes.length);
		
		// test the IAttribute.uid
		Assert.assertNotNull(attributes[0].uid);
		//Assert.assertTrue(attributes[0].uid.isQualified);
		//Assert.assertTrue(attributes[0].uid.hasFragment);
		//Assert.assertTrue(attributes[0].uid.hasFragmentType);
		
		//Assert.assertEquals("myVar", attributes[0].uid.fragmentName);
		//Assert.assertEquals("variable", attributes[0].uid.fragmentType);
		//Assert.assertEquals("my.domain", attributes[0].uid.packageName);
		//Assert.assertEquals("my.domain.Test", attributes[0].uid.parentQualifiedName);
		//Assert.assertEquals("my.domain.Test#attribute:myVar", attributes[0].uid.qualifiedName);
		Assert.assertEquals("StringBuffer", attributes[0].type.localName);
		Assert.assertEquals("my.domain", attributes[0].type.packageName);
		Assert.assertEquals("my.domain.StringBuffer", attributes[0].type.qualifiedName);
		
		var methods:Vector.<IMethodNode> = type.methods;
		Assert.assertEquals(1, methods.length);
		Assert.assertNotNull(methods[0].uid);
		Assert.assertNotNull(methods[0].type);
		Assert.assertEquals("methodA", methods[0].uid.localName);
		Assert.assertEquals("ReturnType", methods[0].type.localName);
		Assert.assertEquals("my.domain", methods[0].type.packageName);
		Assert.assertEquals("my.domain.ReturnType", methods[0].type.qualifiedName);
		
		var parameters:Vector.<IParameterNode> = methods[0].parameters;
		Assert.assertEquals(1, parameters.length);
		Assert.assertNotNull(parameters[0].name);
		Assert.assertEquals("arg0", parameters[0].name);
		Assert.assertEquals("ParamType", parameters[0].type.localName);
		Assert.assertEquals("my.domain", parameters[0].type.packageName);
		Assert.assertEquals("my.domain.ParamType", parameters[0].type.qualifiedName);
	}
}
}