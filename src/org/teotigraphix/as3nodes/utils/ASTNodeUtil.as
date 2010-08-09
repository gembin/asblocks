package org.teotigraphix.as3nodes.utils
{

import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.core.Node;

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
}
}