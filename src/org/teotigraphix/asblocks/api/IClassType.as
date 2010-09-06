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

package org.teotigraphix.asblocks.api
{

/**
 * TODO Docme
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IClassType extends IType
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isDynamic
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get isDynamic():Boolean;
	
	/**
	 * @private
	 */
	function set isDynamic(value:Boolean):void;
	
	//----------------------------------
	//  isFinal
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get isFinal():Boolean;
	
	/**
	 * @private
	 */
	function set isFinal(value:Boolean):void;
	
	//----------------------------------
	//  superClass
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get superClass():String;
	
	/**
	 * @private
	 */
	function set superClass(value:String):void;
	
	//----------------------------------
	//  fields
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get fields():Vector.<IField>;
	
	//----------------------------------
	//  implementedInterfaces
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get implementedInterfaces():Vector.<String>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	function addImplementedInterface(name:String):Boolean;
	
	/**
	 * TODO Docme
	 */
	function removeImplementedInterface(name:String):Boolean;
	
	/**
	 * TODO Docme
	 */
	function newField(name:String, 
					  visibility:Visibility, 
					  type:String):IField;
	
	/**
	 * TODO Docme
	 */
	function getField(name:String):IField;
	
	/**
	 * TODO Docme
	 */
	function removeField(name:String):Boolean;
}
}