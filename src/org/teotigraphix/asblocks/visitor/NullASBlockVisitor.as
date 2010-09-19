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
import org.teotigraphix.asblocks.api.ISimpleNameExpression;
import org.teotigraphix.asblocks.api.IStringLiteral;
import org.teotigraphix.asblocks.api.ISuperStatement;
import org.teotigraphix.asblocks.api.ISwitchCase;
import org.teotigraphix.asblocks.api.ISwitchDefault;
import org.teotigraphix.asblocks.api.ISwitchStatement;
import org.teotigraphix.asblocks.api.IThisStatement;
import org.teotigraphix.asblocks.api.IThrowStatement;
import org.teotigraphix.asblocks.api.ITryStatement;
import org.teotigraphix.asblocks.api.IUndefinedLiteral;
import org.teotigraphix.asblocks.api.IVarDeclarationFragment;
import org.teotigraphix.asblocks.api.IWhileStatement;

/**
 * A default null visitor implementation that can be subclassed.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class NullASBlockVisitor implements IASBlockVisitor
{
	public function visitArgument(element:IArgument):void
	{
	}
	
	public function visitArrayAccessExpression(element:IArrayAccessExpression):void
	{
	}
	
	public function visitArrayLiteral(element:IArrayLiteral):void
	{
	}
	
	public function visitAssignmentExpression(element:IAssignmentExpression):void
	{
	}
	
	public function visitBinaryExpression(element:IBinaryExpression):void
	{
	}
	
	public function visitBlockStatement(element:IBlock):void
	{
	}
	
	public function visitBooleanLiteral(element:IBooleanLiteral):void
	{
	}
	
	public function visitBreakStatement(element:IBreakStatement):void
	{
	}
	
	public function visitCatchClause(element:ICatchClause):void
	{
	}
	
	public function visitClassType(element:IClassType):void
	{
	}
	
	public function visitCompilationUnit(element:ICompilationUnit):void
	{
	}
	
	public function visitConditionalExpression(element:IConditionalExpression):void
	{
	}
	
	public function visitContinueStatement(element:IContinueStatement):void
	{
	}
	
	public function visitDeclarationStatement(element:IDeclarationStatement):void
	{
	}
	
	public function visitDefaultXMLNamespaceStatement(element:IDefaultXMLNamespaceStatement):void
	{
	}
	
	public function visitDoWhileStatement(element:IDoWhileStatement):void
	{
	}
	
	public function visitExpressionStatement(element:IExpressionStatement):void
	{
	}
	
	public function visitField(element:IField):void
	{
	}
	
	public function visitFieldAccessExpression(element:IFieldAccessExpression):void
	{
	}
	
	public function visitFinallyClause(element:IFinallyClause):void
	{
	}
	
	public function visitForEachInStatement(element:IForEachInStatement):void
	{
	}
	
	public function visitForInStatement(element:IForInStatement):void
	{
	}
	
	public function visitForStatement(element:IForStatement):void
	{
	}
	
	public function visitFunctionLiteral(element:IFunctionLiteral):void
	{
	}
	
	public function visitIfStatement(element:IIfStatement):void
	{
	}
	
	public function visitNumberLiteral(element:INumberLiteral):void
	{
	}
	
	public function visitInterfaceType(element:IInterfaceType):void
	{
	}
	
	public function visitInvocationExpression(element:IINvocationExpression):void
	{
	}
	
	public function visitMetaData(element:IMetaData):void
	{
	}
	
	public function visitMethod(element:IMethod):void
	{
	}
	
	public function visitNewExpression(element:INewExpression):void
	{
	}
	
	public function visitNullLiteral(element:INullLiteral):void
	{
	}
	
	public function visitObjectField(element:IPropertyField):void
	{
	}
	
	public function visitObjectLiteral(element:IObjectLiteral):void
	{
	}
	
	public function visitPackage(element:IPackage):void
	{
	}
	
	public function visitParameter(element:IParameter):void
	{
	}
	
	public function visitPostfixExpression(element:IPostfixExpression):void
	{
	}
	
	public function visitPrefixExpression(element:IPrefixExpression):void
	{
	}
	
	public function visitReturnStatement(element:IReturnStatement):void
	{
	}
	
	public function visitSimpleNameExpression(element:ISimpleNameExpression):void
	{
	}
	
	public function visitStringLiteral(element:IStringLiteral):void
	{
	}
	
	public function visitSuperStatement(element:ISuperStatement):void
	{
	}
	
	public function visitSwitchCase(element:ISwitchCase):void
	{
	}
	
	public function visitSwitchDefault(element:ISwitchDefault):void
	{
	}
	
	public function visitSwitchStatement(element:ISwitchStatement):void
	{
	}
	
	public function visitThisStatement(element:IThisStatement):void
	{
	}
	
	public function visitThrowStatement(element:IThrowStatement):void
	{
	}
	
	public function visitTryStatement(element:ITryStatement):void
	{
	}
	
	public function visitUndefinedLiteral(element:IUndefinedLiteral):void
	{
	}
	
	public function visitVarDeclarationFragment(element:IVarDeclarationFragment):void
	{
	}
	
	public function visitWhileStatement(element:IWhileStatement):void
	{
	}
}
}