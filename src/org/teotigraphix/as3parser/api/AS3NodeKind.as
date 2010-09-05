/**
 *    Copyright (c) 2009, Adobe Systems, Incorporated
 *    All rights reserved.
 *
 *    Redistribution  and  use  in  source  and  binary  forms, with or without
 *    modification,  are  permitted  provided  that  the  following  conditions
 *    are met:
 *
 *      * Redistributions  of  source  code  must  retain  the  above copyright
 *        notice, this list of conditions and the following disclaimer.
 *      * Redistributions  in  binary  form  must reproduce the above copyright
 *        notice,  this  list  of  conditions  and  the following disclaimer in
 *        the    documentation   and/or   other  materials  provided  with  the
 *        distribution.
 *      * Neither the name of the Adobe Systems, Incorporated. nor the names of
 *        its  contributors  may be used to endorse or promote products derived
 *        from this software without specific prior written permission.
 *
 *    THIS  SOFTWARE  IS  PROVIDED  BY THE  COPYRIGHT  HOLDERS AND CONTRIBUTORS
 *    "AS IS"  AND  ANY  EXPRESS  OR  IMPLIED  WARRANTIES,  INCLUDING,  BUT NOT
 *    LIMITED  TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
 *    OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,  INCIDENTAL,  SPECIAL,
 *    EXEMPLARY,  OR  CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT  LIMITED TO,
 *    PROCUREMENT  OF  SUBSTITUTE   GOODS  OR   SERVICES;  LOSS  OF  USE,  DATA,
 *    OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *    LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY, OR TORT (INCLUDING
 *    NEGLIGENCE  OR  OTHERWISE)  ARISING  IN  ANY  WAY  OUT OF THE USE OF THIS
 *    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package org.teotigraphix.as3parser.api
{

/**
 * The <strong>AS3NodeKind</strong> enumeration of <strong>.as</strong> 
 * node kinds.
 * 
 * <p>Initial API; Adobe Systems, Incorporated</p>
 * 
 * @author Adobe Systems, Incorporated
 * @author Michael Schmalle
 * @productversion 1.0
 */
public class AS3NodeKind
{
	public static const LBRACKET:String = "lbracket";
	
	public static const LCURLY:String = "lcurly";
	
	public static const RBRACKET:String = "rbracket";
	
	public static const RCURLY:String = "rcurly";
	
	public static const RPAREN:String = "rparen";
	
	public static const LPAREN:String = "lparen";
	
	public static const HIDDEN:String = "hidden";
	
	public static const WS:String = "ws";
	
	public static const NL:String = "nl";
	
	public static const SPACE:String = "space";
	
	public static const TAB:String = "tab";
	
	//--------------------------------------------------------------------------
	
	public static const ACCESSOR_ROLE:String = "accessor-role";
	
	public static const ADD:String = "add";
	
	public static const AND:String = "and";
	
	public static const ARGUMENTS:String = "arguments";
	
	public static const ARRAY:String = "array";
	
	public static const ARRAY_ACCESSOR:String = "arr-acc";
	
	public static const AS_DOC:String = "as-doc"; 
	
	public static const BLOCK_DOC:String = "block-doc";
	
	public static const ASSIGN:String = "assign";
	
	public static const B_AND:String = "b-and"; 
	
	public static const B_NOT:String = "b-not";
	
	public static const B_OR:String = "b-or";
	
	public static const B_XOR:String = "b-xor";
	
	public static const BLOCK:String = "block";
	
	public static const BREAK:String = "break";
	
	public static const CALL:String = "call";
	
	public static const CASE:String = "case";
	
	public static const CASES:String = "cases";
	
	public static const CATCH:String = "catch";
	
	public static const CLASS:String = "class";
	
	public static const COMMENT:String = "comment";
	
	public static const COMPILATION_UNIT:String = "compilation-unit";
	
	public static const COND:String = "cond";
	
	public static const CONDITION:String = "condition";
	
	public static const CONDITIONAL:String = "conditional";
	
	public static const CONST:String = "const";
	
	public static const CONST_LIST:String = "const-list";
	
	public static const CONTENT:String = "content";
	
	public static const CONTINUE:String = "continue";
	
	public static const DOUBLE_COLUMN:String = "double-column";
	
	public static const DEC_LIST:String = "dec-list";
	
	public static const DEC_ROLE:String = "dec-role";
	
	public static const DEFAULT:String = "default";
	
	public static const DELETE:String = "delete";
	
	public static const DO:String = "do";
	
	public static const DOT:String = "dot"; 
	
	public static const E4X_ATTR:String = "e4x-attr";
	
	public static const E4X_DESCENDENT:String = "e4x-descendent";
	
	public static const E4X_FILTER:String = "e4x-filter";
	
	public static const E4X_STAR:String = "e4x-star";
	
	public static const ELSE:String = "else";
	
	public static const ENCAPSULATED:String = "encapsulated";
	
	public static const EQUALITY:String = "equality";
	
	public static const EXPR_STMNT:String = "expr-stmnt";
	
	public static const EXPR_LIST:String = "expr-list";
	
	public static const EXTENDS:String = "extends";
	
	public static const FALSE:String = "false";
	
	public static const FIELD_LIST:String = "field-list";
	
	public static const FIELD_ROLE:String = "field-role";

	public static const FINALLY:String = "finally";
	
	public static const FOR:String = "for";
	
	public static const FOREACH:String = "foreach";
	
	public static const FORIN:String = "forin";
	
	public static const FUNCTION:String = "function";
	
	public static const GET:String = "get";
	
	public static const IF:String = "if";
	
	public static const IMPLEMENTS:String = "implements";
	
	public static const IMPLEMENTS_LIST:String = "implements-list";
	
	public static const IMPORT:String = "import";
	
	public static const IN:String = "in";
	
	public static const INCLUDE:String = "include";
	
	public static const INIT:String = "init";
	
	public static const INTERFACE:String = "interface";
	
	public static const ITER:String = "iter";
	
	public static const LAMBDA:String = "lambda";
	
	public static const META:String = "meta";
	
	public static const META_LIST:String = "meta-list";
	
	public static const MINUS:String = "minus"; 
	
	public static const MOD_LIST:String = "mod-list";
	
	public static const MODIFIER:String = "mod";
	
	public static const MULTIPLICATION:String = "mul";
	
	public static const NAME:String = "name";
	
	public static const NAME_TYPE_INIT:String = "name-type-init";
	
	public static const NEW:String = "new";
	
	public static const NOT:String = "not";
	
	public static const NULL:String = "null";
	
	public static const NUMBER:String = "number";
	
	public static const OBJECT:String = "object";
	
	public static const OP:String = "op";
	
	public static const OR:String = "or";
	
	public static const PACKAGE:String = "package";
	
	public static const PARAMETER:String = "parameter";
	
	public static const PARAMETER_LIST:String = "parameter-list";
	
	public static const PLUS:String = "plus";
	
	public static const POST_DEC:String = "post-dec";
	
	public static const POST_INC:String = "post-inc";
	
	public static const PRE_DEC:String = "pre-dec";
	
	public static const PRE_INC:String = "pre-inc";
	
	public static const PRIMARY:String = "primary";
	
	public static const PROP:String = "prop";
	
	public static const REG_EXP:String = "reg-exp";
	
	public static const RELATION:String = "relation";
	
	public static const REST:String = "rest";
	
	public static const RETURN:String = "return";
	
	public static const SET:String = "set";
	
	public static const SHIFT:String = "shift";
	
	public static const STAR:String = "star";
	
	public static const STMT_EMPTY:String = "stmt-empty";
	
	public static const STRING:String = "string";
	
	public static const SWITCH:String = "switch";
	
	public static const SWITCH_BLOCK:String = "switch-block";
	
	public static const THROW:String = "throw";
	
	public static const TRUE:String = "true";
	
	public static const TRY:String = "try";
	
	public static const TYPE:String = "type";
	
	public static const TYPE_SPEC:String = "type-spec";
	
	public static const TYPEOF:String = "typeof";
	
	public static const USE:String = "use";
	
	public static const UNDEFINED:String = "undefined";
	
	public static const VALUE:String = "value";
	
	public static const VAR:String = "var";
	
	public static const VAR_LIST:String = "var-list";
	
	public static const VECTOR:String = "vector";
	
	public static const VOID:String = "void";
	
	public static const WHILE:String = "while";
	
	public static const XML:String = "xml";
	
	public static const XML_NAMESPACE:String = "xml-namespace";
}
}