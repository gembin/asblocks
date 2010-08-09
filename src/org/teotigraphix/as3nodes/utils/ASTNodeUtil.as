package org.teotigraphix.as3nodes.utils
{

import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ICommentAware;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IModifierAware;
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
	public static function createEmptyClass(uid:IIdentifierNode):Node
	{
		var compilationUnitNode:Node = createCompilationUnit(uid.packageName);
		var packageContentNode:Node = compilationUnitNode.getChild(0).getLastChild() as Node;
		var classNode:Node = packageContentNode.addChild(create(AS3NodeKind.CLASS)) as Node;
		var classNameNode:Node = classNode.addChild(createText(AS3NodeKind.NAME, uid.localName)) as Node;
		var classContentNode:Node = classNode.addChild(create(AS3NodeKind.CONTENT)) as Node;
		return compilationUnitNode;
	}
	
	/**
	 * @private
	 */
	public static function createEmptyInterface(uid:IIdentifierNode):Node
	{
		var compilationUnitNode:Node = createCompilationUnit(uid.packageName);
		var packageContentNode:Node = compilationUnitNode.getChild(0).getLastChild() as Node;
		var classNode:Node = packageContentNode.addChild(create(AS3NodeKind.INTERFACE)) as Node;
		var classNameNode:Node = classNode.addChild(createText(AS3NodeKind.NAME, uid.localName)) as Node;
		var classContentNode:Node = classNode.addChild(create(AS3NodeKind.CONTENT)) as Node;
		return compilationUnitNode;
	}
	
	private static function createCompilationUnit(packageName:String):Node
	{
		var compilationUnitNode:Node = create(AS3NodeKind.COMPILATION_UNIT);
		var packageNode:Node = compilationUnitNode.addChild(create(AS3NodeKind.PACKAGE)) as Node;
		var packageNameNode:Node = packageNode.addChild(createText(AS3NodeKind.NAME, packageName)) as Node;
		var packageContentNode:Node = packageNode.addChild(create(AS3NodeKind.CONTENT)) as Node;
		var compilationUnitContentNode:Node = compilationUnitNode.addChild(create(AS3NodeKind.CONTENT)) as Node;
		return compilationUnitNode;
	}
	
	/**
	 * @private
	 */
	public static function createAsDoc(aware:ICommentAware, description:String):Node
	{
		description = "/** " + description + " */";
		
		// need to append asdoc or create node, asdoc compilation-unit
		var asdocNode:Node = create(AS3NodeKind.AS_DOC);
		var compilationUnit:IParserNode = ParserFactory.instance.
			asdocParser.buildAst(Vector.<String>(description.split("\n")), "internal");
		
		aware.node.addChildAt(asdocNode, 1);
		asdocNode.addChild(compilationUnit);
		
		//var asdocNode:Node = createText(AS3NodeKind.AS_DOC, "/** " + description + " */");
		return asdocNode;
	}
	
	/**
	 * @private
	 */
	public static function addDocTag(node:IParserNode, 
									 name:String, 
									 body:String = null):Node
	{
		var content:IParserNode = node.getLastChild();
		
		var doctagList:Node =  ASTUtil.getNode(ASDocNodeKind.DOCTAG_LIST, content) as Node;
		if (!doctagList)
			doctagList = content.addChild(create(ASDocNodeKind.DOCTAG_LIST)) as Node;
		
		var docTag:Node = doctagList.addChild(create(ASDocNodeKind.DOCTAG)) as Node;
		docTag.addChild(createText(ASDocNodeKind.NAME, name));
		if (body)
		{
			var bodyNode:Node = create(ASDocNodeKind.BODY);
			bodyNode.addChild(createText(ASDocNodeKind.TEXT, body));
			docTag.addChild(bodyNode);
		}
		return docTag;
	}
	
	/**
	 * @private
	 */
	public static function addModifier(aware:IModifierAware, 
									   modifier:Modifier):void
	{
		// compilation-unit/package/content/class/mod-list/mod
		
		var node:IParserNode = INode(aware).node;
		var workNode:IParserNode = node;
		
		var modList:IParserNode =  ASTUtil.getNode(AS3NodeKind.MOD_LIST, workNode);
		
		// add a mod-list to node if not defined
		if (!modList)
			modList = workNode.addChildAt(create(AS3NodeKind.MOD_LIST), 1);
		// add a mod to mod-list, cannot be last child, content is
		modList.addChild(createText(AS3NodeKind.MODIFIER, modifier.name));
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
	
	
	
	
	
	
	
	
	
	/**
	 * @private
	 */
	private static function create(kind:String):Node
	{
		return Node.create(kind, -1, -1, null);
	}
	
	/**
	 * @private
	 */
	private static function createText(kind:String, text:String):Node
	{
		return Node.create(kind, -1, -1, text);
	}
	
}
}