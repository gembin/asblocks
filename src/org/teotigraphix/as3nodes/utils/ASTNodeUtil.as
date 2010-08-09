package org.teotigraphix.as3nodes.utils
{

import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IModifierAware;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.Node;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class ASTNodeUtil
{
	public static function createEmptyClass(uid:IIdentifierNode):Node
	{
		var compilationUnitNode:Node = Node.create(AS3NodeKind.COMPILATION_UNIT, -1, -1, null);
		var packageNode:Node = compilationUnitNode.addRawChild(AS3NodeKind.PACKAGE, -1, -1, null) as Node;
		var packageNameNode:Node = packageNode.addRawChild(AS3NodeKind.NAME, -1, -1, uid.packageName) as Node;
		var packageContentNode:Node = packageNode.addRawChild(AS3NodeKind.CONTENT, -1, -1, null) as Node;
		var classNode:Node = packageContentNode.addRawChild(AS3NodeKind.CLASS, -1, -1, null) as Node;
		var classNameNode:Node = classNode.addRawChild(AS3NodeKind.NAME, -1, -1, uid.localName) as Node;
		var classContentNode:Node = classNode.addRawChild(AS3NodeKind.CONTENT, -1, -1, null) as Node;
		var compilationUnitContentNode:Node = compilationUnitNode.addRawChild(AS3NodeKind.CONTENT, -1, -1, null) as Node;
		
		return compilationUnitNode;
	}
	
	public static function addModifier(aware:IModifierAware, modifier:Modifier):void
	{
		// compilation-unit/package/content/class/mod-list/mod
			
		var node:IParserNode = INode(aware).node;
		var workNode:IParserNode = node;
		
		var modList:IParserNode =  ASTUtil.getNode(AS3NodeKind.MOD_LIST, workNode);
		
		// add a mod-list to node if not defined
		if (!modList)
			modList = workNode.addChildAt(Node.create(AS3NodeKind.MOD_LIST, -1, -1, null), 1);
		// add a mod to mod-list, cannot be last child, content is
		modList.addChild(Node.create(AS3NodeKind.MODIFIER, -1, -1, modifier.name));
	}
}
}