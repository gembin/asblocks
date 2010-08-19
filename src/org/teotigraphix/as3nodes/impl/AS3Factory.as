////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.Access;
import org.teotigraphix.as3nodes.api.IAS3Factory;
import org.teotigraphix.as3nodes.api.IAS3Project;
import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ICommentAware;
import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IDocTagNode;
import org.teotigraphix.as3nodes.api.IFunctionTypeNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMetaDataAware;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.IParameterAware;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class AS3Factory implements IAS3Factory
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3Factory()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  IAS3Factory API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newASProject()
	 */
	public function newASProject(output:String):IAS3Project
	{
		var project:AS3Project = new AS3Project(output);
		project.output = output;
		return project;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newImport()
	 */
	public function newImport(parent:IPackageNode, 
							  name:String):IIdentifierNode
	{
		var ast:IParserNode = ASTNodeUtil.createName(name);
		var uidNode:IIdentifierNode = NodeFactory.instance.createIdentifier(ast, parent);
		parent.addImport(uidNode);
		return uidNode;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newClass()
	 */
	public function newClass(parent:IPackageNode, 
							 name:String):IClassTypeNode
	{
		var ast:IParserNode = ASTNodeUtil.createClass(IdentifierNode.createName(name));
		var classType:IClassTypeNode = NodeFactory.instance.createClassType(ast, parent);
		parent.typeNode = classType;
		return classType;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newInterface()
	 */
	public function newInterface(parent:IPackageNode, 
								 name:String):IInterfaceTypeNode
	{
		var ast:IParserNode = ASTNodeUtil.createInterface(IdentifierNode.createName(name));
		var interfaceType:IInterfaceTypeNode = NodeFactory.instance.createInterfaceType(ast, parent);
		parent.typeNode = interfaceType;
		return interfaceType;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newFunction()
	 */
	public function newFunction(parent:IPackageNode, 
								name:String):IFunctionTypeNode
	{
		var ast:IParserNode = ASTNodeUtil.createFunction(IdentifierNode.createName(name));
		var functionType:IFunctionTypeNode = NodeFactory.instance.createFunctionType(ast, parent);
		parent.typeNode = functionType;
		return functionType;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newComment()
	 */
	public function newComment(parent:ICommentAware, 
							   description:String = null):ICommentNode
	{
		// give the update manager a chance to clear out old AST
		if (!description)
			parent.setComment(null);
		
		var ast:IParserNode = ASTNodeUtil.createAsDoc(description);
		var comment:ICommentNode = NodeFactory.instance.createComment(ast, parent);
		parent.setComment(comment);
		
		return comment;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newDocTag()
	 */
	public function newDocTag(parent:ICommentNode, 
							  name:String,
							  body:String = null):IDocTagNode
	{
		var ast:IParserNode = ASTNodeUtil.createDocTag(name, body);
		var docTag:IDocTagNode = NodeFactory.instance.createDocTag(ast, parent);
		parent.addDocTag(docTag);
		return docTag;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newAttribute()
	 */
	public function newConstant(parent:IClassTypeNode,
								name:String, 
								visibility:Modifier, 
								type:IIdentifierNode,
								primary:String):IConstantNode
	{
		var ast:IParserNode = ASTNodeUtil.createConstant(name, visibility, type, primary);
		var constant:IConstantNode = NodeFactory.instance.createConstant(ast, parent);
		parent.addConstant(constant);
		return constant;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newAttribute()
	 */
	public function newAttribute(parent:IClassTypeNode,
								 name:String, 
								 visibility:Modifier, 
								 type:IIdentifierNode,
								 primary:String = null):IAttributeNode
	{
		var ast:IParserNode = ASTNodeUtil.createAttribute(name, visibility, type, primary);
		var attribute:IAttributeNode = NodeFactory.instance.createAttribute(ast, parent);
		parent.addAttribute(attribute);
		return attribute;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newAccessor()
	 */
	public function newAccessor(parent:ITypeNode,
								name:String, 
								visibility:Modifier,
								access:Access,
								type:IIdentifierNode):IAccessorNode
	{
		var ast:IParserNode = ASTNodeUtil.createAccessor(name, visibility, access, type);
		var accessor:IAccessorNode = NodeFactory.instance.createAccessor(ast, parent);
		parent.addAccessor(accessor);
		if (access.equals(Access.READ))
		{
			
		}
		else if (access.equals(Access.WRITE))
		{
			accessor.newParameter("value", type);
			accessor.type = IdentifierNode.createType("void");
		}
		return accessor;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newMethod()
	 */
	public function newMethod(parent:ITypeNode,
							  name:String, 
							  visibility:Modifier, 
							  returnType:IIdentifierNode):IMethodNode
	{
		var ast:IParserNode = ASTNodeUtil.createMethod(name, visibility, returnType);
		var method:IMethodNode = NodeFactory.instance.createMethod(ast, parent);
		parent.addMethod(method);
		return method;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newParameter()
	 */
	public function newParameter(parent:IParameterAware,
								 name:String, 
								 type:IIdentifierNode, 
								 defaultValue:String):IParameterNode
	{
		var ast:IParserNode = ASTNodeUtil.createParameter(name, type, defaultValue);
		var parameter:IParameterNode = NodeFactory.instance.createParameter(ast, parent);
		parent.addParameter(parameter);
		return parameter;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newRestParameter()
	 */
	public function newRestParameter(parent:IParameterAware,
									 name:String):IParameterNode
	{
		var ast:IParserNode = ASTNodeUtil.createRestParameter(name);
		var parameter:IParameterNode = NodeFactory.instance.createParameter(ast, parent);
		parent.addParameter(parameter);
		return parameter;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newMetaData()
	 */
	public function newMetaData(parent:IMetaDataAware, name:String):IMetaDataNode
	{
		// create a non-parent AST 'meta' node with 'name' child
		var meta:IParserNode = ASTNodeUtil.createMeta(name);
		// create an IMetaDataNode passing the new AST and parent aware node 
		var node:IMetaDataNode = NodeFactory.instance.createMetaData(meta, INode(parent));
		// add the IMetaDataNode to the aware parent which will trigger
		// a meta-list change event that will update the parent's AST to
		// include the new meta node, this could create a new meta-list if
		// once does not exist on the aware parent
		parent.addMetaData(node);
		// return the node
		return node;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static var _instance:IAS3Factory;
	
	/**
	 * Returns the single instance of the IAS3Factory.
	 */
	public static function get instance():IAS3Factory
	{
		if (!_instance)
			_instance = new AS3Factory();
		return _instance;
	}
}
}