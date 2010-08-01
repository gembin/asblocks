package org.teotigraphix.as3node.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.AttributeNode;
import org.teotigraphix.as3nodes.impl.ConstantNode;
import org.teotigraphix.as3nodes.impl.PackageNode;
import org.teotigraphix.as3nodes.impl.TypeNode;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3Parser;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestPackageNode
{
	private var unit:IParserNode;
	
	private var parser:AS3Parser;
	
	private var packageNode:PackageNode;
	
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
				"    /** Class comment. */",
				"    public final class Test extends OtherTest implements IEventDispatcher",
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
				"        public function get property():String{return null;}",
				"        public function set property(value:String):void{}",
				"        [Test]",
				"        public function method():void",
				"        {",
				"        }",
				"    }",
				"}",
			];
		
		unit = parser.buildAst(ASTUtil.toVector(lines), "internal");
		
		packageNode = new PackageNode(unit, null);
	}
	
	[Test]
	public function testPackageNode():void
	{
		Assert.assertNotNull(packageNode.node);
		Assert.assertEquals("my.domain", packageNode.name);
		Assert.assertEquals("my.domain.Test", packageNode.qualifiedName);
		Assert.assertNotNull(packageNode.typeNode);
		Assert.assertNotNull(packageNode.imports);
	}
	
	[Test]
	public function testTypeNode():void
	{
		var typeNode:TypeNode = packageNode.typeNode as TypeNode;
		Assert.assertNotNull(typeNode);
		Assert.assertStrictlyEquals(packageNode, typeNode.parent);
		
		// modifiers
		Assert.assertTrue(typeNode.hasModifier(Modifier.PUBLIC));
		Assert.assertTrue(typeNode.hasModifier(Modifier.FINAL));
		Assert.assertFalse(typeNode.hasModifier(Modifier.DYNAMIC));
		
		Assert.assertTrue(typeNode.isPublic);
		Assert.assertTrue(typeNode.isFinal);
		Assert.assertTrue(typeNode.isBindable);
		
		// metadata
		var meta:Vector.<IMetaDataNode>;
		Assert.assertEquals(2, typeNode.numMetaData);
		meta = typeNode.getMetaData("Bindable");
		Assert.assertStrictlyEquals(typeNode, meta[0].parent);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Bindable", meta[0].name);
		Assert.assertEquals("", meta[0].parameter);
		
		meta = typeNode.getMetaData("Factory");
		Assert.assertStrictlyEquals(typeNode, meta[0].parent);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Factory", meta[0].name);
		Assert.assertEquals("type = \"my.factory.Class\"", meta[0].parameter);
		
		// name
		Assert.assertEquals("Test", typeNode.name);
		Assert.assertEquals("my.domain", IPackageNode(typeNode.parent).name);
		Assert.assertEquals("my.domain.Test", IPackageNode(typeNode.parent).qualifiedName);
	}
	
	[Test]
	public function testConstantNode():void
	{
		var constants:Vector.<IConstantNode> = packageNode.typeNode.constants;
		Assert.assertNotNull(constants);
		Assert.assertEquals(1, constants.length);
		
		// modifiers
		Assert.assertTrue(constants[0].hasModifier(Modifier.PUBLIC));
		Assert.assertTrue(constants[0].hasModifier(Modifier.STATIC));
		
		Assert.assertTrue(constants[0].isPublic);
		Assert.assertTrue(constants[0].isStatic);
		Assert.assertTrue(ConstantNode(constants[0]).isBindable);
		
		Assert.assertEquals("NAME", constants[0].name);
		Assert.assertEquals("String", constants[0].type.toString());
		
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
		var attributes:Vector.<IAttributeNode> = packageNode.typeNode.attributes;
		Assert.assertNotNull(attributes);
		Assert.assertEquals(2, attributes.length);
		
		// modifiers
		Assert.assertTrue(attributes[0].hasModifier(Modifier.PUBLIC));
		Assert.assertTrue(attributes[1].hasModifier(Modifier.PUBLIC));
		
		Assert.assertTrue(attributes[0].isPublic);
		Assert.assertFalse(attributes[0].isStatic);
		Assert.assertFalse(AttributeNode(attributes[0]).isBindable);
		
		Assert.assertEquals("variable", attributes[0].name);
		Assert.assertEquals("String", attributes[0].type.toString());
		
		Assert.assertEquals("variable2", attributes[1].name);
		Assert.assertEquals("int", attributes[1].type.toString());
		
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
		
	}
	
	[Test]
	public function testFunctionNode():void
	{
		
	}
}
}