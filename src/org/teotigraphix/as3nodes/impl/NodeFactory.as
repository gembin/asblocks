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

import org.teotigraphix.as3nodes.api.IAS3SourceFile;
import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IDocTag;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMXMLSourceFile;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMetaDataParameterNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.ISourceCode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.FileUtil;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class NodeFactory
{
	/**
	 * @private
	 */
	private static var _instance:NodeFactory;
	
	/**
	 * Returns the single instance of the NodeFactory.
	 */
	public static function get instance():NodeFactory
	{
		if (!_instance)
			_instance = new NodeFactory();
		return _instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Factory :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates an ISourceFile based on the fileName's extension.
	 * 
	 * <p>The supported extensions are <strong>.as</strong> and 
	 * <strong>.mxml</strong>.</p>
	 * 
	 * @param data The String source code data.
	 * @param filePath The data's source fileName.
	 * @param classPath The files's classPath.
	 */
	public function createSourceFile(data:String, 
									 filePath:String,
									 classPath:String):ISourceFile
	{
		var sourceCode:ISourceCode = new SourceCode(data, filePath, classPath);
		
		if (filePath.indexOf(".as") != -1)
		{
			return new AS3SourceFile(null, sourceCode);
		}
		else if (filePath.indexOf(".mxml") != -1)
		{
			return new MXMLSourceFile(null, sourceCode);
		}
		
		// TODO throw Error?
		return null;
	}
	
	/**
	 * Attempts to load file data from the filePath.
	 * 
	 * <p>This method will fail if not used with AIR libraries.</p>
	 * 
	 * @param filePath The data's source fileName.
	 * @param classPath The files's classPath.
	 * @see #createSourceFile()
	 * @throws Error Definition flash.filesystem.File not found, import AIR library
	 * @throws Error File 'filePath' does not exist
	 */
	public function loadSourceFile(filePath:String,
								   classPath:String):ISourceFile
	{
		var data:String;
		
		try
		{
			data = FileUtil.readFile(filePath);
		}
		catch (e:Error)
		{
			throw e;
		}
		
		return createSourceFile(data, filePath, classPath);
	}
	
	/**
	 * Creates an ICompilationNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createCompilation(node:IParserNode, 
									  parent:INode):ICompilationNode
	{
		if (parent is IMXMLSourceFile)
		{
			return new MXMLCompilationNode(node, parent);
		}
		else if (parent is IAS3SourceFile)
		{
			return new CompilationNode(node, parent);
		}
		
		// TODO throw Error?
		return null;
	}
	
	/**
	 * Creates an IIdentifierNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createIdentifier(node:IParserNode, 
									 parent:INode):IIdentifierNode
	{
		return new IdentifierNode(node, parent);
	}
	
	/**
	 * Creates an ICommentNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createComment(node:IParserNode, 
								  parent:INode):ICommentNode
	{
		return new CommentNode(node, parent);
	}
	
	/**
	 * Creates an IDocTag.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createDocTag(node:IParserNode, 
								 parent:INode):IDocTag
	{
		return new DocTagNode(node, parent);
	}
	
	/**
	 * Creates an ICommentNode placeholder.
	 * 
	 * @param parent An INode parent.
	 */
	//public function createCommentPlaceholderNode(parent:INode):ICommentNode
	//{
	//	return new CommentPlaceholderNode(parent);
	//}
	
	/**
	 * Creates an IPackageNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createPackage(node:IParserNode, 
								  parent:INode):IPackageNode
	{
		return new PackageNode(node, parent);
	}
	
	/**
	 * Creates an IMetaDataNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createMetaData(node:IParserNode, 
								   parent:INode):IMetaDataNode
	{
		return new MetaDataNode(node, parent);
	}
	
	/**
	 * Creates an IMetaDataParameterNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createMetaDataParameter(node:IParserNode, 
											parent:INode):IMetaDataParameterNode
	{
		return new MetaDataParameterNode(node, parent);
	}
	
	/**
	 * Creates an IConstantNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createConstant(node:IParserNode, 
								   parent:INode):IConstantNode
	{
		return new ConstantNode(node, parent);
	}
	
	/**
	 * Creates an IAttributeNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createAttribute(node:IParserNode, 
									parent:INode):IAttributeNode
	{
		return new AttributeNode(node, parent);
	}
	
	/**
	 * Creates an IAccessorNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createAccessor(node:IParserNode, 
								   parent:INode):IAccessorNode
	{
		return new AccessorNode(node, parent);
	}
	
	/**
	 * Creates an IMethodNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createMethod(node:IParserNode, 
								 parent:INode):IMethodNode
	{
		return new MethodNode(node, parent);
	}
	
	/**
	 * Creates an IParameterNode.
	 * 
	 * @param node An IParserNode internal node.
	 * @param parent An INode parent.
	 */
	public function createParameter(node:IParserNode, 
									parent:INode):IParameterNode
	{
		return new ParameterNode(node, parent);
	}
}
}