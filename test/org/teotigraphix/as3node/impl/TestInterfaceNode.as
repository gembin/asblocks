package org.teotigraphix.as3node.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.CompilationNode;
import org.teotigraphix.as3nodes.impl.TypeNode;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3Parser;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestInterfaceNode
{
	private var parser:AS3Parser;
	
	private var compilationNode:ICompilationNode;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
		
		var lines:Array =
			[
				"package my.domain {",
				"    import flash.events.IEventDispatcher",
				"    [Deprecated]",
				"    [Bindable]",
				"    /**",
				"     * An interface.",
				"     * ",
				"     * <p>A long description spanning two separate",
				"     * comment lines with text.<p>",
				"     * ",
				"     * @author Michael Schmalle",
				"     * @since 1.0",
				"     */",
				"    public interface ITest extends IOtherTest, IEventDispatcher",
				"    {",
				"        [Bindable]",
				"        /** A property. */",
				"        function get property():String;",
				"        /** @private */",
				"        function set property(value:String):void;",
				"        [Deprecated]",
				"        [Inject]",
				"        /** ",
				"         * A method comment.",
				"         * <p>Long description.</p>",
				"         * @param arg0 The argument one.",
				"         * @param rest The rest of the arguments.",
				"         * @return A Number.",
				"         */",
				"        function method(arg0:int=1,...rest):Number;",
				"    }",
				"}"
			];
		
		var unit:IParserNode = parser.buildAst(ASTUtil.toVector(lines), "internal");
		
		compilationNode = new CompilationNode(unit, null);
	}
	
	[Test]
	public function testPackageNode():void
	{
		var packageNode:IPackageNode = compilationNode.packageNode;
		
		Assert.assertNotNull(packageNode.node);
		Assert.assertEquals("my.domain", packageNode.name);
		Assert.assertEquals("my.domain.ITest", packageNode.qualifiedName);
		Assert.assertNotNull(packageNode.typeNode);
		Assert.assertNotNull(packageNode.imports);
		Assert.assertEquals("flash.events.IEventDispatcher", packageNode.imports[0].stringValue);
	}
	
	[Test]
	public function testTypeNode():void
	{
		var packageNode:IPackageNode = compilationNode.packageNode;
		var typeNode:IInterfaceTypeNode = packageNode.typeNode as IInterfaceTypeNode;
		
		Assert.assertNotNull(typeNode);
		Assert.assertStrictlyEquals(packageNode, typeNode.parent);
		
		// comment
		var comment:ICommentNode = typeNode.comment;
		Assert.assertNotNull(comment);
		Assert.assertEquals("An interface.", comment.shortDescription);
		Assert.assertEquals("<p>A long description spanning two separate comment lines with text.<p>", comment.longDescription);
		Assert.assertNotNull(comment.docTags);
		Assert.assertEquals("author", comment.docTags[0].name);
		Assert.assertEquals("Michael Schmalle", comment.docTags[0].body);
		Assert.assertEquals("since", comment.docTags[1].name);
		Assert.assertEquals("1.0", comment.docTags[1].body);
		
		// modifiers
		Assert.assertTrue(typeNode.hasModifier(Modifier.PUBLIC));
		
		Assert.assertTrue(typeNode.isPublic);
		Assert.assertFalse(TypeNode(typeNode).isFinal);
		Assert.assertTrue(TypeNode(typeNode).isBindable);
		
		// metadata
		var meta:Vector.<IMetaDataNode>;
		Assert.assertEquals(2, typeNode.numMetaData);
		Assert.assertTrue(typeNode.isDeprecated);
		meta = typeNode.getMetaData("Bindable");
		Assert.assertStrictlyEquals(typeNode, meta[0].parent);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Bindable", meta[0].name);
		Assert.assertEquals("", meta[0].parameter);
		
		// name
		Assert.assertEquals("ITest", typeNode.name);
		Assert.assertEquals("my.domain", IPackageNode(typeNode.parent).name);
		Assert.assertEquals("my.domain.ITest", IPackageNode(typeNode.parent).qualifiedName);
		
		// extends
		Assert.assertNotNull(typeNode.superTypeList);
		Assert.assertEquals(2, typeNode.superTypeList.length);
		Assert.assertEquals("IOtherTest", typeNode.superTypeList[0].name);
		Assert.assertEquals("IEventDispatcher", typeNode.superTypeList[1].name);
	}
	
	[Test]
	public function testAccessorNode():void
	{
		var packageNode:IPackageNode = compilationNode.packageNode;
		
		var getters:Vector.<IAccessorNode> = packageNode.typeNode.getters;
		var setters:Vector.<IAccessorNode> = packageNode.typeNode.setters;
		
		Assert.assertNotNull(getters);
		Assert.assertNotNull(setters);
		
		Assert.assertEquals(1, getters.length);
		Assert.assertEquals(1, setters.length);
		
		Assert.assertEquals("property", getters[0].name);
		Assert.assertEquals("property", setters[0].name);
		
		Assert.assertEquals("get", getters[0].access);
		Assert.assertEquals("set", setters[0].access);
	}
	
	[Test]
	public function testFunctionNode():void
	{
		var packageNode:IPackageNode = compilationNode.packageNode;
		
		var methods:Vector.<IMethodNode> = packageNode.typeNode.methods;
		Assert.assertNotNull(methods);
		Assert.assertEquals(1, methods.length);
		
		// function method(arg0:int=1,...rest):Number;
		var method:IMethodNode = methods[0];
		Assert.assertNotNull(method);
		
		// metadata
		var meta:Vector.<IMetaDataNode>;
		Assert.assertEquals(2, method.numMetaData);
		Assert.assertTrue(method.isDeprecated);
		meta = method.getMetaData("Inject");
		Assert.assertStrictlyEquals(method, meta[0].parent);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Inject", meta[0].name);
		
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
		Assert.assertEquals(0, method.modifiers.length);
		
		// paramters
		Assert.assertTrue(method.hasParameters);
		Assert.assertNotNull(method.parameters);
		Assert.assertEquals(2, method.parameters.length);
		
		Assert.assertEquals("arg0", method.parameters[0].name);
		Assert.assertEquals("int", method.parameters[0].type.name);
		Assert.assertEquals("1", method.parameters[0].value);
		Assert.assertTrue(method.parameters[0].hasType);
		Assert.assertTrue(method.parameters[0].hasValue);
		
		Assert.assertEquals("rest", method.parameters[1].name);
		Assert.assertTrue(method.parameters[1].isRest);
		Assert.assertFalse(method.parameters[1].hasType);
		Assert.assertFalse(method.parameters[1].hasValue);
		
		// type
		Assert.assertTrue(method.hasType);
		Assert.assertEquals("Number", method.type.name);
	}
}
}