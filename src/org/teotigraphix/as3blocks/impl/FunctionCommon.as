package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.IArgumentNode;
import org.teotigraphix.as3blocks.api.IFunctionCommon;
import org.teotigraphix.as3blocks.utils.ASTUtil2;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;

public class FunctionCommon implements IFunctionCommon
{
	private var node:IParserNode;
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  arguments
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _arguments:Vector.<IArgumentNode>;
	
	/**
	 * doc
	 */
	public function get arguments():Vector.<IArgumentNode>
	{
		return _arguments;
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get type():String
	{
		var nameTypeInit:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		if (nameTypeInit)
			return nameTypeInit.getKind(AS3NodeKind.TYPE).stringValue;
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set type(value:String):void
	{
		// lambda/name-type-int/type
		var nameTypeInit:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		var existingType:IParserNode = nameTypeInit.getKind(AS3NodeKind.TYPE);
		if (value == null)
		{
			if (existingType != null)
			{
				nameTypeInit.removeChild(existingType);
			}
			return;
		}
		
		var newType:IParserNode = AS3FragmentParser.parseType(value);
		if (nameTypeInit == null) // SHOULDN'T BE
		{
			
		}
		else
		{
			nameTypeInit.setChildAt(newType, 0);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function FunctionCommon(node:IParserNode)
	{
		super();
		
		this.node = node;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	public function addParameter(name:String, 
								 type:String, 
								 defaultValue:String = null):IArgumentNode
	{
		var ast:IParserNode = ASTUtil2.newParamterAST();
		ast.addChild(ASTUtil2.newNameAST(name));
		ast.appendToken(TokenBuilder.newColumn());
		ast.addChild(ASTUtil2.newTypeAST(type));
		if (defaultValue)
		{
			ast.appendToken(TokenBuilder.newSpace());
			ast.appendToken(TokenBuilder.newEqual());
			ast.appendToken(TokenBuilder.newSpace());
			ast.addChild(ASTUtil2.newInitAST(defaultValue));
		}
		return createParameter(ast);
	}
	
	private function createParameter(ast:IParserNode):IArgumentNode
	{
		var paramList:IParserNode = node.getKind(AS3NodeKind.PARAMETER_LIST);
		if (paramList.numChildren > 0)
		{
			paramList.appendToken(TokenBuilder.newComma());
			paramList.appendToken(TokenBuilder.newSpace());
		}
		paramList.addChild(ast);
		return new ArgumentNode(ast);
	}
	
	/**
	 * TODO Docme
	 */
	public function removeParameter(name:String):IArgumentNode
	{
		return null;
	}
	
	/**
	 * TODO Docme
	 */
	public function addRestParam(name:String):IArgumentNode
	{
		return null;
	}
}
}