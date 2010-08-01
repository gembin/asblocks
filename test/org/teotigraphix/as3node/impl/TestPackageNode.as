package org.teotigraphix.as3node.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassNode;
import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.AttributeNode;
import org.teotigraphix.as3nodes.impl.CompilationNode;
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
		
		compilationNode = new CompilationNode(unit, null);
		packageNode = compilationNode.packageNode as PackageNode;
	}
	
	[Test]
	public function testPackageNode():void
	{
		Assert.assertNotNull(packageNode.node);
		Assert.assertEquals("my.domain", packageNode.name);
		Assert.assertEquals("my.domain.Test", packageNode.qualifiedName);
		Assert.assertNotNull(packageNode.typeNode);
		Assert.assertNotNull(packageNode.imports);
		Assert.assertEquals("flash.events.IEventDispatcher", packageNode.imports[0].stringValue);
	}
	
	[Test]
	public function testTypeNode():void
	{
		var typeNode:IClassNode = packageNode.typeNode as IClassNode;
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
		Assert.assertTrue(TypeNode(typeNode).isFinal);
		Assert.assertTrue(TypeNode(typeNode).isBindable);
		
		// metadata
		var meta:Vector.<IMetaDataNode>;
		Assert.assertEquals(6, typeNode.numMetaData);
		meta = typeNode.getMetaData("Bindable");
		Assert.assertStrictlyEquals(typeNode, meta[0].parent);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Bindable", meta[0].name);
		Assert.assertEquals("", meta[0].parameter);
		
		// events
		var events:Vector.<IMetaDataNode> = typeNode.getMetaData("Event");
		Assert.assertNotNull(events);
		Assert.assertEquals(1, events.length);
		Assert.assertEquals("Event", events[0].name);
		Assert.assertEquals("name = \"myEvent\" , type = \"flash.events.Event\"", events[0].parameter);
		
		// styles
		var styles:Vector.<IMetaDataNode> = typeNode.getMetaData("Style");
		Assert.assertNotNull(styles);
		Assert.assertEquals(1, styles.length);
		Assert.assertEquals("Style", styles[0].name);
		Assert.assertEquals("name = \"myStyle\" , type = \"Number\"", styles[0].parameter);
		
		//skinstate
		var states:Vector.<IMetaDataNode> = typeNode.getMetaData("SkinState");
		Assert.assertNotNull(states);
		Assert.assertEquals(1, states.length);
		Assert.assertEquals("SkinState", states[0].name);
		Assert.assertEquals("\"up\"", states[0].parameter);
		
		meta = typeNode.getMetaData("Factory");
		Assert.assertStrictlyEquals(typeNode, meta[0].parent);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Factory", meta[0].name);
		Assert.assertEquals("type = \"my.factory.Class\"", meta[0].parameter);
		
		// name
		Assert.assertEquals("Test", typeNode.name);
		Assert.assertEquals("my.domain", IPackageNode(typeNode.parent).name);
		Assert.assertEquals("my.domain.Test", IPackageNode(typeNode.parent).qualifiedName);
		
		// extends
		Assert.assertNotNull(typeNode.superType);
		Assert.assertEquals("OtherTest", typeNode.superType.toString());
		
		// implements
		Assert.assertNotNull(typeNode.implementList);
		Assert.assertEquals(2, typeNode.implementList.length);
		Assert.assertEquals("IEventDispatcher", typeNode.implementList[0].toString());
		Assert.assertEquals("my.domain.ITest", typeNode.implementList[1].toString());
	}
	
	[Test]
	public function testConstantNode():void
	{
		var constants:Vector.<IConstantNode> = IClassNode(packageNode.typeNode).constants;
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
		var attributes:Vector.<IAttributeNode> = IClassNode(packageNode.typeNode).attributes;
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
		var getters:Vector.<IAccessorNode> = packageNode.typeNode.getters;
		var setters:Vector.<IAccessorNode> = packageNode.typeNode.setters;
		
		Assert.assertNotNull(getters);
		Assert.assertNotNull(setters);
		
		Assert.assertEquals(1, getters.length);
		Assert.assertEquals(1, getters.length);
		
		Assert.assertEquals("property", getters[0].name);
	}
	
	[Test]
	public function testFunctionNode():void
	{
		
	}
}
}