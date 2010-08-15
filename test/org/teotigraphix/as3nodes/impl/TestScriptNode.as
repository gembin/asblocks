package org.teotigraphix.as3nodes.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.MetaData;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.Node;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestScriptNode
{
	[Before]
	public function setUp():void
	{
	}
	
	[Test]
	public function test_isBindable():void
	{
		var ast:IParserNode = Node.create("content", -1, -1, null);
		var element:ScriptNode = new ScriptNode(ast, null);
		
		Assert.assertFalse(element.isBindable);
		// new adds the metadata to the node
		// do not need to call addMetaData()
		var bindable:MetaData = MetaData.create("Bindable");
		var metaData:IMetaDataNode = element.newMetaData(bindable.name);
		
		Assert.assertTrue(element.isBindable);
		Assert.assertTrue(element.hasMetaData(bindable.name));
		
		// test AST was added
		var metaList:IParserNode = ASTUtil.getNode(AS3NodeKind.META_LIST, element.node);
		Assert.assertNotNull(metaList);
		Assert.assertEquals(1, metaList.numChildren);
		var meta:IParserNode = metaList.getChild(0);
		Assert.assertNotNull(meta);
		Assert.assertEquals("Bindable", ASTUtil.getNode(AS3NodeKind.NAME, meta).stringValue);
		
		element.removeMetaData(metaData);
		
		// Test AST was removed
		metaList = ASTUtil.getNode(AS3NodeKind.META_LIST, element.node);
		// even though meta-list children is 0, we do not remove the meta-list node
		Assert.assertNotNull(metaList);
		Assert.assertEquals(0, metaList.numChildren);
		
		Assert.assertFalse(element.isBindable);
		Assert.assertFalse(element.hasMetaData(bindable.name));
	}
	
	[Test]
	public function test_description():void
	{
		
	}
	
	[Test]
	public function test_addRemoveHasMetaData():void
	{
		
	}
	
	[Test]
	public function test_addRemoveHasModifier():void
	{
		var ast:IParserNode = Node.create("content", -1, -1, null);
		var node:ScriptNode = new ScriptNode(ast, null);
		
		Assert.assertEquals(0, node.modifiers.length);
		Assert.assertEquals(0, ast.numChildren);
		Assert.assertFalse(node.isPublic);
		Assert.assertFalse(node.hasModifier(Modifier.PUBLIC));
		
		node.addModifier(Modifier.PUBLIC);
		
		Assert.assertEquals(1, node.modifiers.length);
		Assert.assertEquals(1, ast.numChildren);
		Assert.assertEquals(1, ast.getChild(0).numChildren);
		Assert.assertEquals(Modifier.PUBLIC.name, ast.getChild(0).getChild(0).stringValue);
		Assert.assertTrue(node.isPublic);
		Assert.assertTrue(node.hasModifier(Modifier.PUBLIC));
		
		node.removeModifier(Modifier.PUBLIC);
		
		Assert.assertEquals(0, node.modifiers.length);
		Assert.assertEquals(1, ast.numChildren);
		Assert.assertTrue(ast.getChild(0).isKind(AS3NodeKind.MOD_LIST));
		Assert.assertEquals(0, ast.getChild(0).numChildren);
		Assert.assertFalse(node.isPublic);
		Assert.assertFalse(node.hasModifier(Modifier.PUBLIC));
	}
}
}