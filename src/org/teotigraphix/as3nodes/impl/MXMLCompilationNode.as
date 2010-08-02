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

import org.teotigraphix.as3nodes.api.IMXMLSourceFile;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.utils.AsDocUtil;
import org.teotigraphix.as3nodes.utils.StringUtil;
import org.teotigraphix.as3parser.api.IParser;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.MXMLNodeKind;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MXMLCompilationNode extends CompilationNode
{
	public var mxmlNode:IParserNode;
	
	public var pendingName:String;
	
	public var pendingPackageName:String;
	
	public var pendingQualifiedName:String;
	
	private var qnames:Vector.<MXMLQName>;
	
	public var pendingVariables:String = "";
	
	public var internalImports:Vector.<String>;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MXMLCompilationNode(node:IParserNode, parent:INode)
	{
		super(null, parent);
		
		mxmlNode = node;
		
		if (node == null)
			return;
		
		computeMXML();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function compute():void
	{
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function computeMXML():void
	{
		computeName();
		
		computeImports();
		
		var packageBlock:String = new MXMLFactory(this).buildPackageBlock();
		
		var lines:Vector.<String> = Vector.<String>(packageBlock.split("\n"));
		var parser:IParser = ParserFactory.instance.createAS3Parser();
		
		var unit:IParserNode = parser.buildAst(lines, "f");
		
		node = unit;
		
		packageNode = NodeFactory.instance.
			createPackage(ASTUtil.getPackage(node), this);
	}
	
	/**
	 * @private
	 */
	protected function computeName():void
	{
		var file:IMXMLSourceFile = parent as IMXMLSourceFile;
		
		pendingName = file.name;
		pendingPackageName = file.packageName;
		pendingQualifiedName = file.qualifiedName;
	}
	
	/**
	 * @private
	 */
	protected function computeImports():void
	{
		var root:IParserNode = ASTUtil.getNode(MXMLNodeKind.TAG_LIST, mxmlNode);
		
		qnames = new Vector.<MXMLQName>();
		
		var namespaces:Vector.<IParserNode> = ASTUtil.getNodes(MXMLNodeKind.XML_NS, root);
		for each (var element:IParserNode in namespaces) 
		{
			qnames.push(new MXMLQName(element));
		}
		
		// new we need to get all tag-list nodes that contain a id attribute
		var variables:Vector.<IParserNode> = parseVariables(root, null, 0);
		var sb:String = "";
		
		if (variables && variables.length > 0)
		{
			for each (var tagList:IParserNode in variables)
			{
				var vasdoc:IParserNode = ASTUtil.getNode(MXMLNodeKind.AS_DOC, tagList);
				var vbinding:IParserNode = ASTUtil.getNode(MXMLNodeKind.BINDING, tagList);
				var vlocalName:IParserNode = ASTUtil.getNode(MXMLNodeKind.LOCAL_NAME, tagList);
				var vatt:IParserNode = getAttID(tagList);
				
				if (vasdoc != null)
				{
					sb += AsDocUtil.parseMXMLASDocString(vasdoc.stringValue);
				}
				
				if (vlocalName != null)
				{
					sb += "public var ";
					sb += vatt.getChild(1).stringValue;
					sb += ":";
					sb += vlocalName.stringValue;
					sb += ";\n";
				}
				
				if (vbinding != null)
				{
					tryAddImport(vbinding.stringValue, vlocalName.stringValue);
				}
			}
		}
		
		pendingVariables = sb;
	}
	
	/**
	 * @private
	 */
	private function tryAddImport(binding:String, localName:String):void
	{
		var imp:String = null;
		var name:MXMLQName = getQNameFor(binding);
		
		if (name != null)
		{
			// TODO need loaded manifests and namespaces from config
			if (name.uri.indexOf(".*") == -1)
			{
				return;
			}
			
			imp = name.uri.replace(".*", "." + localName);
			
			if (imp != null)
			{
				addImport(imp);
			}
		}
	}
	
	/**
	 * @private
	 */
	private function addImport(imp:String):void
	{
		if (internalImports == null)
		{
			internalImports = new Vector.<String>();
		}
		
		internalImports.push(imp);
	}
	
	/**
	 * @private
	 */
	public function getQNameFor(binding:String):MXMLQName
	{
		if (qnames == null)
		{
			return null;
		}
		
		for each(var name:MXMLQName in qnames)
		{
			if (name.localName == binding)
			{
				if (StringUtil.endsWith(name.uri, ".*"))
				{
					return name;
				}
				
				return name;
			}
		}
		
		return null;
	}
	
	/**
	 * @private
	 */
	private function parseVariables(tagList:IParserNode, 
									result:Vector.<IParserNode>, 
									level:int):Vector.<IParserNode>
	{
		if (result == null)
		{
			result = new Vector.<IParserNode>();
		}
		
		var numChildren:int = tagList.numChildren;
		if (numChildren > 0)
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				if (tagList.isKind(MXMLNodeKind.TAG_LIST))
				{
					parseVariables(tagList.getChild(i), result, level + 1);
				}
			}
		}
		
		var atts:Vector.<IParserNode> = ASTUtil.getNodes(MXMLNodeKind.ATT, tagList);
		
		if (atts != null)
		{
			for each(var att:IParserNode in atts)
			{
				if (att.getChild(0).stringValue == "id")
				{
					result.push(tagList);
				}
			}
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function getAttID(tagList:IParserNode):IParserNode
	{
		var atts:Vector.<IParserNode> = ASTUtil.getNodes(MXMLNodeKind.ATT, tagList);
		
		if (atts != null)
		{
			for each(var att:IParserNode in atts)
			{
				if (att.getChild(0).stringValue == "id")
				{
					return att;
				}
			}
		}
		
		return null;
	}
}
}

import org.teotigraphix.as3nodes.impl.MXMLCompilationNode;
import org.teotigraphix.as3nodes.impl.MXMLQName;
import org.teotigraphix.as3nodes.impl.ManifestItem;
import org.teotigraphix.as3nodes.utils.AsDocUtil;
import org.teotigraphix.as3nodes.utils.ManifestUtil;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.MXMLNodeKind;
import org.teotigraphix.as3parser.utils.ASTUtil;

class MXMLFactory
{
	private var element:MXMLCompilationNode;
	
	public function MXMLFactory(element:MXMLCompilationNode)
	{
		this.element = element;
	}
	
	public function buildPackageBlock():String
	{
		var sb:String = "";
		
		// setup package
		sb += buildPackageHeader();
		
		// setup imports
		sb += buildImportBlock();
		
		// setup meta data
		sb += buildMetaDataBlock();
		
		// setup doc comment
		sb += buildClassCommentBlock();
		
		// setup class
		sb += buildClassContentBlock();
		
		// end package
		sb += buildPackageFooter();
		
		return sb;
	}
	
	private function buildPackageHeader():String
	{
		var sb:String = "";
		
		var name:String = element.pendingPackageName;
		if (name == null)
		{
			name = ""; // toplevel mxml file
		}
		
		sb += "package ";
		sb += name;
		sb += "\n";
		sb += "{";
		sb += "\n";
		
		return sb;
	}
	
	private function buildImportBlock():String
	{
		if (element.internalImports == null)
		{
			return "";
		}
		
		var sb:String = "";
		
		for each (var imp:String in element.internalImports)
		{
			sb += "import ";
			sb += imp;
			sb += ";\n";
		}
		
		return sb;
	}
	
	private function buildMetaDataBlock():String
	{
		var metadata:IParserNode =
			getImmediateTagList(element.mxmlNode.getChild(1), "Metadata");
		
		var codeBlock:String = "";
		
		if (metadata != null)
		{
			codeBlock =	ASTUtil.getNode(MXMLNodeKind.CDATA, metadata).stringValue + "\n";
		}
		
		return codeBlock;
	}
	
	private function buildClassCommentBlock():String
	{
		var root:IParserNode = ASTUtil.getNode(MXMLNodeKind.TAG_LIST, element.mxmlNode);
		var asdoc:IParserNode = ASTUtil.getNode(MXMLNodeKind.AS_DOC, root);
		
		if (asdoc == null)
		{
			return "";
		}
		
		return AsDocUtil.parseMXMLASDocString(asdoc.stringValue);
	}
	
	private function buildClassContentBlock():String
	{
		var sb:String = "";
		
		sb += "public class ";
		sb += element.pendingName
		
		// get superclass
		sb += buildExtendsString();
		
		// get implements
		sb += buildImplementsString();
		
		sb += "\n";
		sb += "{";
		sb += "\n";
		
		// setup class content
		sb += buildScriptString();
		
		sb += "\n";
		sb += "}"; // end class
		sb += "\n";
		
		return sb;
	}
	
	private function buildExtendsString():String
	{
		var root:IParserNode =
			ASTUtil.getNode(MXMLNodeKind.TAG_LIST, element.mxmlNode);
		
		var binding:IParserNode = ASTUtil.getNode(MXMLNodeKind.BINDING, root);
		var localName:IParserNode =	ASTUtil.getNode(MXMLNodeKind.LOCAL_NAME, root);
		
		var qname:MXMLQName = element.getQNameFor(binding.stringValue);
		
		var item:ManifestItem =
			ManifestUtil.getItem(qname, localName.stringValue);
		
		if (item != null)
		{
			return " extends " + item.qualifiedName + " ";
		}
		
		if (item == null && qname != null && localName != null)
		{
			if (qname.uri.indexOf("://") != -1)
			{
				return " extends " + localName.stringValue + " ";
			}
			
			if (binding.stringValue == qname.localName)
			{
				var uri:String = qname.uri.replace(".*", "");
				
				return " extends " + uri + "." + localName.stringValue;
			}
		}
		
		if (localName != null)
		{
			return " extends " + localName.stringValue + " ";
		}
		
		return "";
	}
	
	private function buildImplementsString():String
	{
		var root:IParserNode =
			ASTUtil.getNode(MXMLNodeKind.TAG_LIST, element.mxmlNode);
		
		for each (var node:IParserNode in root.children)
		{
			if (node.isKind(MXMLNodeKind.ATT))
			{
				var name:IParserNode = node.getChild(0);
				var value:IParserNode = node.getChild(1);
				//var state:IParserNode = node.getChild(2);
				
				if (name.stringValue == "implements")
				{
					return " implements " + value.stringValue;
				}
			}
		}
		
		return "";
	}
	
	private function buildScriptString():String
	{
		var sb:String = "";
		
		sb += element.pendingVariables;
		
		var script:IParserNode = getImmediateTagList(
			element.mxmlNode.getChild(1), "Script");
		
		if (script != null)
		{
			sb += ASTUtil.getNode(MXMLNodeKind.CDATA, script).stringValue;
		}
		
		return sb;
	}
	
	private function getImmediateTagList(node:IParserNode, name:String):IParserNode
	{
		for each (var child:IParserNode in node.children)
		{
			if (child.isKind(MXMLNodeKind.TAG_LIST))
			{
				var localName:IParserNode = ASTUtil.getNode(MXMLNodeKind.LOCAL_NAME, child);
				if (localName != null && localName.stringValue == name)
				{
					return child;
				}
			}
		}
		return null;
	}
	
	private function buildPackageFooter():String
	{
		return "}";
	}
}