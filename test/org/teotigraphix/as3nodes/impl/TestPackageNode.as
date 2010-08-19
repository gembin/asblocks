package org.teotigraphix.as3nodes.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3nodes.api.Access;
import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IBlockCommentNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3Parser;
import org.teotigraphix.as3parser.utils.ASTUtil;

// TODO The tests in this file do not belong, need to only test package specific traits

public class TestPackageNode
{
	private var unit:IParserNode;
	
	private var parser:AS3Parser;
	
	private var compilationNode:CompilationNode;
	
	private var packageNode:PackageNode;
	
	[Test]
	public function test_typeNode():void
	{
		var element:PackageNode = createPackage("my.domain");
		
		Assert.assertNull(element.typeNode);
		
		var typeNode:ITypeNode = element.newClass("TestClass");
		
		Assert.assertNotNull(typeNode);
		Assert.assertNotNull(element.typeNode);
		Assert.assertStrictlyEquals(element.typeNode, typeNode);
		
		Assert.assertEquals("my.domain", element.name);
		Assert.assertEquals("my.domain.TestClass", element.qualifiedName);
		Assert.assertEquals("my.domain", element.typeNode.packageName);
		Assert.assertEquals("my.domain.TestClass", element.typeNode.qualifiedName);
		
		Assert.assertTrue(typeNode.isPublic);
	}
	
	[Test]
	public function test_qualifiedName():void
	{
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newClass("TestClass");
		
		Assert.assertNotNull(typeNode);
		
		Assert.assertEquals("my.domain.TestClass", element.qualifiedName);
	}
	
	[Test]
	public function test_blockComment():void
	{
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newClass("TestClass");
		
		var blockComment:IBlockCommentNode = element.newBlockComment(
			"This is a package level block comment.", true);
		
		Assert.assertNotNull(element.blockComment);
		Assert.assertEquals("This is a package level block comment.", element.blockComment.description);
		Assert.assertTrue(blockComment.wrap);
		
		Assert.assertStrictlyEquals(element, blockComment.parent);
		Assert.assertTrue(element.node.hasKind(AS3NodeKind.BLOCK_DOC));
		
		element.setBlockComment(null);
		Assert.assertFalse(element.node.hasKind(AS3NodeKind.BLOCK_DOC));
	}
	
	[Test]
	public function test_imports():void
	{
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newClass("TestClass");
		
		Assert.assertNotNull(typeNode);
		Assert.assertNotNull(element.imports);
		Assert.assertEquals(0, element.imports.length);
	}
	
	[Test]
	public function test_newImport():void
	{
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newClass("TestClass");
		
		var import1:IIdentifierNode = element.newImport("my.domain.Test1");
		Assert.assertNotNull(import1);
		Assert.assertTrue(import1.node.isKind(AS3NodeKind.IMPORT));
		var import2:IIdentifierNode = element.newImport("my.domain.Test2");
		Assert.assertNotNull(import2);
		Assert.assertTrue(import2.node.isKind(AS3NodeKind.IMPORT));
		var import3:IIdentifierNode = element.newImport("my.domain.Test3");
		Assert.assertNotNull(import3);
		Assert.assertTrue(import3.node.isKind(AS3NodeKind.IMPORT));
		var import4:IIdentifierNode = element.newImport("my.domain.Test4");
		Assert.assertNotNull(import4);
		Assert.assertTrue(import4.node.isKind(AS3NodeKind.IMPORT));
		
		Assert.assertEquals(4, element.imports.length);
		
		// test duplicate rejections
		var import5:IIdentifierNode = element.newImport("my.domain.Test4");
		Assert.assertNotNull(import5);
		
		Assert.assertEquals(4, element.imports.length);
	}
	
	private function createPackage(name:String):PackageNode
	{
		var ast:IParserNode = ASTNodeUtil.createPackage(
			IdentifierNode.createType(name));
		var element:PackageNode = new PackageNode(ast, null);
		return element;
	}
	
	[Test]
	public function test_hasImport():void
	{
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newClass("TestClass");
		
		var import1:IIdentifierNode = element.newImport("my.domain.Test1");
		Assert.assertNotNull(import1);
		var import2:IIdentifierNode = element.newImport("my.domain.Test2");
		Assert.assertNotNull(import2);
		var import3:IIdentifierNode = element.newImport("my.domain.Test3");
		Assert.assertNotNull(import3);
		var import4:IIdentifierNode = element.newImport("my.domain.Test4");
		Assert.assertNotNull(import4);
		
		Assert.assertEquals(4, element.imports.length);
		Assert.assertTrue(element.hasImport("my.domain.Test1"));
		Assert.assertTrue(element.hasImport("my.domain.Test2"));
		Assert.assertTrue(element.hasImport("my.domain.Test3"));
		Assert.assertTrue(element.hasImport("my.domain.Test4"));
		Assert.assertFalse(element.hasImport("my.domain.Test5"));
	}
	
	[Test]
	public function test_addImport():void
	{
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newClass("TestClass");
		
		var import1:IIdentifierNode = NodeFactory.instance.
			createIdentifier(ASTNodeUtil.createName("my.domain.Test1"), null);
		var import2:IIdentifierNode = NodeFactory.instance.
			createIdentifier(ASTNodeUtil.createName("my.domain.Test2"), null);
		var import3:IIdentifierNode = NodeFactory.instance.
			createIdentifier(ASTNodeUtil.createName("my.domain.Test3"), null);
		
		Assert.assertNotNull(element.addImport(import1));
		Assert.assertNotNull(element.addImport(import2));
		Assert.assertNull(element.addImport(import2));
		Assert.assertNotNull(element.addImport(import3));
		Assert.assertNull(element.addImport(import3));
		
		Assert.assertStrictlyEquals(import1.parent, element);
		Assert.assertStrictlyEquals(import2.parent, element);
		Assert.assertStrictlyEquals(import3.parent, element);
		
		Assert.assertEquals(3, element.imports.length);
		Assert.assertTrue(element.hasImport("my.domain.Test1"));
		Assert.assertTrue(element.hasImport("my.domain.Test2"));
		Assert.assertTrue(element.hasImport("my.domain.Test3"));
	}
	
	[Test]
	public function test_removeImport():void
	{
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newClass("TestClass");
		
		var element2:PackageNode = createPackage("my.domain2");
		
		var import1:IIdentifierNode = element.newImport("my.domain.Test1");
		var import2:IIdentifierNode = element.newImport("my.domain.Test2");
		var import3:IIdentifierNode = element.newImport("my.domain.Test3");
		var import4:IIdentifierNode = element2.newImport("my.domain.Test4");
		
		Assert.assertEquals(3, element.imports.length);
		
		Assert.assertNotNull(element.removeImport(import1));
		Assert.assertNotNull(element.removeImport(import2));
		Assert.assertNotNull(element.removeImport(import3));
		Assert.assertNull(element.removeImport(import4));
		
		Assert.assertEquals(0, element.imports.length);
		
		Assert.assertNull(import1.parent);
		Assert.assertNull(import2.parent);
		Assert.assertNull(import3.parent);
	}
	
	[Test]
	public function test_newClass():void
	{
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newClass("TestClass");
		
		Assert.assertEquals(AS3NodeKind.CLASS, typeNode.node.kind);
		
		Assert.assertNotNull(typeNode);
		Assert.assertTrue(typeNode.isPublic);
		Assert.assertEquals("TestClass", typeNode.name);
		Assert.assertEquals("my.domain", typeNode.packageName);
		Assert.assertEquals("my.domain.TestClass", typeNode.qualifiedName);
		
		Assert.assertStrictlyEquals(element, typeNode.parent);
		
		element = createPackage("");
		typeNode = element.newClass("TestTopLevelClass");
		
		Assert.assertNotNull(typeNode);
		Assert.assertEquals("TestTopLevelClass", typeNode.name);
		Assert.assertEquals("", typeNode.packageName);
		Assert.assertEquals("TestTopLevelClass", typeNode.qualifiedName);
	}
	
	[Test]
	public function test_newInterface():void
	{
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newInterface("ITestInterface");
		
		Assert.assertEquals(AS3NodeKind.INTERFACE, typeNode.node.kind);
		
		Assert.assertNotNull(typeNode);
		Assert.assertTrue(typeNode.isPublic);
		Assert.assertEquals("ITestInterface", typeNode.name);
		Assert.assertEquals("my.domain", typeNode.packageName);
		Assert.assertEquals("my.domain.ITestInterface", typeNode.qualifiedName);
		
		Assert.assertStrictlyEquals(element, typeNode.parent);
		
		element = createPackage("");
		typeNode = element.newClass("ITestTopLevelInterface");
		
		Assert.assertNotNull(typeNode);
		Assert.assertEquals("ITestTopLevelInterface", typeNode.name);
		Assert.assertEquals("", typeNode.packageName);
		Assert.assertEquals("ITestTopLevelInterface", typeNode.qualifiedName);
	}
	
	[Test]
	public function test_newFunction():void
	{
		// TODO Need top check the children of this since it's actually
		// a function node with no CONTENT only a BLOCK
		var element:PackageNode = createPackage("my.domain");
		var typeNode:ITypeNode = element.newFunction("myGlobalFunction");
		
		Assert.assertEquals(AS3NodeKind.FUNCTION, typeNode.node.kind);
		
		Assert.assertNotNull(typeNode);
		Assert.assertTrue(typeNode.isPublic);
		Assert.assertEquals("myGlobalFunction", typeNode.name);
		Assert.assertEquals("my.domain", typeNode.packageName);
		Assert.assertEquals("my.domain.myGlobalFunction", typeNode.qualifiedName);
		
		Assert.assertStrictlyEquals(element, typeNode.parent);
		
		element = createPackage("");
		typeNode = element.newClass("myGlobalFunction");
		
		Assert.assertNotNull(typeNode);
		Assert.assertEquals("myGlobalFunction", typeNode.name);
		Assert.assertEquals("", typeNode.packageName);
		Assert.assertEquals("myGlobalFunction", typeNode.qualifiedName);
	}
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
		
		var lines:Array =
			[
				"package my.domain {",
				"    import flash.events.IEventDispatcher",
				"    [Bindable]",
				"    [Factory(type=\"my.factory.Class\")]",
				"    /** An event. */",
				"    [Event(name=\"myEvent\",type=\"flash.events.Event\")]",
				"    /** An style. */",
				"    [Style(name=\"myStyle\",type=\"Number\")]",
				"    /** An effect. */",
				"    [Effect(name=\"myEffect\",event=\"myEvent\")]",
				"    /** An state. */",
				"    [SkinState(\"up\")]",
				"    /**",
				"     * Class comment.",
				"     * ",
				"     * <p>A long description spanning two separate",
				"     * comment lines with text.<p>",
				"     * ",
				"     * @author Michael Schmalle",
				"     * @since 1.0",
				"     */",
				"    public final class Test extends OtherTest ",
				"        implements IEventDispatcher, my.domain.ITest",
				"    {",
				"        [Bindable]",
				"        /** ",
				"         * A constant comment.",
				"         * <p>Long description.</p>",
				"         * @see my.Class",
				"         * @private",
				"         */",
				"        public static const NAME:String = \"smile\";",
				"        [Inject(source=\"model.dataProvider\")]",
				"        public var variable:String = \"variable\";",
				"        /** @private */",
				"        public var variable2:int = 420;",
				"        /** A property. */",
				"        public function get property():String{return null;}",
				"        /** @private */",
				"        public function set property(value:String):void{}",
				"        [Test(description=\"Hello World\")]",
				"        /** ",
				"         * A method comment.",
				"         * <p>Long description.</p>",
				"         * @param arg0 The argument one.",
				"         * @param rest The rest of the arguments.",
				"         * @return A Number.",
				"         */",
				"        public static function method(arg0:int=1,...rest):Number",
				"        {",
				"            return 42;",
				"        }",
				"        /** ",
				"         * Constructor.",
				"         */",
				"        public function Test()",
				"        {",
				"            super();",
				"        }",
				"    }",
				"}",
			];
		
		unit = parser.buildAst(ASTUtil.toVector(lines), "internal");
		
		compilationNode = new CompilationNode(unit, null);
		packageNode = compilationNode.packageNode as PackageNode;
	}
	
	[Test]
	public function test_addRemoveImports():void
	{
		//var node:PackageNode = new PackageNode(null, null);
		
	}
	
	[Test]
	public function testPackageNode():void
	{
		Assert.assertNotNull(packageNode.node);
		Assert.assertEquals("my.domain", packageNode.name);
		Assert.assertEquals("my.domain.Test", packageNode.qualifiedName);
		Assert.assertNotNull(packageNode.typeNode);
		Assert.assertNotNull(packageNode.imports);
		Assert.assertEquals("flash.events.IEventDispatcher", packageNode.imports[0].qualifiedName);
	}
	
	[Test]
	public function testTypeNode():void
	{
		var typeNode:IClassTypeNode = packageNode.typeNode as IClassTypeNode;
		Assert.assertNotNull(typeNode);
		Assert.assertStrictlyEquals(packageNode, typeNode.parent);
		
		// comment
		var comment:ICommentNode = typeNode.comment;
		Assert.assertNotNull(comment);
		Assert.assertEquals("Class comment.", comment.shortDescription);
		Assert.assertEquals("<p>A long description spanning two separate comment lines with text.<p>", comment.longDescription);
		Assert.assertNotNull(comment.docTags);
		Assert.assertEquals("author", comment.docTags[0].name);
		Assert.assertEquals("Michael Schmalle", comment.docTags[0].body);
		Assert.assertEquals("since", comment.docTags[1].name);
		Assert.assertEquals("1.0", comment.docTags[1].body);
		
		// modifiers
		Assert.assertTrue(typeNode.hasModifier(Modifier.PUBLIC));
		Assert.assertTrue(typeNode.hasModifier(Modifier.FINAL));
		Assert.assertFalse(typeNode.hasModifier(Modifier.DYNAMIC));
		
		Assert.assertTrue(typeNode.isPublic);
		Assert.assertTrue(typeNode.isFinal);
		Assert.assertTrue(TypeNode(typeNode).isBindable);
		
		// metadata
		var meta:Vector.<IMetaDataNode>;
		Assert.assertEquals(6, typeNode.numMetaData);
		meta = typeNode.getAllMetaData("Bindable");
		Assert.assertStrictlyEquals(typeNode, meta[0].parent);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Bindable", meta[0].name);
		Assert.assertEquals("", meta[0].parameter);
		
		// events
		var events:Vector.<IMetaDataNode> = typeNode.getAllMetaData("Event");
		Assert.assertNotNull(events);
		Assert.assertEquals(1, events.length);
		Assert.assertEquals("Event", events[0].name);
		Assert.assertEquals("name = \"myEvent\" , type = \"flash.events.Event\"", events[0].parameter);
		
		// styles
		var styles:Vector.<IMetaDataNode> = typeNode.getAllMetaData("Style");
		Assert.assertNotNull(styles);
		Assert.assertEquals(1, styles.length);
		Assert.assertEquals("Style", styles[0].name);
		Assert.assertEquals("name = \"myStyle\" , type = \"Number\"", styles[0].parameter);
		
		//skinstate
		var states:Vector.<IMetaDataNode> = typeNode.getAllMetaData("SkinState");
		Assert.assertNotNull(states);
		Assert.assertEquals(1, states.length);
		Assert.assertEquals("SkinState", states[0].name);
		Assert.assertEquals("\"up\"", states[0].parameter);
		
		meta = typeNode.getAllMetaData("Factory");
		Assert.assertStrictlyEquals(typeNode, meta[0].parent);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Factory", meta[0].name);
		Assert.assertEquals("type = \"my.factory.Class\"", meta[0].parameter);
		
		// name
		Assert.assertEquals("Test", typeNode.name);
		Assert.assertEquals("my.domain", IPackageNode(typeNode.parent).name);
		Assert.assertEquals("my.domain.Test", IPackageNode(typeNode.parent).qualifiedName);
		
		// extends
		Assert.assertNotNull(typeNode.superClass);
		Assert.assertEquals("OtherTest", typeNode.superClass.localName);
		
		// implements
		Assert.assertNotNull(typeNode.implementList);
		Assert.assertEquals(2, typeNode.implementList.length);
		Assert.assertEquals("IEventDispatcher", typeNode.implementList[0].localName);
		Assert.assertEquals("ITest", typeNode.implementList[1].localName);
		Assert.assertEquals("my.domain", typeNode.implementList[1].packageName);
		Assert.assertEquals("my.domain.ITest", typeNode.implementList[1].qualifiedName);
	}
	
	[Test]
	public function testConstantNode():void
	{
		var constants:Vector.<IConstantNode> = IClassTypeNode(packageNode.typeNode).constants;
		Assert.assertNotNull(constants);
		Assert.assertEquals(1, constants.length);
		
		// modifiers
		Assert.assertTrue(constants[0].hasModifier(Modifier.PUBLIC));
		Assert.assertTrue(constants[0].hasModifier(Modifier.STATIC));
		
		Assert.assertTrue(constants[0].isPublic);
		//		Assert.assertTrue(constants[0].isStatic);
		Assert.assertTrue(ConstantNode(constants[0]).isBindable);
		
		Assert.assertEquals("NAME", constants[0].name);
		Assert.assertEquals("String", constants[0].type.localName);
		
		var comment:ICommentNode = constants[0].comment;
		Assert.assertNotNull(comment);
		Assert.assertEquals("A constant comment.", comment.shortDescription);
		Assert.assertEquals("<p>Long description.</p>", comment.longDescription);
		
		Assert.assertNotNull(comment.docTags);
		Assert.assertEquals(2, comment.docTags.length);
		Assert.assertEquals("see", comment.docTags[0].name);
		Assert.assertEquals("my.Class", comment.docTags[0].body);
		
		Assert.assertEquals("private", comment.docTags[1].name);
	}
	
	[Test]
	public function testAttributeNode():void
	{
		var attributes:Vector.<IAttributeNode> = IClassTypeNode(packageNode.typeNode).attributes;
		Assert.assertNotNull(attributes);
		Assert.assertEquals(2, attributes.length);
		
		// modifiers
		Assert.assertTrue(attributes[0].hasModifier(Modifier.PUBLIC));
		Assert.assertTrue(attributes[1].hasModifier(Modifier.PUBLIC));
		
		Assert.assertTrue(attributes[0].isPublic);
		//		Assert.assertFalse(attributes[0].isStatic);
		Assert.assertFalse(AttributeNode(attributes[0]).isBindable);
		
		Assert.assertEquals("variable", attributes[0].name);
		Assert.assertEquals("String", attributes[0].type.localName);
		
		Assert.assertEquals("variable2", attributes[1].name);
		Assert.assertEquals("int", attributes[1].type.localName);
		
		var comment:ICommentNode = attributes[0].comment;
		Assert.assertNotNull(comment);
		Assert.assertFalse(comment.hasDescription);
		
		comment = attributes[1].comment;
		Assert.assertNotNull(comment);
		Assert.assertTrue(comment.hasDescription);
		
		Assert.assertNotNull(comment.docTags);
		Assert.assertEquals(1, comment.docTags.length);
		Assert.assertEquals("private", comment.docTags[0].name);
	}
	
	[Test]
	public function testAccessorNode():void
	{
		var getters:Vector.<IAccessorNode> = packageNode.typeNode.getters;
		var setters:Vector.<IAccessorNode> = packageNode.typeNode.setters;
		
		Assert.assertNotNull(getters);
		Assert.assertNotNull(setters);
		
		Assert.assertEquals(1, getters.length);
		Assert.assertEquals(1, setters.length);
		
		Assert.assertEquals("property", getters[0].name);
		Assert.assertEquals("property", setters[0].name);
		
		Assert.assertEquals(Access.READ, getters[0].access);
		Assert.assertEquals(Access.WRITE, setters[0].access);
	}
	
	[Test]
	public function testFunctionNode():void
	{
		var methods:Vector.<IMethodNode> = packageNode.typeNode.methods;
		Assert.assertNotNull(methods);
		Assert.assertEquals(2, methods.length);
		
		// public function method(arg0:int=1,...rest):Number
		var method:IMethodNode = methods[0];
		Assert.assertNotNull(method);
		
		// metadata
		var meta:Vector.<IMetaDataNode>;
		Assert.assertEquals(1, method.numMetaData);
		meta = method.getAllMetaData("Test");
		Assert.assertStrictlyEquals(method, meta[0].parent);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Test", meta[0].name);
		Assert.assertEquals("description = \"Hello World\"", meta[0].parameter);
		
		// comment
		var comment:ICommentNode = method.comment;
		Assert.assertNotNull(comment);
		Assert.assertEquals("A method comment.", comment.shortDescription);
		Assert.assertEquals("<p>Long description.</p>", comment.longDescription);
		
		Assert.assertNotNull(comment.docTags);
		Assert.assertEquals(3, comment.docTags.length);
		Assert.assertEquals("param", comment.docTags[0].name);
		Assert.assertEquals("arg0 The argument one.", comment.docTags[0].body);
		Assert.assertEquals("param", comment.docTags[1].name);
		Assert.assertEquals("rest The rest of the arguments.", comment.docTags[1].body);
		Assert.assertEquals("return", comment.docTags[2].name);
		Assert.assertEquals("A Number.", comment.docTags[2].body);
		
		// modifiers
		Assert.assertNotNull(method.modifiers);
		Assert.assertEquals(2, method.modifiers.length);
		Assert.assertTrue(method.isPublic);
		Assert.assertTrue(method.isStatic);
		Assert.assertTrue(method.hasModifier(Modifier.PUBLIC));
		Assert.assertTrue(method.hasModifier(Modifier.STATIC));
		
		// paramters
		Assert.assertTrue(method.hasParameters);
		Assert.assertNotNull(method.parameters);
		Assert.assertEquals(2, method.parameters.length);
		
		Assert.assertEquals("arg0", method.parameters[0].name);
		Assert.assertEquals("int", method.parameters[0].type.localName);
		Assert.assertEquals("1", method.parameters[0].value);
		Assert.assertTrue(method.parameters[0].hasType);
		Assert.assertTrue(method.parameters[0].hasValue);
		
		Assert.assertEquals("rest", method.parameters[1].name);
		Assert.assertTrue(method.parameters[1].isRest);
		Assert.assertFalse(method.parameters[1].hasType);
		Assert.assertFalse(method.parameters[1].hasValue);
		
		// type
		Assert.assertTrue(method.hasType);
		Assert.assertEquals("Number", method.type.localName);
		
		// public function Test()
		method = methods[1];
		Assert.assertNotNull(method);
		Assert.assertTrue(method.isConstructor);
		
		// modifiers
		Assert.assertNotNull(method.modifiers);
		Assert.assertEquals(1, method.modifiers.length);
		Assert.assertTrue(method.isPublic);
		Assert.assertTrue(method.hasModifier(Modifier.PUBLIC));
		
		// paramters
		Assert.assertFalse(method.hasParameters);
		Assert.assertNotNull(method.parameters);
		
		// type
		Assert.assertFalse(method.hasType);
	}
}
}