package org.teotigraphix.as3parser.utils
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3Parser;

public class TestASTUtil
{
	private var parser:AS3Parser;
	
	private var classUnit:IParserNode;
	
	private var interfaceUnit:IParserNode;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
		
		var clines:Array =
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
				"         /** public constant */",
				"         public static const NAME:String = \"fortyTwo\";",
				"         /** protected var */",
				"         protected var test:int = 42;",
				"         /** public var */",
				"         public var testPublic:Number = 420;",
				"         /** flash_proxy var */",
				"         flash_proxy static var testProxy:String = \"422\";",
				"         /** Constructor. */",
				"         public function test():String {",
				"             trace('smile');",
				"         }",
				"         /** A final method. */",
				"         public final function finalMethod(arg0:Number, arg1:int = 42, ...restArg):Vector.<int> {",
				"             ",
				"         }",
				"         ",
				"    }",
				"}",
				"__END__"
			];
		
		var ilines:Array =
			[
				"package my.domain {",
				"    import my.other.domain.ITest;",
				"    import my.other.domain.IOtherTest;",
				"    [Bindable]",
				"    /** A nice interface. */",
				"    public interface ISmile extends ITest, IOtherTest",
				"    {",
				"         /** A get property. */",
				"         function get test():String;",
				"         /** @private */",
				"         function set test(value:String):void;",
				"         /** A method. */",
				"         function smile():void",
				"         /** A read only property. */",
				"         function get readonly():Boolean;",
				"    }",
				"}",
				"__END__"
			];
		
		classUnit = parser.buildAst(ASTUtil.toVector(clines), null);
		
		interfaceUnit = parser.buildAst(ASTUtil.toVector(ilines), null);
	}
	
	[Test]
	public function testInterfaceSignature():void
	{
		// package
		Assert.assertNotNull(ASTUtil.getPackage(interfaceUnit));
		
		// package/name
		Assert.assertEquals("my.domain", ASTUtil.getPackageName(interfaceUnit));
		
		// package/content
		Assert.assertNotNull(ASTUtil.getPackageContent(interfaceUnit));
		
		// package/content/import
		var imports:Vector.<IParserNode> = ASTUtil.getImports(interfaceUnit);
		Assert.assertEquals(2, imports.length);
		Assert.assertEquals("my.other.domain.ITest", imports[0].stringValue);
		Assert.assertEquals("my.other.domain.IOtherTest", imports[1].stringValue);
		
		// package/content/interface
		var interfaceNode:IParserNode = ASTUtil.getType(interfaceUnit);
		Assert.assertNotNull(interfaceNode);
		
		// package/content/interface/as-doc
		var asdoc:IParserNode = ASTUtil.getAsDoc(interfaceNode);
		Assert.assertNotNull(asdoc);
		Assert.assertEquals("/** A nice interface. */", asdoc.stringValue);
		
		// package/content/interface/name
		Assert.assertEquals("ISmile", ASTUtil.getTypeName(interfaceUnit));
		
		// package/content/interface/meta-list
		var metas:Vector.<IParserNode> = ASTUtil.getTypeMetaData(interfaceUnit);
		Assert.assertEquals(1, metas.length);
		Assert.assertEquals("Bindable", metas[0].stringValue);
		
		Assert.assertEquals(2, ASTUtil.getGetProperties(interfaceUnit).length);
		Assert.assertEquals(1, ASTUtil.getSetProperties(interfaceUnit).length);
		Assert.assertEquals(3, ASTUtil.getProperties(interfaceUnit).length);
		
		Assert.assertEquals(1, ASTUtil.getMethods(interfaceUnit).length);
	}
	
	[Test]
	public function testClassSignature():void
	{
		// package
		Assert.assertNotNull(ASTUtil.getPackage(classUnit));
		
		// package/name
		Assert.assertEquals("my.domain", ASTUtil.getPackageName(classUnit));
		
		// package/content
		Assert.assertNotNull(ASTUtil.getPackageContent(classUnit));
		
		// package/content/import
		var imports:Vector.<IParserNode> = ASTUtil.getImports(classUnit);
		Assert.assertEquals(3, imports.length);
		Assert.assertEquals("my.other.domain.ITest", imports[0].stringValue);
		Assert.assertEquals("my.other.domain.IOtherTest", imports[1].stringValue);
		Assert.assertEquals("flash.utils.flash_proxy", imports[2].stringValue);
		
		// package/content/use
		var uses:Vector.<IParserNode> = ASTUtil.getUses(classUnit);
		Assert.assertEquals(1, uses.length);
		Assert.assertEquals("flash_proxy", uses[0].stringValue);
		
		// package/content/class
		var classNode:IParserNode = ASTUtil.getType(classUnit);
		Assert.assertNotNull(classNode);
		
		// package/content/class/as-doc
		Assert.assertNotNull(ASTUtil.getAsDoc(classNode));
		Assert.assertEquals("/** Class comment. */", ASTUtil.getAsDoc(classNode).stringValue);
		
		// package/content/class/name
		Assert.assertEquals("Test", ASTUtil.getTypeName(classUnit));
		
		// package/content/class/meta-list
		var metas:Vector.<IParserNode> = ASTUtil.getTypeMetaData(classUnit);
		Assert.assertEquals(2, metas.length);
		Assert.assertEquals("Event ( name = \"myEvent\" , type = \"flash.events.Event\" )", metas[0].stringValue);
		Assert.assertEquals("Style ( name = \"myStyle\" , type = \"String\" )", metas[1].stringValue);
		
		var asdoc:IParserNode = ASTUtil.getAsDoc(metas[0]);
		Assert.assertNotNull(asdoc);
		Assert.assertEquals("/** An event. */", asdoc.stringValue);
		
		asdoc = ASTUtil.getAsDoc(metas[1]);
		Assert.assertNotNull(asdoc);
		Assert.assertEquals("/** A style. */", asdoc.stringValue);
		
		// package/content/class/mod-list
		var modifiers:Vector.<IParserNode> = ASTUtil.getTypeModifiers(classUnit);
		Assert.assertEquals(2, modifiers.length);
		Assert.assertEquals("public", modifiers[0].stringValue);
		Assert.assertEquals("final", modifiers[1].stringValue);
		
		// package/content/class/extends
		var extendz:IParserNode = ASTUtil.getClassExtends(classUnit);
		Assert.assertNotNull(extendz);
		Assert.assertEquals("OtherTest", extendz.stringValue);
		
		// package/content/class/implements-list
		var implementz:Vector.<IParserNode> = ASTUtil.getClassImplements(classUnit);
		Assert.assertNotNull(implementz);
		Assert.assertEquals("ITest", implementz[0].stringValue);
		Assert.assertEquals("IOtherTest", implementz[1].stringValue);
		
		// package/content/class/content
		var classContentNode:IParserNode = ASTUtil.getTypeContent(classUnit);
		Assert.assertNotNull(classContentNode);
		
		// package/content/class/content/var-list[*]
		var variables:Vector.<IParserNode> = ASTUtil.getVariables(classUnit);
		Assert.assertEquals(3, variables.length);
		
		// package/content/class/content/function[*]
		var methods:Vector.<IParserNode> = ASTUtil.getMethods(classUnit);
		Assert.assertEquals(2, methods.length);
	}
	
	[Test]
	public function testClassConstants():void
	{
		// package/content/class/content/const-list[*]
		var constants:Vector.<IParserNode> = ASTUtil.getConstants(classUnit);
		Assert.assertEquals(1, constants.length);
		
		//------------------------------
		// public static const NAME:String = "fortyTwo";
		var asdoc:IParserNode = ASTUtil.getAsDoc(constants[0]);
		Assert.assertNotNull(asdoc);
		Assert.assertEquals("/** public constant */", asdoc.stringValue);
		
		var mods:Vector.<IParserNode> = ASTUtil.getModifiers(constants[0]);
		Assert.assertNotNull(mods);
		Assert.assertEquals(2, mods.length);
		Assert.assertEquals("public", mods[0].stringValue);
		Assert.assertEquals("static", mods[1].stringValue);
		
		var nti:IParserNode = ASTUtil.getNameTypeInit(constants[0]);
		Assert.assertNotNull(nti);
		Assert.assertEquals("NAME", nti.getChild(0).stringValue);
		Assert.assertEquals("String", nti.getChild(1).stringValue);
		Assert.assertEquals("\"fortyTwo\"", nti.getChild(2).getChild(0).stringValue);
	}
	
	[Test]
	public function testClassVariables():void
	{
		// package/content/class/content/var-list[*]
		var variables:Vector.<IParserNode> = ASTUtil.getVariables(classUnit);
		
		// package/content/class/content/var-list/asdoc
		
		//------------------------------
		// protected var test:int = 42;
		var asdoc:IParserNode = ASTUtil.getAsDoc(variables[0]);
		Assert.assertNotNull(asdoc);
		Assert.assertEquals("/** protected var */", asdoc.stringValue);
		
		// package/content/class/content/var-list/mod-list
		var mods:Vector.<IParserNode> = ASTUtil.getModifiers(variables[0]);
		Assert.assertNotNull(mods);
		Assert.assertEquals(1, mods.length);
		Assert.assertEquals("protected", mods[0].stringValue);
		
		// package/content/class/content/var-list/name-type-init
		var nti:IParserNode = ASTUtil.getNameTypeInit(variables[0]);
		Assert.assertNotNull(nti);
		Assert.assertEquals("test", nti.getChild(0).stringValue);
		Assert.assertEquals("int", nti.getChild(1).stringValue);
		Assert.assertEquals("42", nti.getChild(2).getChild(0).stringValue);
		
		//------------------------------
		// flash_proxy var testProxy:String = "422";
		asdoc = ASTUtil.getAsDoc(variables[2]);
		Assert.assertNotNull(asdoc);
		Assert.assertEquals("/** flash_proxy var */", asdoc.stringValue);
		
		mods = ASTUtil.getModifiers(variables[2]);
		Assert.assertNotNull(mods);
		Assert.assertEquals(2, mods.length);
		Assert.assertEquals("flash_proxy", mods[0].stringValue);
		Assert.assertEquals("static", mods[1].stringValue);
		
		nti = ASTUtil.getNameTypeInit(variables[2]);
		Assert.assertNotNull(nti);
		Assert.assertEquals("testProxy", nti.getChild(0).stringValue);
		Assert.assertEquals("String", nti.getChild(1).stringValue);
		Assert.assertEquals("\"422\"", nti.getChild(2).getChild(0).stringValue);
	}
	
	[Test]
	public function testClassMethods():void
	{
		// package/content/class/content/function[*]
		var methods:Vector.<IParserNode> = ASTUtil.getMethods(classUnit);
		
		//------------------------------
		// public final function finalMethod(arg0:Number, arg1:int = 42, ...restArg):Vector.<int>
		
		// package/content/class/content/function/as-doc
		var asdoc:IParserNode = ASTUtil.getAsDoc(methods[1]);
		Assert.assertNotNull(asdoc);
		Assert.assertEquals("/** A final method. */", asdoc.stringValue);
		
		// package/content/class/content/function/mod-list
		var mods:Vector.<IParserNode> = ASTUtil.getModifiers(methods[1]);
		Assert.assertNotNull(mods);
		Assert.assertEquals(2, mods.length);
		Assert.assertEquals("public", mods[0].stringValue);
		Assert.assertEquals("final", mods[1].stringValue);
		
		// package/content/class/content/function/name
		Assert.assertNotNull(ASTUtil.getNode(AS3NodeKind.NAME, methods[1]));
		Assert.assertEquals("finalMethod", ASTUtil.getNode(AS3NodeKind.NAME, methods[1]).stringValue);
		
		// package/content/class/content/function/parameter-list
		var parameters:Vector.<IParserNode> = ASTUtil.getParameters(methods[1]);
		Assert.assertNotNull(parameters);
		Assert.assertEquals(3, parameters.length);
		
		// package/content/class/content/function/parameter[*]/name-type-init
		var nti:IParserNode = ASTUtil.getNameTypeInit(parameters[0]);
		Assert.assertNotNull(nti);
		Assert.assertEquals(2, nti.numChildren);
		Assert.assertEquals("arg0", nti.getChild(0).stringValue);
		Assert.assertEquals("Number", nti.getChild(1).stringValue);
		
		nti = ASTUtil.getNameTypeInit(parameters[1]);
		Assert.assertEquals(3, nti.numChildren);
		Assert.assertEquals("arg1", nti.getChild(0).stringValue);
		Assert.assertEquals("int", nti.getChild(1).stringValue);
		Assert.assertEquals("42", nti.getChild(2).getChild(0).stringValue);
		
		var rest:IParserNode = parameters[2];
		Assert.assertTrue(ASTUtil.isParameterRest(rest));
		Assert.assertEquals("restArg", rest.getLastChild().stringValue);
		
		// package/content/class/content/function/type
		var methodType:IParserNode = ASTUtil.getMethodType(methods[0]);
		Assert.assertNotNull(methodType);
		Assert.assertEquals("String", methodType.stringValue);
		
		// package/content/class/content/function/vector
		methodType = ASTUtil.getMethodType(methods[1]);
		Assert.assertNotNull(methodType);
		Assert.assertEquals("int", methodType.getLastChild().stringValue);
	}
}
}