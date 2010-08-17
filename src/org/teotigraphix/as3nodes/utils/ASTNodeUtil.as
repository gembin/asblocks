package org.teotigraphix.as3nodes.utils
{

import org.teotigraphix.as3nodes.api.Access;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.ParserFactory;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.Node;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class ASTNodeUtil
{
	/**
	 * @private
	 */
	public static function createAsDoc(description:String):IParserNode
	{
		if (description == null)
			return createEmptyAsDoc();
		
		if (description.indexOf("/**") == -1)
			description = "/**" + description + "*/";
		
		// need to append asdoc or create node, asdoc compilation-unit
		var asdocNode:IParserNode = create(AS3NodeKind.AS_DOC);
		var compilationUnit:IParserNode = ParserFactory.instance.
			asdocParser.buildAst(Vector.<String>(description.split("\n")), "internal");
		
		asdocNode.addChild(compilationUnit);
		
		return asdocNode as IParserNode;
	}
	
	/**
	 * @private
	 */
	public static function createAsDocCompilationUnit(description:String):IParserNode
	{
		if (description == null)
			return createEmptyAsDoc();
		
		if (description.indexOf("/**") == -1)
			description = "/**" + description + "*/";
		
		var compilationUnit:IParserNode = ParserFactory.instance.
			asdocParser.buildAst(Vector.<String>(description.split("\n")), "internal");
		
		return compilationUnit;
	}
	
	/**
	 * Creates an empty as-doc AST tree.
	 */
	public static function createEmptyAsDoc():IParserNode
	{
		// as-doc
		var asdocNode:IParserNode = create(AS3NodeKind.AS_DOC);
		// as-doc/compilation-unit
		var compilationUnit:IParserNode = asdocNode.addChild(create(ASDocNodeKind.COMPILATION_UNIT));
		// as-doc/compilation-unit/content
		var content:IParserNode = compilationUnit.addChild(create(ASDocNodeKind.CONTENT));
		// as-doc/compilation-unit/content/short-list
		content.addChild(create(ASDocNodeKind.SHORT_LIST));
		// as-doc/compilation-unit/content/long-list
		content.addChild(create(ASDocNodeKind.LONG_LIST));
		// as-doc/compilation-unit/content/doctag-list
		content.addChild(create(ASDocNodeKind.DOCTAG_LIST));
		
		return asdocNode as IParserNode;
	}
	
	/**
	 * @private
	 */
	public static function createDocTag(name:String, 
										body:String = null):IParserNode
	{
		var docTag:IParserNode = create(ASDocNodeKind.DOCTAG);
		
		docTag.addChild(createDocTagName(name));
		if (body)
		{
			docTag.addChild(createDocTagBody(body));
		}
		
		return docTag;
	}
	
	/**
	 * @private
	 */
	public static function createName(name:String):IParserNode
	{
		return createText(AS3NodeKind.NAME, name);
	}
	
	/**
	 * @private
	 */
	public static function createType(name:String):IParserNode
	{
		return createText(AS3NodeKind.TYPE, name);
	}
	
	/**
	 * @private
	 */
	public static function createDocTagName(name:String):IParserNode
	{
		return createName(name);
	}
	
	/**
	 * @private
	 */
	public static function createDocTagBody(body:String):IParserNode
	{
		var bodyNode:IParserNode = create(ASDocNodeKind.BODY);
		bodyNode.addChild(createText(ASDocNodeKind.TEXT, body));
		return bodyNode;
	}
	
	/**
	 * Method does NOT add the AST to the parent. IMetaDataAware.addMetaData() will actually
	 * add the ast to the parent.
	 */
	public static function createMeta(name:String):IParserNode
	{
		// meta
		var meta:IParserNode = create(AS3NodeKind.META);
		// meta/name
		meta.addChild(createText(AS3NodeKind.NAME, name));
		
		return meta;
	}
	
	/**
	 * @private
	 */
	public static function createModifier(name:String):IParserNode
	{
		// mod
		return createText(AS3NodeKind.MODIFIER, name);
	}
	
	/**
	 * @private
	 */
	public static function createConstant(name:String, 
										  visibility:Modifier, 
										  type:IIdentifierNode,
										  primary:String):IParserNode
		
	{
		var node:IParserNode = create(AS3NodeKind.CONST_LIST);
		
		// parent.node/content/var-list/mod-list
		var modList:IParserNode = node.addChild(create(AS3NodeKind.MOD_LIST));
		
		if (visibility)
		{
			// parent.node/content/var-list/mod-list/mod
			modList.addChild(createText(AS3NodeKind.MODIFIER, visibility.name));
		}
		
		// parent.node/content/var-list/mod-list/mod
		modList.addChild(createText(AS3NodeKind.MODIFIER, Modifier.STATIC.name));
		
		// parent.node/content/var-list/name-type-init
		var nti:IParserNode = node.addChild(create(AS3NodeKind.NAME_TYPE_INIT));
		// parent.node/content/var-list/name-type-init/name
		nti.addChild(createText(AS3NodeKind.NAME, name));
		if (type)
		{
			// parent.node/content/var-list/name-type-init/type
			nti.addChild(createText(AS3NodeKind.TYPE, type.localName));
		}
		
		
		// parent.node/content/var-list/name-type-init/init
		var initNode:IParserNode = nti.addChild(create(AS3NodeKind.INIT));
		// parent.node/content/var-list/name-type-init/init/primary
		initNode.addChild(createText(AS3NodeKind.PRIMARY, primary));
		
		return node;
	}
	
	/**
	 * @private
	 */
	public static function createAttribute(name:String, 
										   visibility:Modifier, 
										   type:IIdentifierNode,
										   primary:String = null):IParserNode
		
	{
		var node:IParserNode = create(AS3NodeKind.VAR_LIST);
		
		if (visibility)
		{
			// parent.node/content/var-list/mod-list
			var modList:IParserNode = node.addChild(create(AS3NodeKind.MOD_LIST));
			// parent.node/content/var-list/mod-list/mod
			modList.addChild(createText(AS3NodeKind.MODIFIER, visibility.name));
		}
		
		// parent.node/content/var-list/name-type-init
		var nti:IParserNode = node.addChild(create(AS3NodeKind.NAME_TYPE_INIT));
		// parent.node/content/var-list/name-type-init/name
		nti.addChild(createText(AS3NodeKind.NAME, name));
		if (type)
		{
			// parent.node/content/var-list/name-type-init/type
			nti.addChild(createText(AS3NodeKind.TYPE, type.localName));
		}
		
		if (primary)
		{
			// parent.node/content/var-list/name-type-init/init
			var initNode:IParserNode = nti.addChild(create(AS3NodeKind.INIT));
			// parent.node/content/var-list/name-type-init/init/primary
			initNode.addChild(createText(AS3NodeKind.PRIMARY, primary));
		}
		
		return node;
	}
	
	/**
	 * @private
	 */
	public static function createAccessor(name:String, 
										  visibility:Modifier,
										  access:Access,
										  type:IIdentifierNode):IParserNode
		
	{
		var node:IParserNode = create(Access.toKind(access));
		
		// parent.node/content/function/mod-list
		var modList:IParserNode = node.addChild(create(AS3NodeKind.MOD_LIST));
		// parent.node/content/function/mod-list/mod
		modList.addChild(createText(AS3NodeKind.MODIFIER, visibility.name));
		// parent.node/content/function/name
		node.addChild(createText(AS3NodeKind.NAME, name));
		// parent.node/content/function/type
		if (type)
			node.addChild(createText(AS3NodeKind.TYPE, type.localName));
		// parent.node/content/function/block
		var block:IParserNode = create(AS3NodeKind.BLOCK);
		node.addChild(block);
		
		if (access.equals(Access.READ))
		{
			var retrn:String = "null";
			if (type)
			{
				if (type.localName == "int" 
					|| type.localName == "Number" 
					|| type.localName == "uint")
				{
					retrn = "-1";
				}
			}

			block.addChild(createReturn(retrn));
		}
		
		return node;
	}
	
	public static function createReturn(primary:String):IParserNode
	{
		var re:IParserNode = create("return");
		re.addChild(createText("primary", primary));
		return re;
	}
	
	/**
	 * @private
	 */
	public static function createMethod(name:String, 
										visibility:Modifier, 
										returnType:IIdentifierNode):IParserNode
		
	{
		var node:IParserNode = create(AS3NodeKind.FUNCTION);
		
		// parent.node/content/function/mod-list
		var modList:IParserNode = node.addChild(create(AS3NodeKind.MOD_LIST));
		// parent.node/content/function/mod-list/mod
		modList.addChild(createText(AS3NodeKind.MODIFIER, visibility.name));
		// parent.node/content/function/name
		node.addChild(createText(AS3NodeKind.NAME, name));
		// parent.node/content/function/type
		if (returnType)
			node.addChild(createText(AS3NodeKind.TYPE, returnType.localName));
		// parent.node/content/function/block
		node.addChild(create(AS3NodeKind.BLOCK));
		
		return node;
	}
	
	/**
	 * @private
	 */
	public static function createParameter(name:String,  
										   type:IIdentifierNode,
										   defaultValue:String = null):IParserNode
		
	{
		// parameter
		var param:IParserNode = create(AS3NodeKind.PARAMETER);
		
		// parameter/name-type-init
		var nti:IParserNode = param.addChild(create(AS3NodeKind.NAME_TYPE_INIT));
		
		// parameter/name-type-init/name
		nti.addChild(createText(AS3NodeKind.NAME, name));
		
		// parameter/name-type-init/type
		if (type)
		{
			nti.addChild(createText(AS3NodeKind.TYPE, type.localName));
		}
		
		if (defaultValue)
		{
			// parameter/name-type-init/init
			var init:IParserNode = nti.addChild(create(AS3NodeKind.INIT));
			// parameter/name-type-init/init/primary
			init.addChild(createText(AS3NodeKind.PRIMARY, defaultValue));
		}
		
		return param;
	}
	
	/**
	 * @private
	 */
	public static function createRestParameter(name:String):IParserNode
		
	{
		// parameter
		var param:IParserNode = create(AS3NodeKind.PARAMETER);
		
		// parameter/rest
		var rest:IParserNode = param.addChild(createText(AS3NodeKind.REST, name));
		
		return param;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @private
	 */
	public static function createEmptyClass(uid:IIdentifierNode):IParserNode
	{
		var compilationUnitNode:IParserNode = createCompilationUnit(uid.packageName);
		var packageContentNode:IParserNode = compilationUnitNode.getChild(0).getLastChild();
		var classNode:IParserNode = packageContentNode.addChild(create(AS3NodeKind.CLASS));
		var classNameNode:IParserNode = classNode.addChild(createText(AS3NodeKind.NAME, uid.localName));
		var classContentNode:IParserNode = classNode.addChild(create(AS3NodeKind.CONTENT));
		return compilationUnitNode;
	}
	
	/**
	 * @private
	 */
	public static function createClassContent(uid:IIdentifierNode):IParserNode
	{
		var classNode:IParserNode = create(AS3NodeKind.CLASS);
		var classNameNode:IParserNode = classNode.addChild(createText(AS3NodeKind.NAME, uid.localName));
		var classContentNode:IParserNode = classNode.addChild(create(AS3NodeKind.CONTENT));
		return classNode;
	}
	
	/**
	 * @private
	 */
	public static function createEmptyInterface(uid:IIdentifierNode):IParserNode
	{
		var compilationUnitNode:IParserNode = createCompilationUnit(uid.packageName);
		var packageContentNode:IParserNode = compilationUnitNode.getChild(0).getLastChild();
		var classNode:IParserNode = packageContentNode.addChild(create(AS3NodeKind.INTERFACE));
		var classNameNode:IParserNode = classNode.addChild(createText(AS3NodeKind.NAME, uid.localName));
		var classContentNode:IParserNode = classNode.addChild(create(AS3NodeKind.CONTENT));
		return compilationUnitNode;
	}
	
	private static function createCompilationUnit(packageName:String):IParserNode
	{
		var compilationUnitNode:IParserNode = create(AS3NodeKind.COMPILATION_UNIT);
		var packageNode:IParserNode = compilationUnitNode.addChild(create(AS3NodeKind.PACKAGE));
		var packageNameNode:IParserNode = packageNode.addChild(createText(AS3NodeKind.NAME, packageName));
		var packageContentNode:IParserNode = packageNode.addChild(create(AS3NodeKind.CONTENT));
		var compilationUnitContentNode:IParserNode = compilationUnitNode.addChild(create(AS3NodeKind.CONTENT));
		return compilationUnitNode;
	}
	
	
	
	
	
	//ASTNodeUtil.modListChanged(this, "add", modifier.name);
	public static function modListChanged(parent:INode, 
										  kind:String, 
										  stringValue:String):void
	{
		// compilation-unit/package/content/class/mod-list/mod
		var node:IParserNode = INode(parent).node;
		
		// compilation-unit/package/content/class/mod-list
		var modList:IParserNode =  ASTUtil.getNode(AS3NodeKind.MOD_LIST, node);
		
		// add a mod-list to node if not defined
		if (!modList)
			modList = node.addChildAt(create(AS3NodeKind.MOD_LIST), 1);
		
		if (kind == "add")
		{
			// add a mod to mod-list
			modList.addChild(createText(AS3NodeKind.MODIFIER, stringValue));
		}
		else if (kind == "remove" && modList)
		{
			spliceStringValue(modList, stringValue);
		}
	}
	
	private static function spliceStringValue(parent:IParserNode, 
											  stringValue:String):Boolean
	{
		var len:int = parent.numChildren;
		for (var i:int = 0; i < len; i++)
		{
			if (parent.children[i].stringValue == stringValue)
			{
				parent.children.splice(i, 1);
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 * @private
	 */
	public static function setSuperClass(type:IClassTypeNode, 
										 superType:IIdentifierNode):void
	{
		// compilation-unit/package/content/class/extends
		var node:IParserNode = INode(type).node;
		
		node.addChildAt(createText(AS3NodeKind.EXTENDS, superType.qualifiedName), 1);
	}
	
	/**
	 * @private
	 */
	public static function addImplementation(type:IClassTypeNode, 
											 implementation:IIdentifierNode):void
	{
		// compilation-unit/package/content/class/implements-list/implements
		
		var node:IParserNode = INode(type).node;
		var workNode:IParserNode = node;
		
		var impList:IParserNode =  ASTUtil.getNode(AS3NodeKind.IMPLEMENTS_LIST, workNode);
		
		// add a implements-list to node if not defined
		if (!impList)
			impList = workNode.addChildAt(create(AS3NodeKind.IMPLEMENTS_LIST), 1);
		// add a implements to implements-list, cannot be last child, content is
		impList.addChild(createText(AS3NodeKind.IMPLEMENTS, implementation.qualifiedName));
	}
	
	/**
	 * @private
	 */
	public static function addSuperInterface(type:IInterfaceTypeNode, 
											 superInterface:IIdentifierNode):void
	{
		// compilation-unit/package/content/interface/extends
		
		var node:IParserNode = INode(type).node;
		// add a extends to interface, cannot be last child, content is
		node.addChildAt(createText(AS3NodeKind.EXTENDS, superInterface.qualifiedName), node.numChildren - 1);
	}
	
	
	
	
	
	
	
	public static function createMetaDataParameter(aware:IMetaDataNode,
												   name:String,
												   value:String):IParserNode
		
	{
		var node:IParserNode = INode(aware).node; // meta-list/meta
		
		var paramList:IParserNode = ASTUtil.getNode(AS3NodeKind.PARAMETER_LIST, node);
		if (!paramList)
			paramList = node.addChild(create(AS3NodeKind.PARAMETER_LIST));
		
		var param:IParserNode = paramList.addChild(create(AS3NodeKind.PARAMETER));
		
		if (name)
			param.addChild(createText(AS3NodeKind.NAME, name));
		
		if (value)
			param.addChild(createText(AS3NodeKind.VALUE, value));
		
		return param;
	}
	

	

	
	/**
	 * @private
	 */
	public static function create(kind:String):IParserNode
	{
		return Node.create(kind, -1, -1, null) as IParserNode;
	}
	
	/**
	 * @private
	 */
	public static function createText(kind:String, text:String):IParserNode
	{
		return Node.create(kind, -1, -1, text) as IParserNode;
	}
	
}
}