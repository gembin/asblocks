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

import org.teotigraphix.as3nodes.api.IAS3Factory;
import org.teotigraphix.as3nodes.api.IAS3Project;
import org.teotigraphix.as3nodes.api.ICommentAware;
import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IDocTag;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMetaDataAware;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.INode;
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
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newComment()
	 */
	public function newComment(parent:ICommentAware, 
							   description:String = null):ICommentNode
	{
		var ast:IParserNode = ASTNodeUtil.createAsDoc(parent, description);
		var comment:ICommentNode = NodeFactory.instance.createComment(ast.getLastChild(), parent);
		parent.comment = comment;
		return comment;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newDocTag()
	 */
	public function newDocTag(parent:ICommentNode, 
							  name:String,
							  body:String = null):IDocTag
	{
		var ast:IParserNode = ASTNodeUtil.newDocTag(parent, name, body);
		var docTag:IDocTag = NodeFactory.instance.createDocTag(ast, parent);
		parent.addDocTag(docTag);
		return docTag;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newMethod()
	 */
	public function newMethod(parent:ITypeNode,
							  name:String, 
							  visibility:Modifier, 
							  returnType:IIdentifierNode):IMethodNode
	{
		if (parent.hasMethod(name))
			return null;
		
		// parent.node/content/function
		var ast:IParserNode = ASTNodeUtil.createMethod(parent, name, visibility, returnType);
		var method:IMethodNode = NodeFactory.instance.createMethod(ast, parent);
		parent.addMethod(method);
		return method;
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