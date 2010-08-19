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

package org.teotigraphix.as3nodes.api
{

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IAS3Factory
{
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new <code>IAS3Project<code>.
	 * 
	 * @param output The String output path where source files get rendered.
	 * @return A new <code>IAS3Project<code>.
	 */
	function newASProject(output:String):IAS3Project;
	
	/**
	 * TODO DOCME
	 */
	function newImport(parent:IPackageNode, 
					   name:String):IIdentifierNode
	
	/**
	 * TODO DOCME
	 */
	function newInclude(parent:IPackageNode, 
						filePath:String):IIncludeNode;
	
	/**
	 * TODO DOCME
	 */
	function newUse(parent:IPackageNode, 
					nameSpace:String):IUseNode;
	
	/**
	 * TODO DOCME
	 */
	function newClass(parent:IPackageNode, 
					  name:String):IClassTypeNode;
	
	/**
	 * TODO DOCME
	 */
	function newInterface(parent:IPackageNode, 
						  name:String):IInterfaceTypeNode;
	
	/**
	 * TODO DOCME
	 */
	function newFunction(parent:IPackageNode, 
						 name:String):IFunctionTypeNode;
	
	/**
	 * TODO DOCME
	 */
	function newComment(parent:ICommentAware, 
						description:String = null):ICommentNode;
	
	/**
	 * TODO DOCME
	 */
	function newBlockComment(parent:IBlockCommentAware, 
							 comment:String, 
							 wrap:Boolean = false):IBlockCommentNode;
	
	/**
	 * TODO DOCME
	 */
	function newDocTag(parent:ICommentNode,
					   name:String,
					   body:String = null):IDocTagNode;
	/**
	 * TODO DOCME
	 */
	function newConstant(parent:IClassTypeNode,
						 name:String, 
						 visibility:Modifier, 
						 type:IIdentifierNode,
						 primaray:String):IConstantNode;
	
	/**
	 * TODO DOCME
	 */
	function newAttribute(parent:IClassTypeNode,
						  name:String, 
						  visibility:Modifier, 
						  type:IIdentifierNode,
						  primaray:String = null):IAttributeNode;
	/**
	 * TODO DOCME
	 */
	function newAccessor(parent:ITypeNode,
						 name:String, 
						 visibility:Modifier, 
						 access:Access,
						 type:IIdentifierNode):IAccessorNode;
	
	/**
	 * Creates a new <code>IMethodNode</code> on the parent <code>ITypeNode</code> 
	 * and fills the <code>IMethodNode</code> with valid AST.
	 * 
	 * @param parent The <code>ITypeNode</code> container.
	 * @param name A String method name.
	 * @param visibility The visibility <code>Modifier</code>, IE 
	 * <code>Modifier.PUBLIC</code>, <code>Modifier.PROTECTED</code>, 
	 * <code>Modifier.PRIVATE</code> or <code>Modifier.create("my_namespace")</code>.
	 * @param returnType The return type identifier.
	 * @return A new <code>IMethodNode</code> with valid internal AST.
	 */
	function newMethod(parent:ITypeNode,
					   name:String, 
					   visibility:Modifier, 
					   returnType:IIdentifierNode):IMethodNode;
	
	/**
	 * TODO DOCME
	 */
	function newParameter(parent:IParameterAware,
						  name:String, 
						  type:IIdentifierNode, 
						  defaultValue:String):IParameterNode;
	/**
	 * TODO DOCME
	 */
	function newRestParameter(parent:IParameterAware,
							  name:String):IParameterNode;
	
	/**
	 * Creates a new <code>IMetaDataNode</code> on the parent <code>IMetaDataAware</code> 
	 * and fills the <code>IMetaDataNode</code> with valid AST.
	 * 
	 * @param parent The <code>IMetaDataAware</code> container.
	 * @param name A String metaData name.
	 * @return A new <code>IMetaDataNode</code> with valid internal AST.
	 */
	function newMetaData(parent:IMetaDataAware, name:String):IMetaDataNode;
}
}