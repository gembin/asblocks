package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.api.IArgument;
import org.as3commons.asblocks.api.IAssignmentExpression;
import org.as3commons.asblocks.api.IBinaryExpression;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.IField;
import org.as3commons.asblocks.api.IMetaData;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.Visibility;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.api.IToken;
import org.as3commons.asblocks.parser.core.LinkedListToken;
import org.as3commons.asblocks.parser.core.ParentheticListUpdateDelegate;
import org.as3commons.asblocks.parser.core.TokenNode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.utils.ASTUtil;
import org.as3commons.mxmlblocks.parser.api.MXMLNodeKind;

public class ASTBuilder
{
	public static function newXMLNS(localName:String, uri:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(MXMLNodeKind.XML_NS);
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newToken("xmlns", "xmlns"));
		if (localName)
		{
			var colon:LinkedListToken = TokenBuilder.newColon();
			var name:IParserNode = ASTUtil.newAST(MXMLNodeKind.LOCAL_NAME, localName);
			name.startToken.beforeInsert(colon);
			name.startToken = colon;
			ast.addChild(name);
		}
		var assign:LinkedListToken = TokenBuilder.newAssign();
		var uriAST:IParserNode = ASTUtil.newAST(MXMLNodeKind.URI, uri);
		uriAST.startToken.beforeInsert(assign);
		uriAST.startToken = assign;
		assign.afterInsert(TokenBuilder.newQuote());
		ast.addChild(uriAST);
		uriAST.appendToken(TokenBuilder.newQuote());
		return ast;
	}
	
	public static function newAttribute(name:String, value:String, state:String = null):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(MXMLNodeKind.ATT);
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(ASTUtil.newAST(MXMLNodeKind.NAME, name));
		
		if (state)
		{
			var dot:LinkedListToken = TokenBuilder.newDot();
			var stateAST:IParserNode = ASTUtil.newAST(MXMLNodeKind.STATE, state);
			stateAST.startToken.beforeInsert(dot);
			stateAST.startToken = dot;
			ast.addChild(stateAST);
		}
		
		ast.appendToken(TokenBuilder.newAssign());
		ast.appendToken(TokenBuilder.newQuote());
		ast.addChild(ASTUtil.newAST(MXMLNodeKind.VALUE, value));
		ast.appendToken(TokenBuilder.newQuote());
		return ast;
	}
	
	public static function newTag(name:String, binding:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST("tag-list");
		var body:IParserNode = ASTUtil.newAST("body");
		
		ast.appendToken(TokenBuilder.newLess());
		
		if (binding)
		{
			ast.addChild(ASTUtil.newAST("binding", binding));
			ast.appendToken(TokenBuilder.newColon());
		}
		
		ast.addChild(ASTUtil.newAST("local-name", name));
		ast.appendToken(TokenBuilder.newGreater());
		
		ast.addChild(body);
		
		ast.appendToken(TokenBuilder.newNewline());
		ast.appendToken(TokenBuilder.newToken("text", "</"));
		
		if (binding)
		{
			ast.appendToken(TokenBuilder.newToken("binding", binding));
			ast.appendToken(TokenBuilder.newColon());
		}
		
		ast.appendToken(TokenBuilder.newToken("text", name));
		ast.appendToken(TokenBuilder.newGreater());
		
		return ast;
	}
	
	public static function newScriptTag(code:String):IParserNode
	{
		if (code == null)
		{
			code = "";
		}
		
		var ast:IParserNode = ASTUtil.newAST("script");
		
		var contentAST:IParserNode = AS3FragmentParser.parseClassContent(code);
		
		ParentheticListUpdateDelegate(TokenNode(contentAST).tokenListUpdater).
			setBoundaries("lcdata", "rcdata");
		
		contentAST.startToken.text = "<![CDATA[";
		contentAST.startToken.kind = "lcdata";
		contentAST.stopToken.text = "]]>";
		contentAST.stopToken.kind = "rcdata";
		
		var body:IParserNode = ASTUtil.newAST(MXMLNodeKind.BODY);
		
		var binding:String = "fx";
		var name:String = "Script";
		
		ast.appendToken(TokenBuilder.newLess());
		
		if (binding)
		{
			ast.addChild(ASTUtil.newAST(MXMLNodeKind.BINDING, binding));
			ast.appendToken(TokenBuilder.newColon());
		}
		
		ast.addChild(ASTUtil.newAST(MXMLNodeKind.LOCAL_NAME, name));
		ast.appendToken(TokenBuilder.newGreater());
		ast.appendToken(TokenBuilder.newNewline());
		
		//ASTUtil.addChildWithIndentation(body, contentAST);
		body.addChild(contentAST);
		ast.addChild(body);
		
		contentAST.appendToken(TokenBuilder.newNewline());
		ast.appendToken(TokenBuilder.newNewline());
		ast.appendToken(TokenBuilder.newToken("text", "</"));
		
		if (binding)
		{
			ast.appendToken(TokenBuilder.newToken(MXMLNodeKind.BINDING, binding));
			ast.appendToken(TokenBuilder.newColon());
		}
		
		ast.appendToken(TokenBuilder.newToken("text", name));
		ast.appendToken(TokenBuilder.newGreater());
		
		return ast;
	}
	
	public static function newMetadataTag(code:String):IParserNode
	{
		if (code == null)
		{
			code = "";
		}
		
		var ast:IParserNode = ASTUtil.newAST("script");
		
		var contentAST:IParserNode = AS3FragmentParser.parseClassContent(code);
		
		ParentheticListUpdateDelegate(TokenNode(contentAST).tokenListUpdater).
			setBoundaries("lcdata", "rcdata");
		
		contentAST.startToken.text = "<![CDATA[";
		contentAST.startToken.kind = "lcdata";
		contentAST.stopToken.text = "]]>";
		contentAST.stopToken.kind = "rcdata";
		
		var body:IParserNode = ASTUtil.newAST(MXMLNodeKind.BODY);
		
		var binding:String = "fx";
		var name:String = "Metadata";
		
		ast.appendToken(TokenBuilder.newLess());
		
		if (binding)
		{
			ast.addChild(ASTUtil.newAST(MXMLNodeKind.BINDING, binding));
			ast.appendToken(TokenBuilder.newColon());
		}
		
		ast.addChild(ASTUtil.newAST(MXMLNodeKind.LOCAL_NAME, name));
		ast.appendToken(TokenBuilder.newGreater());
		ast.appendToken(TokenBuilder.newNewline());
		
		//ASTUtil.addChildWithIndentation(body, contentAST);
		body.addChild(contentAST);
		ast.addChild(body);
		
		contentAST.appendToken(TokenBuilder.newNewline());
		ast.appendToken(TokenBuilder.newNewline());
		ast.appendToken(TokenBuilder.newToken("text", "</"));
		
		if (binding)
		{
			ast.appendToken(TokenBuilder.newToken(MXMLNodeKind.BINDING, binding));
			ast.appendToken(TokenBuilder.newColon());
		}
		
		ast.appendToken(TokenBuilder.newToken("text", name));
		ast.appendToken(TokenBuilder.newGreater());
		
		return ast;
	}
	
	public static function newType(type:String):IParserNode
	{
		var colon:LinkedListToken = TokenBuilder.newColon();
		var ast:IParserNode = AS3FragmentParser.parseType(type);
		ast.startToken.beforeInsert(colon);
		ast.startToken = colon;
		return ast;
	}
	
	public static function newParameter(name:String, type:String, defaultValue:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newParamterAST();
		var nti:IParserNode = ast.getKind(AS3NodeKind.NAME_TYPE_INIT);
		nti.addChild(ASTUtil.newNameAST(name));
		
		var colon:LinkedListToken = TokenBuilder.newColon();
		var typeAST:IParserNode = ASTUtil.newTypeAST(type);
		typeAST.startToken.beforeInsert(colon);
		typeAST.startToken = colon;
		nti.addChild(typeAST);
		
		if (defaultValue)
		{
			nti.appendToken(TokenBuilder.newSpace());
			nti.appendToken(TokenBuilder.newAssign());
			nti.appendToken(TokenBuilder.newSpace());
			nti.addChild(ASTUtil.newInitAST(defaultValue));
		}
		
		return ast;
	}
	
	public static function newRestParameter(name:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.PARAMETER);
		var restAST:IParserNode = ASTUtil.newAST(AS3NodeKind.REST, name);
		ast.addChild(restAST);
		var rest:LinkedListToken = TokenBuilder.newToken(AS3NodeKind.REST_PARM, "...");
		ast.startToken.beforeInsert(rest);
		ast.startToken = rest;
		return ast;
	}
	
	public static function newMetaData(name:String):IMetaData
	{
		var ast:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.META, 
			AS3NodeKind.LBRACKET, "[", 
			AS3NodeKind.RBRACKET, "]");
		
		ast.addChild(ASTUtil.newNameAST(name));
		
		return new MetaDataNode(ast);
	}
	
	public static function newSuper(arguments:Vector.<IArgument>):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.SUPER, "super");
		var args:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ARGUMENTS, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		ast.addChild(args);
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newSwitch(condition:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.SWITCH, "switch");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newCondition(condition));
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock(AS3NodeKind.CASES);
		ast.addChild(block);
		return ast;
	}
	/*
	switch
	switch/condition
	switch/cases
	switch/cases/case
	switch/cases/case/label|default
	switch/cases/case/switch-block
	*/
	public static function newSwitchCase(node:IParserNode, label:String):IParserNode
	{
		var cases:IParserNode = node.getKind(AS3NodeKind.CASES);
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.CASE, "case");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(AS3FragmentParser.parseExpression(label));
		ast.appendToken(TokenBuilder.newColon());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.SWITCH_BLOCK));
		ASTUtil.addChildWithIndentation(cases, ast);
		return ast;
	}
	
	public static function newSwitchDefault(node:IParserNode):IParserNode
	{
		var cases:IParserNode = node.getKind(AS3NodeKind.CASES);
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.DEFAULT, "default");
		ast.appendToken(TokenBuilder.newColon());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.SWITCH_BLOCK));
		ASTUtil.addChildWithIndentation(cases, ast);
		return ast;
	}
	
	public static function newXMLComment(ast:IParserNode, text:String):IToken
	{
		var comment:LinkedListToken = TokenBuilder.newSLComment("<!-- " + text + "-->");
		var indent:String = ASTUtil.findIndentForComment(ast);
		var stop:LinkedListToken = ASTUtil.findTagStop(ast).previous; // nl
		
		var nl:LinkedListToken = TokenBuilder.newNewline();
		stop.beforeInsert(nl);
		var sp:LinkedListToken = TokenBuilder.newWhiteSpace(indent + "\t");
		nl.afterInsert(sp);
		sp.afterInsert(comment);
		
		
		
		//ast.appendToken(TokenBuilder.newNewline());
		//ast.appendToken(TokenBuilder.newWhiteSpace(indent));
		//ast.appendToken(comment);
		return comment;
	}
	
	public static function newComment(ast:IParserNode, text:String):IToken
	{
		var comment:LinkedListToken = TokenBuilder.newSLComment("//" + text);
		var indent:String = ASTUtil.findIndentForComment(ast);
		ast.appendToken(TokenBuilder.newNewline());
		ast.appendToken(TokenBuilder.newWhiteSpace(indent));
		ast.appendToken(comment);
		return comment;
	}
	
	public static function newTryStatement():IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.TRY_STMNT);
		ast.addChild(newTry());
		return ast;
	}
	
	public static function newTry():IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.TRY, "try");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newBlock());
		return ast;
	}
	
	public static function newCatchClause(name:String, type:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.CATCH, "catch");
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newLParen());
		ast.addChild(ASTUtil.newNameAST(name));
		if (type)
		{
			ast.appendToken(TokenBuilder.newColon());
			ast.addChild(ASTUtil.newTypeAST(type));
		}
		ast.appendToken(TokenBuilder.newRParen());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newBlock());
		return ast;
	}
	
	public static function newFinallyClause():IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FINALLY, "finally");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newBlock());
		return ast;
	}
	
	public static function newForInit(initializer:IParserNode):IParserNode
	{
		if (!initializer)
			return ASTUtil.newAST(AS3NodeKind.INIT);
		
		var ast:IParserNode = initializer;
		// check that node is init
		if (!initializer.isKind(AS3NodeKind.INIT))
		{
			ast = ASTUtil.newAST(AS3NodeKind.INIT);
			ast.addChild(initializer);
		}
		return ast;
	}
	
	public static function newForCond(condition:IParserNode):IParserNode
	{
		if (!condition)
			return ASTUtil.newAST(AS3NodeKind.COND);
		
		var ast:IParserNode = condition;
		// check that node is cond
		if (!condition.isKind(AS3NodeKind.COND))
		{
			ast = ASTUtil.newAST(AS3NodeKind.COND);
			ast.addChild(condition);
		}
		return ast;
	}
	
	public static function newForIter(iterator:IParserNode):IParserNode
	{
		if (!iterator)
			return ASTUtil.newAST(AS3NodeKind.ITER);
		
		var ast:IParserNode = iterator;
		// check that node is iter
		if (!iterator.isKind(AS3NodeKind.ITER))
		{
			ast = ASTUtil.newAST(AS3NodeKind.ITER);
			ast.addChild(iterator);
		}
		return ast;
	}
	
	public static function newFor(initializer:IParserNode, 
								  condition:IParserNode, 
								  iterator:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FOR, "for");
		
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newLParen());
		
		ast.addChild(newForInit(initializer));
		
		ast.appendToken(TokenBuilder.newSemi());
		ast.appendToken(TokenBuilder.newSpace());
		
		ast.addChild(newForCond(condition));
		
		ast.appendToken(TokenBuilder.newSemi());
		ast.appendToken(TokenBuilder.newSpace());
		
		ast.addChild(newForIter(iterator));
		
		ast.appendToken(TokenBuilder.newRParen());
		return ast;
	}
	
	public static function newForEachIn(declaration:IParserNode, 
										target:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FOREACH, "for");
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newEach());
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newLParen());
		var initAST:IParserNode = ASTUtil.newAST(AS3NodeKind.INIT);
		initAST.addChild(declaration);
		ast.addChild(initAST);
		ast.appendToken(TokenBuilder.newSpace());
		var inAST:IParserNode = ASTUtil.newAST(AS3NodeKind.IN, "in");
		inAST.appendToken(TokenBuilder.newSpace());
		inAST.addChild(target);
		ast.addChild(inAST);
		ast.appendToken(TokenBuilder.newRParen());
		return ast;
	}
	
	public static function newForIn(declaration:IParserNode, 
									target:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FORIN, "for");
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newLParen());
		var initAST:IParserNode = ASTUtil.newAST(AS3NodeKind.INIT);
		initAST.addChild(declaration);
		ast.addChild(initAST);
		ast.appendToken(TokenBuilder.newSpace());
		var inAST:IParserNode = ASTUtil.newAST(AS3NodeKind.IN, "in");
		inAST.appendToken(TokenBuilder.newSpace());
		inAST.addChild(target);
		ast.addChild(inAST);
		ast.appendToken(TokenBuilder.newRParen());
		return ast;
	}
	
	public static function newMethod(name:String, 
									 visibility:Visibility, 
									 returnType:String):IMethod
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FUNCTION);
		var mods:IParserNode = ASTUtil.newAST(AS3NodeKind.MOD_LIST);
		mods.addChild(ASTUtil.newAST(AS3NodeKind.MODIFIER, visibility.name));
		ast.addChild(mods);
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newFunction());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.ACCESSOR_ROLE));
		var n:IParserNode = ASTUtil.newAST(AS3NodeKind.NAME, name);
		ast.addChild(n);
		var params:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.PARAMETER_LIST,
			AS3NodeKind.LPAREN, "(",
			AS3NodeKind.RPAREN, ")");
		ast.addChild(params);
		if (returnType)
		{
			var colon:LinkedListToken = TokenBuilder.newColon();
			var typeAST:IParserNode = AS3FragmentParser.parseType(returnType);
			typeAST.startToken.beforeInsert(colon);
			typeAST.startToken = colon;
			ast.addChild(typeAST);
		}
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock();
		ast.addChild(block);
		
		return new MethodNode(ast);
	}
	
	public static function newInterfaceMethod(name:String,
											  returnType:String):IMethod
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FUNCTION);
		ast.appendToken(TokenBuilder.newFunction());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.ACCESSOR_ROLE));
		var n:IParserNode = ASTUtil.newAST(AS3NodeKind.NAME, name);
		ast.addChild(n);
		var params:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.PARAMETER_LIST,
			AS3NodeKind.LPAREN, "(",
			AS3NodeKind.RPAREN, ")");
		ast.addChild(params);
		if (returnType)
		{
			var colon:LinkedListToken = TokenBuilder.newColon();
			var typeAST:IParserNode = AS3FragmentParser.parseType(returnType);
			typeAST.startToken.beforeInsert(colon);
			typeAST.startToken = colon;
			ast.addChild(typeAST);
		}
		ast.appendToken(TokenBuilder.newSemi());
		
		return new MethodNode(ast);
	}
	
	/**
	 * Builds a <code>IField</code>'s AST.
	 * 
	 * @param name A String name.
	 * @param name The field's Visibility.
	 * @param name A String type.
	 * @return A <code>IField</code> instance with built AST.
	 */
	public static function newField(name:String, 
									visibility:Visibility, 
									type:String):IField
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FIELD_LIST);
		// field-list/mod-list
		var mods:IParserNode = ASTUtil.newAST(AS3NodeKind.MOD_LIST);
		var mod:IParserNode = ASTUtil.newAST(AS3NodeKind.MODIFIER, visibility.name);
		mods.addChild(mod);
		mod.appendToken(TokenBuilder.newSpace());
		ast.addChild(mods);
		// field-list/field-role
		var frole:IParserNode = ASTUtil.newAST(AS3NodeKind.FIELD_ROLE);
		frole.addChild(ASTUtil.newAST(AS3NodeKind.VAR, "var"));
		ast.addChild(frole);
		ast.appendToken(TokenBuilder.newSpace());
		// field-list/name-type-init
		var nti:IParserNode = ASTUtil.newAST(AS3NodeKind.NAME_TYPE_INIT);
		ast.addChild(nti);
		// field-list/name-type-init/name
		nti.addChild(ASTUtil.newNameAST(name));
		if (type)
		{
			// field-list/name-type-init/type
			nti.appendToken(TokenBuilder.newColon());
			nti.addChild(ASTUtil.newTypeAST(type));
		}
		ast.appendToken(TokenBuilder.newSemi());
		return new FieldNode(ast);
	}
	
	public static function _synthesizeClass(qualifiedName:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.COMPILATION_UNIT);
		var past:IParserNode = ASTUtil.newAST(AS3NodeKind.PACKAGE, "package");
		
		//past.appendToken(TokenBuilder.newSpace());
		ast.addChild(past);
		past.appendToken(TokenBuilder.newSpace());
		
		var packageName:String = packageNameFrom(qualifiedName);
		if (packageName)
		{
			past.addChild(AS3FragmentParser.parseName(packageName));
			past.appendToken(TokenBuilder.newSpace());
		}
		
		var block:IParserNode = newBlock(AS3NodeKind.CONTENT);
		past.addChild(block);
		
		var className:String = typeNameFrom(qualifiedName);
		var clazz:IParserNode = synthesizeAS3Class(className);
		ASTUtil.addChildWithIndentation(block, clazz);
		
		return ast;
	}
	
	public static function synthesizeClass(qualifiedName:String):ICompilationUnit
	{
		return new CompilationUnitNode(_synthesizeClass(qualifiedName));
	}
	
	public static function synthesizeInterface(qualifiedName:String):ICompilationUnit
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.COMPILATION_UNIT);
		var past:IParserNode = ASTUtil.newAST(AS3NodeKind.PACKAGE, "package");
		
		ast.addChild(past);
		past.appendToken(TokenBuilder.newSpace());
		
		var packageName:String = packageNameFrom(qualifiedName);
		if (packageName)
		{
			past.addChild(AS3FragmentParser.parseName(packageName));
			past.appendToken(TokenBuilder.newSpace());
		}
		
		var block:IParserNode = newBlock(AS3NodeKind.CONTENT);
		past.addChild(block);
		
		var interfaceName:String = typeNameFrom(qualifiedName);
		var interfaze:IParserNode = synthesizeAS3Interface(interfaceName);
		ASTUtil.addChildWithIndentation(block, interfaze);
		
		return new CompilationUnitNode(ast);
	}
	
	public static function synthesizeFunction(qualifiedName:String, returnType:String):ICompilationUnit
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.COMPILATION_UNIT);
		var past:IParserNode = ASTUtil.newAST(AS3NodeKind.PACKAGE, "package");
		
		ast.addChild(past);
		past.appendToken(TokenBuilder.newSpace());
		
		var packageName:String = packageNameFrom(qualifiedName);
		if (packageName)
		{
			past.addChild(AS3FragmentParser.parseName(packageName));
			past.appendToken(TokenBuilder.newSpace());
		}
		
		var block:IParserNode = newBlock(AS3NodeKind.CONTENT);
		past.addChild(block);
		
		var functionName:String = typeNameFrom(qualifiedName);
		var func:IParserNode = synthesizeAS3Function(functionName, returnType);
		ASTUtil.addChildWithIndentation(block, func);
		
		return new CompilationUnitNode(ast);
	}
	
	public static function synthesizeApplication(qualifiedName:String,
												 superQualifiedName:String):ICompilationUnit
	{
		var packageName:String = packageNameFrom(superQualifiedName);
		var className:String = typeNameFrom(superQualifiedName);
		
		var appAST:IParserNode = ASTUtil.newAST(MXMLNodeKind.COMPILATION_UNIT);
		appAST.addChild(ASTUtil.newAST(MXMLNodeKind.PROC_INST, 
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>"));
		appAST.appendToken(TokenBuilder.newNewline());
		
		var tag:IParserNode = newTag(className, null);
		appAST.addChild(tag);
		
		var ast:IParserNode = _synthesizeClass(qualifiedName);
		
		var unit:ICompilationUnit = new ApplicationUnitNode(ast, appAST);
		unit.packageName = packageNameFrom(qualifiedName);
		unit.typeNode.name = typeNameFrom(qualifiedName);
		IClassType(unit.typeNode).superClass = superQualifiedName;
		return unit;
	}
	
	private static function synthesizeAS3Class(className:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.CLASS);
		//var metas:IParserNode = ASTUtil.newAST(AS3NodeKind.META_LIST);
		//ast.addChild(metas);
		var mods:IParserNode = ASTUtil.newAST(AS3NodeKind.MOD_LIST);
		var mod:IParserNode = ASTUtil.newAST(AS3NodeKind.MODIFIER, "public");
		mod.appendToken(TokenBuilder.newSpace());
		mods.addChild(mod);
		ast.addChild(mods);
		ast.appendToken(TokenBuilder.newClass());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.NAME, className));
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newBlock(AS3NodeKind.CONTENT));
		return ast;
	}
	
	private static function synthesizeAS3Interface(name:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.INTERFACE);
		//var metas:IParserNode = ASTUtil.newAST(AS3NodeKind.META_LIST);
		//ast.addChild(metas);
		var mods:IParserNode = ASTUtil.newAST(AS3NodeKind.MOD_LIST);
		var mod:IParserNode = ASTUtil.newAST(AS3NodeKind.MODIFIER, "public");
		mod.appendToken(TokenBuilder.newSpace());
		mods.addChild(mod);
		ast.addChild(mods);
		ast.appendToken(TokenBuilder.newInterface());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.NAME, name));
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newBlock(AS3NodeKind.CONTENT));
		return ast;
	}
	
	private static function synthesizeAS3Function(name:String, returnType:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FUNCTION);
		var mods:IParserNode = ASTUtil.newAST(AS3NodeKind.MOD_LIST);
		mods.addChild(ASTUtil.newAST(AS3NodeKind.MODIFIER, Visibility.PUBLIC.toString()));
		ast.addChild(mods);
		ast.addChild(ASTUtil.newAST(AS3NodeKind.ACCESSOR_ROLE));
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newFunction());
		ast.appendToken(TokenBuilder.newSpace());
		var n:IParserNode = ASTUtil.newAST(AS3NodeKind.NAME, name);
		ast.addChild(n);
		var params:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.PARAMETER_LIST,
			AS3NodeKind.LPAREN, "(",
			AS3NodeKind.RPAREN, ")");
		ast.addChild(params);
		if (returnType)
		{
			var colon:LinkedListToken = TokenBuilder.newColon();
			var typeAST:IParserNode = AS3FragmentParser.parseType(returnType);
			typeAST.startToken.beforeInsert(colon);
			typeAST.startToken = colon;
			ast.addChild(typeAST);
		}
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock();
		ast.addChild(block);
		return ast;
	}
	
	public static function packageNameFrom(qualifiedName:String):String
	{
		var p:int = qualifiedName.lastIndexOf(".");
		if (p == -1) 
		{
			return null;
		}
		return qualifiedName.substring(0, p);
	}
	
	public static function typeNameFrom(qualifiedName:String):String
	{
		var p:int = qualifiedName.lastIndexOf('.');
		if (p == -1) 
		{
			return qualifiedName;
		}
		return qualifiedName.substring(p + 1);
	}
	
	
	public static function newBreak(label:String = null):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.BREAK, "break");
		if (label)
		{
			ast.appendToken(TokenBuilder.newSpace());
			ast.addChild(ASTUtil.newPrimaryAST(label));
		}
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newContinue(label:String = null):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.CONTINUE, "continue");
		if (label)
		{
			ast.appendToken(TokenBuilder.newSpace());
			ast.addChild(ASTUtil.newPrimaryAST(label));
		}
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newDeclaration(assignment:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.DEC_LIST);
		var role:IParserNode = ASTUtil.newAST(AS3NodeKind.DEC_ROLE, "var");
		ast.addChild(role);
		if (assignment)
		{
			ast.appendToken(TokenBuilder.newSpace());
			ast.addChild(assignment);
		}
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newDefaultXMLNamespace(namespace:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.XML_NAMESPACE);
		ast.appendToken(TokenBuilder.newDefault());
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newXML());
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newNamespace());
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newAssign());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(namespace);
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newWhile(condition:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.WHILE, "while");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newCondition(condition));
		var block:IParserNode = newBlock();
		ast.addChild(block);
		return ast;
	}
	
	public static function newWith(condition:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.WITH, "with");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newCondition(condition));
		var block:IParserNode = newBlock();
		ast.addChild(block);
		return ast;
	}
	
	public static function newDoWhile(condition:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.DO, "do");
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock();
		ast.addChild(block);
		ast.appendToken(TokenBuilder.newSpace());
		ast.appendToken(TokenBuilder.newWhile());
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(newCondition(condition));
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	public static function newObjectField(name:String, 
										  node:IParserNode):IParserNode
	{
		var field:IParserNode = ASTUtil.newAST(AS3NodeKind.PROP);
		field.addChild(AS3FragmentParser.parsePrimaryExpression(name));
		field.appendToken(TokenBuilder.newColon());
		field.appendToken(TokenBuilder.newSpace());
		field.addChild(node);
		return field;
	}
	
	public static function newBlock(kind:String = null):IParserNode
	{
		if (!kind)
		{
			kind = AS3NodeKind.BLOCK;
		}
		
		var ast:IParserNode = ASTUtil.newParentheticAST(
			kind, 
			AS3NodeKind.LCURLY, "{", 
			AS3NodeKind.RCURLY, "}");
		var nl:LinkedListToken = TokenBuilder.newNewline();
		// insert the \n after the {
		ast.initialInsertionAfter.afterInsert(nl);
		// set new insertion point after \n
		ast.initialInsertionAfter = nl;
		return ast;
		
	}
	
	public static function newIf(ast:IParserNode):IParserNode
	{
		//var ast:IParserNode = AS3FragmentParser.parseExpression(condition);
		
		var ifStmnt:IParserNode = ASTUtil.newAST(AS3NodeKind.IF, "if");
		ifStmnt.appendToken(TokenBuilder.newSpace());
		ifStmnt.addChild(newCondition(ast));
		ifStmnt.appendToken(TokenBuilder.newSpace());
		ifStmnt.addChild(newBlock());
		
		return ifStmnt;
	}
	
	
	public static function newLabel(ast:IParserNode):IParserNode
	{
		var result:IParserNode = ASTUtil.newAST(AS3NodeKind.LABEL);
		result.addChild(ast);
		result.appendToken(TokenBuilder.newSpace());
		result.appendToken(TokenBuilder.newColon());
		result.appendToken(TokenBuilder.newSpace());
		result.addChild(newBlock());
		return result;
	}
	
	public static function newForLabel(ast:IParserNode, kind:String):IParserNode
	{
		var result:IParserNode = ASTUtil.newAST(AS3NodeKind.LABEL);
		result.addChild(ast);
		result.appendToken(TokenBuilder.newSpace());
		result.appendToken(TokenBuilder.newColon());
		result.appendToken(TokenBuilder.newSpace());
		if (kind == AS3NodeKind.FOR)
		{
			result.addChild(newFor(null, null, null));
		}
		
		return result;
	}
	
	public static function newReturn(expression:IParserNode = null):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.RETURN, "return");
		if (expression)
		{
			ast.appendToken(TokenBuilder.newSpace());
			ast.addChild(expression);
		}
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newThis(expression:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.THIS, "this");
		ast.appendToken(TokenBuilder.newDot());
		ast.addChild(expression);
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newThrow(expression:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.THROW, "throw");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(expression);
		ast.appendToken(TokenBuilder.newSemi());
		return ast;
	}
	
	public static function newCondition(expr:IParserNode):IParserNode
	{
		var cond:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.CONDITION, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		cond.addChild(expr);
		return cond;
	}
	
	public static function newArrayLiteral():IParserNode
	{
		var ast:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ARRAY, 
			AS3NodeKind.LBRACKET, "[", 
			AS3NodeKind.RBRACKET, "]");
		return ast;
		
	}
	
	public static function newObjectLiteral():IParserNode
	{
		var ast:IParserNode = newBlock(AS3NodeKind.OBJECT);
		return ast;
	}
	
	public static function newFunctionLiteral():IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.LAMBDA);
		ast.appendToken(TokenBuilder.newFunction());
		//ast.appendToken(TokenBuilder.newSpace());
		// TODO: placeholder for name?
		var paren:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.PARAMETER_LIST, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		ast.addChild(paren);
		// added, best practices say put :void as default
		
		var colon:LinkedListToken = TokenBuilder.newColon();
		var typeAST:IParserNode = AS3FragmentParser.parseType("void");
		typeAST.startToken.beforeInsert(colon);
		typeAST.startToken = colon;
		ast.addChild(typeAST);
		
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = newBlock();
		ast.addChild(block);
		return ast;
	}
	
	public static function newInvocationExpression(subExpr:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.CALL);
		ast.addChild(subExpr);
		var arguments:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ARGUMENTS, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		ast.addChild(arguments);
		return ast;
	}
	
	public static function newNewExpression(subExpr:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.NEW, "new");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(subExpr);
		var arguments:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ARGUMENTS, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		ast.addChild(arguments);
		return ast;
	}
	
	
	public static function newPostfixExpression(op:LinkedListToken, 
												subExpr:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newPostfixAST(op);
		TokenNode(ast).noUpdate = true;
		ast.addChild(subExpr);
		TokenNode(ast).noUpdate = false;
		ast.startToken = subExpr.startToken;
		subExpr.stopToken.next = op;
		return ast;
	}
	
	public static function newPrefixExpression(op:LinkedListToken, 
											   subExpr:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newPrefixAST(op);
		ast.addChild(subExpr);
		return ast;
	}
	
	public static function newFieldAccessExpression(target:IParserNode, 
													name:IParserNode):IParserNode
	{
		var op:LinkedListToken = TokenBuilder.newDot();
		var ast:IParserNode = ASTUtil.newTokenAST(op);
		
		TokenNode(ast).noUpdate = true;
		ast.addChild(target);
		ast.addChild(name);
		TokenNode(ast).noUpdate = false;
		
		target.stopToken.next = op;
		name.startToken.previous = op;
		
		ast.startToken = target.startToken;
		ast.stopToken = name.stopToken;
		
		return ast;
	}
	
	public static function newConditionalExpression(conditionExpression:IParserNode, 
													thenExpression:IParserNode,
													elseExpression:IParserNode):IParserNode
	{
		var op:LinkedListToken = TokenBuilder.newQuestion();
		var colon:LinkedListToken = TokenBuilder.newColon();
		var ast:IParserNode = ASTUtil.newTokenAST(op);
		
		TokenNode(ast).noUpdate = true;
		ast.addChild(conditionExpression);
		conditionExpression.stopToken.next = op;
		ast.addChild(thenExpression);
		thenExpression.startToken.previous = op;
		thenExpression.stopToken.next = colon;
		ast.addChild(elseExpression);
		elseExpression.startToken.previous = colon;
		ast.startToken = conditionExpression.startToken;
		ast.stopToken = elseExpression.stopToken;
		TokenNode(ast).noUpdate = false;
		
		spaceEitherSide(op);
		spaceEitherSide(colon);
		
		return ast;
	}
	
	
	public static function newAssignExpression(op:LinkedListToken, 
											   left:IExpression,
											   right:IExpression):IAssignmentExpression
	{
		// assignment[left,op(assign[=]),right]
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.ASSIGNMENT);
		
		var leftAST:IParserNode = left.node;
		var rightAST:IParserNode = right.node;
		
		if (precidence(ast) < precidence(leftAST))
		{
			leftAST = parenthise(leftAST);
		}
		if (precidence(ast) < precidence(rightAST))
		{
			rightAST = parenthise(rightAST);
		}
		
		ast.addChild(leftAST);
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.ASSIGN, op.text));
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(rightAST);
		
		return new AssignmentExpressionNode(ast);
	}
	
	
	public static function newBinaryExpression(op:LinkedListToken, 
											   left:IExpression,
											   right:IExpression):IBinaryExpression
	{
		var ast:IParserNode = ASTUtil.newBinaryAST(op);
		var opAST:IParserNode = ASTUtil.newTokenAST(op);
		
		var leftExpr:IParserNode = left.node;
		var rightExpr:IParserNode = right.node;
		
		if (precidence(opAST) < precidence(leftExpr))
		{
			leftExpr = parenthise(leftExpr);
		}
		if (precidence(opAST) < precidence(rightExpr))
		{
			rightExpr = parenthise(rightExpr);
		}
		
		TokenNode(ast).noUpdate = true;
		ast.addChild(leftExpr);
		ast.addChild(opAST);
		ast.addChild(rightExpr);
		TokenNode(ast).noUpdate = false;
		
		leftExpr.stopToken.next = op;
		rightExpr.startToken.previous = op;
		
		ast.startToken = leftExpr.startToken;
		ast.stopToken = rightExpr.stopToken;
		
		spaceEitherSide(op);
		
		return new BinaryExpressionNode(ast);
	}
	
	
	
	
	
	private static function spaceEitherSide(token:LinkedListToken):void
	{
		token.beforeInsert(TokenBuilder.newSpace());
		token.afterInsert(TokenBuilder.newSpace());
	}
	
	/**
	 * Escape the given String and place within double quotes so that it
	 * will be a valid ActionScript string literal.
	 */
	public static function escapeString(string:String):String
	{
		var result:String = "\"";
		
		var len:int = string.length;
		for (var i:int = 0; i < len; i++) 
		{
			var c:String = string.charAt(i);
			
			switch (c) 
			{
				case '\n':
					result += "\\n";
					break;
				case '\t':
					result += "\\t";
					break;
				case '\r':
					result += "\\r";
					break;
				case '"':
					result += "\\\"";
					break;
				case '\\':
					result += "\\\\";
					break;
				default:
					result += c;
			}
		}
		result += '"';
		
		return result;
	}
	
	private static function parenthise(expression:IParserNode):IParserNode
	{
		var result:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ENCAPSULATED, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		result.addChild(expression);
		return result;
	}
	
	
	private static function precidence(ast:IParserNode):int
	{
		switch (ast.kind) 
		{
			case AS3NodeKind.ASSIGN:
			case AS3NodeKind.STAR_ASSIGN:
			case AS3NodeKind.DIV_ASSIGN:
			case AS3NodeKind.MOD_ASSIGN:
			case AS3NodeKind.PLUS_ASSIGN:
			case AS3NodeKind.MINUS_ASSIGN:
			case AS3NodeKind.SL_ASSIGN:
			case AS3NodeKind.SR_ASSIGN:
			case AS3NodeKind.BSR_ASSIGN:
			case AS3NodeKind.BAND_ASSIGN:
			case AS3NodeKind.BXOR_ASSIGN:
			case AS3NodeKind.BOR_ASSIGN:
			case AS3NodeKind.LAND_ASSIGN:
			case AS3NodeKind.LOR_ASSIGN:
				return 13;
			case AS3NodeKind.QUESTION:
				return 12;
			case AS3NodeKind.LOR:
				return 11;
			case AS3NodeKind.LAND:
				return 10;
			case AS3NodeKind.BOR:
				return 9;
			case AS3NodeKind.BXOR:
				return 8;
			case AS3NodeKind.BAND:
				return 7;
			case AS3NodeKind.STRICT_EQUAL:
			case AS3NodeKind.STRICT_NOT_EQUAL:
			case AS3NodeKind.NOT_EQUAL:
			case AS3NodeKind.EQUAL:
				return 6;
			case AS3NodeKind.IN:
			case AS3NodeKind.LT:
			case AS3NodeKind.GT:
			case AS3NodeKind.LE:
			case AS3NodeKind.GE:
			case AS3NodeKind.IS:
			case AS3NodeKind.AS:
			case AS3NodeKind.INSTANCE_OF:
				return 5;
			case AS3NodeKind.SL:
			case AS3NodeKind.SR:
			case AS3NodeKind.BSR:
				return 4;
			case AS3NodeKind.PLUS:
			case AS3NodeKind.MINUS:
				return 3;
			case AS3NodeKind.STAR:
			case AS3NodeKind.DIV:
			case AS3NodeKind.MOD:
				return 2;
			default:
				return 1;
		}
	}
}
}