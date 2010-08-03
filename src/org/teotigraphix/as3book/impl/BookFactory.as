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

package org.teotigraphix.as3book.impl
{

import org.teotigraphix.as3book.api.IAS3Book;
import org.teotigraphix.as3book.api.IAS3BookAccessor;
import org.teotigraphix.as3book.api.IAS3BookProcessor;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class BookFactory
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function BookFactory()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Factory :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates an IAS3Book.
	 */
	public function createBook():IAS3Book
	{
		var processor:IAS3BookProcessor = createBookProcessor();
		var accessor:IAS3BookAccessor = createBookAccessor();
		
		var book:IAS3Book = new AS3Book(processor, accessor);
		
		return book;
	}
	
	/**
	 * Creates an IAS3BookAccessor.
	 */
	public function createBookAccessor():IAS3BookAccessor
	{
		return new AS3BookAccessor();
	}
	
	/**
	 * Creates an IAS3BookProcessor.
	 */
	public function createBookProcessor():IAS3BookProcessor
	{
		return new AS3BookProcessor();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static var _instance:BookFactory;
	
	/**
	 * Returns the single instance of the BookFactory.
	 */
	public static function get instance():BookFactory
	{
		if (!_instance)
			_instance = new BookFactory();
		return _instance;
	}
}
}