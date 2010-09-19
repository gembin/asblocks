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

package org.teotigraphix.asblocks.visitor
{

import flash.errors.IllegalOperationError;
import flash.utils.getQualifiedClassName;

import org.teotigraphix.asblocks.IASBlockVisitor;
import org.teotigraphix.asblocks.api.IArgument;
import org.teotigraphix.asblocks.api.IArrayAccessExpression;
import org.teotigraphix.asblocks.api.IArrayLiteral;
import org.teotigraphix.asblocks.api.IAssignmentExpression;
import org.teotigraphix.asblocks.api.IBinaryExpression;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IBooleanLiteral;
import org.teotigraphix.asblocks.api.IBreakStatement;
import org.teotigraphix.asblocks.api.ICatchClause;
import org.teotigraphix.asblocks.api.IClassType;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IConditionalExpression;
import org.teotigraphix.asblocks.api.IContinueStatement;
import org.teotigraphix.asblocks.api.IDeclarationStatement;
import org.teotigraphix.asblocks.api.IDefaultXMLNamespaceStatement;
import org.teotigraphix.asblocks.api.IDoWhileStatement;
import org.teotigraphix.asblocks.api.IExpressionStatement;
import org.teotigraphix.asblocks.api.IField;
import org.teotigraphix.asblocks.api.IFieldAccessExpression;
import org.teotigraphix.asblocks.api.IFinallyClause;
import org.teotigraphix.asblocks.api.IForEachInStatement;
import org.teotigraphix.asblocks.api.IForInStatement;
import org.teotigraphix.asblocks.api.IForStatement;
import org.teotigraphix.asblocks.api.IFunctionLiteral;
import org.teotigraphix.asblocks.api.IINvocationExpression;
import org.teotigraphix.asblocks.api.IIfStatement;
import org.teotigraphix.asblocks.api.IInterfaceType;
import org.teotigraphix.asblocks.api.IMetaData;
import org.teotigraphix.asblocks.api.IMethod;
import org.teotigraphix.asblocks.api.INewExpression;
import org.teotigraphix.asblocks.api.INullLiteral;
import org.teotigraphix.asblocks.api.INumberLiteral;
import org.teotigraphix.asblocks.api.IObjectLiteral;
import org.teotigraphix.asblocks.api.IPackage;
import org.teotigraphix.asblocks.api.IParameter;
import org.teotigraphix.asblocks.api.IPostfixExpression;
import org.teotigraphix.asblocks.api.IPrefixExpression;
import org.teotigraphix.asblocks.api.IPropertyField;
import org.teotigraphix.asblocks.api.IReturnStatement;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.api.ISimpleNameExpression;
import org.teotigraphix.asblocks.api.IStringLiteral;
import org.teotigraphix.asblocks.api.ISuperStatement;
import org.teotigraphix.asblocks.api.ISwitchCase;
import org.teotigraphix.asblocks.api.ISwitchDefault;
import org.teotigraphix.asblocks.api.ISwitchStatement;
import org.teotigraphix.asblocks.api.IThrowStatement;
import org.teotigraphix.asblocks.api.ITryStatement;
import org.teotigraphix.asblocks.api.IUndefinedLiteral;
import org.teotigraphix.asblocks.api.IVarDeclarationFragment;
import org.teotigraphix.asblocks.api.IWhileStatement;

/**
 * A <code>ScriptNode</code> switch handler that calls 
 * <code>IASBlockVisitor</code> methods.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 * @see org.teotigraphix.asblocks.IASBlockVisitor
 */
public class ScriptNodeSwitch implements IScriptNodeStrategy
{
	private var visitor:IASBlockVisitor;
	
	public function ScriptNodeSwitch(visitor:IASBlockVisitor)
	{
		this.visitor = visitor;
	}
	
	/**
	 * throws IllegalOperationError unhandled ScriptNode
	 */
	public function handle(element:IScriptNode):void
	{
		if (element is IArgument)
		{
			visitor.visitArgument(IArgument(element));
		}
		else if (element is IArrayAccessExpression)
		{
			visitor.visitArrayAccessExpression(IArrayAccessExpression(element));
		}
		else if (element is IArrayLiteral)
		{
			visitor.visitArrayLiteral(IArrayLiteral(element));
		}
		else if (element is IAssignmentExpression)
		{
			visitor.visitAssignmentExpression(IAssignmentExpression(element));
		}
		else if (element is IBinaryExpression)
		{
			visitor.visitBinaryExpression(IBinaryExpression(element));
		}
		else if (element is IBlock)
		{
			visitor.visitBlockStatement(IBlock(element));
		}
		else if (element is IBooleanLiteral)
		{
			visitor.visitBooleanLiteral(IBooleanLiteral(element));
		}
		else if (element is IBreakStatement)
		{
			visitor.visitBreakStatement(IBreakStatement(element));
		}
		else if (element is ICatchClause)
		{
			visitor.visitCatchClause(ICatchClause(element));
		}
		else if (element is IClassType)
		{
			visitor.visitClassType(IClassType(element));
		}
		else if (element is ICompilationUnit)
		{
			visitor.visitCompilationUnit(ICompilationUnit(element));
		}
		else if (element is IConditionalExpression)
		{
			visitor.visitConditionalExpression(IConditionalExpression(element));
		}
		else if (element is IContinueStatement)
		{
			visitor.visitContinueStatement(IContinueStatement(element));
		}
		else if (element is IDeclarationStatement)
		{
			visitor.visitDeclarationStatement(IDeclarationStatement(element));
		}
		else if (element is IDefaultXMLNamespaceStatement)
		{
			visitor.visitDefaultXMLNamespaceStatement(IDefaultXMLNamespaceStatement(element));
		}
		else if (element is IDoWhileStatement)
		{
			visitor.visitDoWhileStatement(IDoWhileStatement(element));
		}
		else if (element is IExpressionStatement)
		{
			visitor.visitExpressionStatement(IExpressionStatement(element));
		}
		else if (element is IField)
		{
			visitor.visitField(IField(element));
		}
		else if (element is IFieldAccessExpression)
		{
			visitor.visitFieldAccessExpression(IFieldAccessExpression(element));
		}
		else if (element is IFinallyClause)
		{
			visitor.visitFinallyClause(IFinallyClause(element));
		}
		else if (element is IForEachInStatement)
		{
			visitor.visitForEachInStatement(IForEachInStatement(element));
		}
		else if (element is IForInStatement)
		{
			visitor.visitForInStatement(IForInStatement(element));
		}
		else if (element is IForStatement)
		{
			visitor.visitForStatement(IForStatement(element));
		}
		else if (element is IFunctionLiteral)
		{
			visitor.visitFunctionLiteral(IFunctionLiteral(element));
		}
		else if (element is IIfStatement)
		{
			visitor.visitIfStatement(IIfStatement(element));
		}
		else if (element is INumberLiteral)
		{
			visitor.visitNumberLiteral(INumberLiteral(element));
		}
		else if (element is IInterfaceType)
		{
			visitor.visitInterfaceType(IInterfaceType(element));
		}
		else if (element is IINvocationExpression)
		{
			visitor.visitInvocationExpression(IINvocationExpression(element));
		}
		else if (element is IMetaData)
		{
			visitor.visitMetaData(IMetaData(element));
		}
		else if (element is IMethod)
		{
			visitor.visitMethod(IMethod(element));
		}
		else if (element is INewExpression)
		{
			visitor.visitNewExpression(INewExpression(element));
		}
		else if (element is INullLiteral)
		{
			visitor.visitNullLiteral(INullLiteral(element));
		}
		else if (element is IPropertyField)
		{
			visitor.visitObjectField(IPropertyField(element));
		}
		else if (element is IObjectLiteral)
		{
			visitor.visitObjectLiteral(IObjectLiteral(element));
		}
		else if (element is IPackage)
		{
			visitor.visitPackage(IPackage(element));
		}
		else if (element is IParameter)
		{
			visitor.visitParameter(IParameter(element));
		}
		else if (element is IPostfixExpression)
		{
			visitor.visitPostfixExpression(IPostfixExpression(element));
		}
		else if (element is IPrefixExpression)
		{
			visitor.visitPrefixExpression(IPrefixExpression(element));
		}
		else if (element is IReturnStatement)
		{
			visitor.visitReturnStatement(IReturnStatement(element));
		}
		else if (element is ISimpleNameExpression)
		{
			visitor.visitSimpleNameExpression(ISimpleNameExpression(element));
		}
		else if (element is IStringLiteral)
		{
			visitor.visitStringLiteral(IStringLiteral(element));
		}
		else if (element is ISuperStatement)
		{
			visitor.visitSuperStatement(ISuperStatement(element));
		}
		else if (element is ISwitchCase)
		{
			visitor.visitSwitchCase(ISwitchCase(element));
		}
		else if (element is ISwitchDefault)
		{
			visitor.visitSwitchDefault(ISwitchDefault(element));
		}
		else if (element is ISwitchStatement)
		{
			visitor.visitSwitchStatement(ISwitchStatement(element));
		}
		else if (element is IThrowStatement)
		{
			visitor.visitThrowStatement(IThrowStatement(element));
		}
		else if (element is ITryStatement)
		{
			visitor.visitTryStatement(ITryStatement(element));
		}
		else if (element is IUndefinedLiteral)
		{
			visitor.visitUndefinedLiteral(IUndefinedLiteral(element));
		}
		else if (element is IVarDeclarationFragment)
		{
			visitor.visitVarDeclarationFragment(IVarDeclarationFragment(element));
		}
		else if (element is IWhileStatement)
		{
			visitor.visitWhileStatement(IWhileStatement(element));
		}
		else
		{
			var className:String = getQualifiedClassName(element);
			throw new IllegalOperationError("unhandled ScriptNode " + className);
		}
	}
}
}