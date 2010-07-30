package org.teotigraphix.as3parser.utils
{
import flexunit.framework.Assert;

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3Parser;

public class TestASTUtil
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	[Test]
	public function testASTMethods():void
	{
		var lines:Array =
			[
				"package my.domain {",
				"    import my.other.domain.ITest;",
				"    import my.other.domain.IOtherTest;",
				"    import flash.utils.flash_proxy;",
				"    use namespace flash_proxy;",
				"    /** An event. */",
				"    [Event(name=\"myEvent\",type=\"flash.events.Event\")]",
				"    /** A style. */",
				"    [Style(name=\"myStyle\",type=\"String\")]",
				"    /** Class comment. */",
				"    public final class Test extends OtherTest implements ITest, IOtherTest",
				"    {",
				"         /** protected var */",
				"         protected var test:int = 42;",
				"         /** public var */",
				"         public var testPublic:Number = 420;",
				"         /** flash_proxy var */",
				"         flash_proxy var testPublic:Number = 422;",
				"         /** Constructor. */",
				"         public function Test() {",
				"             super()",
				"         }",
				"         ",
				"    }",
				"}",
				"__END__"
			];
		
		var unit:IParserNode = parser.buildAst(ASTUtil.toVector(lines), null);
		var asdoc:IParserNode;
		
		// package
		Assert.assertNotNull(ASTUtil.getPackage(unit));
		
		// package/name
		Assert.assertEquals("my.domain", ASTUtil.getPackageName(unit));
		
		// package/content
		Assert.assertNotNull(ASTUtil.getPackageContent(unit));
		
		// package/content/import
		var imports:Vector.<IParserNode> = ASTUtil.getImports(unit);
		Assert.assertEquals(3, imports.length);
		Assert.assertEquals("my.other.domain.ITest", imports[0].stringValue);
		Assert.assertEquals("my.other.domain.IOtherTest", imports[1].stringValue);
		Assert.assertEquals("flash.utils.flash_proxy", imports[2].stringValue);
		
		// package/content/use
		var uses:Vector.<IParserNode> = ASTUtil.getUses(unit);
		Assert.assertEquals(1, uses.length);
		Assert.assertEquals("flash_proxy", uses[0].stringValue);
		
		// package/content/class
		var classNode:IParserNode = ASTUtil.getClass(unit);
		Assert.assertNotNull(classNode);
		
		// package/content/class/as-doc
		Assert.assertNotNull(ASTUtil.getAsDoc(classNode));
		
		// package/content/class/name
		Assert.assertEquals("Test", ASTUtil.getClassName(unit));
		
		// package/content/class/meta-list
		var metas:Vector.<IParserNode> = ASTUtil.getClassMetaData(unit);
		Assert.assertEquals(2, metas.length);
		Assert.assertEquals("Event ( name = \"myEvent\" , type = \"flash.events.Event\" )", metas[0].stringValue);
		Assert.assertEquals("Style ( name = \"myStyle\" , type = \"String\" )", metas[1].stringValue);
		
		asdoc = ASTUtil.getAsDoc(metas[0]);
		Assert.assertNotNull(asdoc);
		Assert.assertEquals("/** An event. */", asdoc.stringValue);
		
		asdoc = ASTUtil.getAsDoc(metas[1]);
		Assert.assertNotNull(asdoc);
		Assert.assertEquals("/** A style. */", asdoc.stringValue);
		
		// package/content/class/mod-list
		var modifiers:Vector.<IParserNode> = ASTUtil.getClassModifiers(unit);
		Assert.assertEquals(2, modifiers.length);
		Assert.assertEquals("public", modifiers[0].stringValue);
		Assert.assertEquals("final", modifiers[1].stringValue);
		
		// package/content/class/extends
		var extendz:IParserNode = ASTUtil.getClassExtends(unit);
		Assert.assertNotNull(extendz);
		Assert.assertEquals("OtherTest", extendz.stringValue);
		
		// package/content/class/implements-list
		var implementz:Vector.<IParserNode> = ASTUtil.getImplements(unit);
		Assert.assertNotNull(implementz);
		Assert.assertEquals("ITest", implementz[0].stringValue);
		Assert.assertEquals("IOtherTest", implementz[1].stringValue);
		
		// package/content/class/content
		var classContentNode:IParserNode = ASTUtil.getClassContent(unit);
		Assert.assertNotNull(classContentNode);
		
		// package/content/class/content/var-list[*]
		var variables:Vector.<IParserNode> = ASTUtil.getClassVariables(unit);
		Assert.assertEquals(3, variables.length);
		
		// package/content/class/content/var-list/asdoc
		//Assert.assertEquals("test", variables[0].getChild(0).stringValue);
		
		// package/content/class/content/var-list/mod-list
		
		// package/content/class/content/var-list/name-type-init
	}
}
}