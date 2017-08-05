/*
Copyright (c) 2010 Trevor McCauley

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. 
*/
package com.myavatareditor.avatarcore {
	
	/**
	 * Interface for objects containing collections, namely
	 * those used within a definition XML that can contain
	 * a dynamic number of instances of various types.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public interface ICollection {
		
		/**
		 * Copies the collection from one ICollection into this
		 * ICollection. Any objects within the current collection
		 * are removed before the new copy is made.
		 * @param	source The ICollection from which to make a copy.
		 */
		function copyCollectionFrom(source:ICollection):void;
		
		/**
		 * Adds an object to the collection.  The object
		 * must be non-null.
		 * @param	item The object to be added to the collection.
		 * @return The object added to the collection.
		 */
		function addItem(item:*):*;
		
		/**
		 * Returns true if an item exists within the collection.
		 * Returns false if it does not.
		 * @param	item The item to determine if within the
		 * collection.
		 * @return True if item exists within the collection, 
		 * otherwise false.
		 */
		function collectionItemExists(item:*):Boolean;
		
		/**
		 * Finds an item in the collection by name and returns it.
		 * @param	key The name of the item (as specified
		 * by it's name property) to be returned.
		 * @return The item found in the collection. If the item
		 * is not within the collection, null is returned.
		 */
		function getItemByName(key:String):*;
		
		/**
		 * Finds items in a collection of a specific type and 
		 * returns an array of those items.
		 * @param	type The type of items to find in the collection.
		 * @return An array of collection items of the type provided.
		 */
		function getItemsByType(type:Class):Array;
		
		/**
		 * Removes an item from the collection.
		 * @param	item The item to remove from the collection.
		 * @return The item removed.  If the item is not within
		 * the collection, null is returned.
		 */
		function removeItem(item:*):*;
		
		/**
		 * Removes an item within a collection by its name.
		 * @param	key The name of the item (as specified
		 * by it's name property) to be removed.
		 * @return The item removed.  If the item is not within
		 * the collection, null is returned.
		 */
		function removeItemByName(key:String):*;
		
		/**
		 * Removes all items from the collection.
		 */
		function clearCollection():void;
		
		/**
		 * Returns a count of all items in the collection.
		 * @return The number of items in the collection.
		 */
		function get itemCount():int;
		
		/**
		 * Collection array where items are stored.  Items are
		 * stored both by index and by name if available.
		 */
		function get collection():Array;
	}
	
}