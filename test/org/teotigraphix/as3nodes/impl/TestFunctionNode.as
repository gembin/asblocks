package org.teotigraphix.as3nodes.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IDocTagNode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

public class TestFunctionNode
{
	[Test]
	public function testBasic():void
	{
		var ast:IParserNode = ASTNodeUtil.createMethod(
			"myMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		var element:FunctionNode = new FunctionNode(ast, null);
	}
	
	[Test]
	public function test_isConstructor():void
	{
		var past:IParserNode = ASTNodeUtil.createClassContent(IdentifierNode.createType("my.domain.Test"));
		var parent:ClassTypeNode = new ClassTypeNode(past, null);
		
		var ast1:IParserNode = ASTNodeUtil.createMethod("Test", Modifier.PUBLIC, null);
		var element1:FunctionNode = new FunctionNode(ast1, parent);
		
		var ast2:IParserNode = ASTNodeUtil.createMethod("testMethod", Modifier.PUBLIC, null);
		var element2:FunctionNode = new FunctionNode(ast2, parent);
		
		Assert.assertTrue(element1.isConstructor);
		Assert.assertFalse(element2.isConstructor);
	}
	
	[Test]
	public function test_isOverride():void
	{
		var ast:IParserNode = ASTNodeUtil.createMethod("testMethod", Modifier.PUBLIC, null);
		var element:FunctionNode = new FunctionNode(ast, null);
		
		Assert.assertFalse(element.isOverride);
		
		element.addModifier(Modifier.OVERRIDE);
		element.addModifier(Modifier.OVERRIDE);
		element.addModifier(Modifier.OVERRIDE);
		
		Assert.assertEquals(2, element.modifiers.length);
		
		Assert.assertTrue(element.hasModifier(Modifier.OVERRIDE));
		Assert.assertTrue(element.isOverride);
		
		element.removeModifier(Modifier.OVERRIDE);
		
		Assert.assertFalse(element.hasModifier(Modifier.OVERRIDE));
		Assert.assertFalse(element.isOverride);
		
		element.isOverride = true;
		Assert.assertTrue(element.hasModifier(Modifier.OVERRIDE));
		Assert.assertTrue(element.isOverride);
		
		element.isOverride = false;
		Assert.assertFalse(element.hasModifier(Modifier.OVERRIDE));
		Assert.assertFalse(element.isOverride);
	}
	
	[Test]
	public function test_isStatic():void
	{
		var ast:IParserNode = ASTNodeUtil.createMethod("testMethod", Modifier.PUBLIC, null);
		var element:FunctionNode = new FunctionNode(ast, null);
		
		Assert.assertFalse(element.isStatic);
		
		element.addModifier(Modifier.STATIC);
		element.addModifier(Modifier.STATIC);
		element.addModifier(Modifier.STATIC);
		
		Assert.assertEquals(2, element.modifiers.length);
		
		Assert.assertTrue(element.hasModifier(Modifier.STATIC));
		Assert.assertTrue(element.isStatic);
		
		element.removeModifier(Modifier.STATIC);
		
		Assert.assertFalse(element.hasModifier(Modifier.STATIC));
		Assert.assertFalse(element.isStatic);
		
		element.isStatic = true;
		Assert.assertTrue(element.hasModifier(Modifier.STATIC));
		Assert.assertTrue(element.isStatic);
		
		element.isStatic = false;
		Assert.assertFalse(element.hasModifier(Modifier.STATIC));
		Assert.assertFalse(element.isStatic);
	}
	
	[Test]
	public function test_parameters():void
	{
		var ast:IParserNode = ASTNodeUtil.createMethod("testMethod", Modifier.PUBLIC, null);
		var element:FunctionNode = new FunctionNode(ast, null);
		
		Assert.assertFalse(element.hasParameters);
		Assert.assertNotNull(element.parameters);
		Assert.assertEquals(0, element.parameters.length);
		
		var param:IParameterNode = element.newParameter(
			"arg0", IdentifierNode.createType("String"), "null");
		
		Assert.assertTrue(element.hasParameters);
		Assert.assertEquals(1, element.parameters.length);
		
		Assert.assertTrue(param.hasType);
		Assert.assertTrue(param.hasValue);
		Assert.assertFalse(param.isRest);
		
		Assert.assertEquals("arg0", param.name);
		Assert.assertEquals("String", param.type.localName);
		Assert.assertEquals("null", param.value);
		
		// Test AST
		var paramList:IParserNode = element.node.getKind(AS3NodeKind.PARAMETER_LIST);
		Assert.assertNotNull(paramList);
		Assert.assertEquals(1, paramList.numChildren);
		var arg0:IParserNode = paramList.getChild(0);
		Assert.assertNotNull(arg0);
		Assert.assertStrictlyEquals(param.node, arg0);
		
		// remove the param
		Assert.assertNotNull(element.removeParameter(param));
		Assert.assertFalse(element.hasParameters);
		Assert.assertEquals(0, element.parameters.length);
		
		paramList = element.node.getKind(AS3NodeKind.PARAMETER_LIST);
		Assert.assertNotNull(paramList);
		Assert.assertEquals(0, paramList.numChildren);
	}
	
	[Test]
	public function test_parameters_hasParameters():void
	{
		var ast:IParserNode = ASTNodeUtil.createMethod("testMethod", Modifier.PUBLIC, null);
		var element:FunctionNode = new FunctionNode(ast, null);
		
		Assert.assertFalse(element.hasParameters);
		Assert.assertNotNull(element.parameters);
		Assert.assertEquals(0, element.parameters.length);
		
		var param:IParameterNode = element.newParameter(
			"arg0", IdentifierNode.createType("String"), "null");
		
		Assert.assertTrue(element.hasParameters);
		
		element.removeParameter(param);
		
		Assert.assertFalse(element.hasParameters);
	}
	
	[Test]
	public function test_getParameter():void
	{
		var ast:IParserNode = ASTNodeUtil.createMethod("testMethod", Modifier.PUBLIC, null);
		var element:FunctionNode = new FunctionNode(ast, null);
		
		Assert.assertNotNull(element.parameters);
		Assert.assertEquals(0, element.parameters.length);
		
		var param0:IParameterNode = element.newParameter(
			"arg0", IdentifierNode.createType("String"));
		
		var param1:IParameterNode = element.newParameter(
			"arg1", IdentifierNode.createType("my.domain.Test"));
		
		var param2:IParameterNode = element.newParameter(
			"arg2", IdentifierNode.createType("int"));
		
		Assert.assertTrue(element.hasParameters);
		Assert.assertEquals(3, element.parameters.length);
		
		Assert.assertStrictlyEquals(param0, element.getParameter("arg0"));
		Assert.assertStrictlyEquals(param1, element.getParameter("arg1"));
		Assert.assertStrictlyEquals(param2, element.getParameter("arg2"));
		
		Assert.assertNotNull(element.removeParameter(param1));
		
		Assert.assertEquals(2, element.parameters.length);
		
		Assert.assertStrictlyEquals(param0, element.getParameter("arg0"));
		Assert.assertNull(element.getParameter("arg1"));
		Assert.assertStrictlyEquals(param2, element.getParameter("arg2"));
	}
	
	[Test]
	public function test_type_hasType():void
	{
		var ast:IParserNode = ASTNodeUtil.createMethod("testMethod", Modifier.PUBLIC, 
			IdentifierNode.createType("my.domain.Test"));
		var element:FunctionNode = new FunctionNode(ast, null);
		
		Assert.assertTrue(element.hasType);
		Assert.assertEquals("Test", element.type.localName);
		//Assert.assertEquals("my.domain.Test", element.type.qualifiedName);
		
		// Test AST
		var typeNode:IParserNode = element.node.getKind(AS3NodeKind.TYPE);
		Assert.assertNotNull(typeNode);
		Assert.assertEquals("Test", typeNode.stringValue);
		
		element.type = null;
		Assert.assertNull(element.type);
		Assert.assertFalse(element.hasType);
		
		typeNode = element.node.getKind(AS3NodeKind.TYPE);
		Assert.assertNull(typeNode);
		
		element.type = IdentifierNode.createType("String");
		Assert.assertTrue(element.hasType);
		Assert.assertEquals("String", element.type.localName);
		
		typeNode = element.node.getKind(AS3NodeKind.TYPE);
		Assert.assertNotNull(typeNode);
		Assert.assertEquals("String", typeNode.stringValue);
	}
	
	[Test]
	public function test_addReturnDescription():void
	{
		var ast:IParserNode = ASTNodeUtil.createMethod("testMethod", Modifier.PUBLIC, 
			IdentifierNode.createType("my.domain.Test"));
		var element:FunctionNode = new FunctionNode(ast, null);
		
		Assert.assertNotNull(element.comment);
		Assert.assertNotNull(element.comment.docTags);
		Assert.assertEquals(0, element.comment.docTags.length);
		
		// Test AST
		var unit:IParserNode = element.comment.node.getKind(ASDocNodeKind.COMPILATION_UNIT);
		Assert.assertNotNull(unit);
		var content:IParserNode = unit.getKind(ASDocNodeKind.CONTENT);
		Assert.assertNotNull(content);
		var tagList:IParserNode = content.getKind(ASDocNodeKind.DOCTAG_LIST);
		Assert.assertNotNull(tagList);
		
		Assert.assertEquals(0, tagList.numChildren);
		
		element.addReturnDescription("A return description string.");
		
		tagList = content.getKind(ASDocNodeKind.DOCTAG_LIST);
		Assert.assertNotNull(tagList);
		Assert.assertEquals(1, tagList.numChildren);
		
		Assert.assertEquals(1, element.comment.docTags.length);
		
		var tag:IDocTagNode = element.comment.getDocTag("return");
		Assert.assertNotNull(tag);
		Assert.assertEquals("return", tag.name);
		Assert.assertEquals("A return description string.", tag.body);
		
		element.comment.removeDocTag(tag);
		
		tagList = content.getKind(ASDocNodeKind.DOCTAG_LIST);
		Assert.assertNotNull(tagList);
		Assert.assertEquals(0, tagList.numChildren);
	}
}
}