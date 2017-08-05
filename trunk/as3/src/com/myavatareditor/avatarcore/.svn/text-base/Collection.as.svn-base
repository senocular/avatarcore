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
	
	import com.myavatareditor.avatarcore.xml.IXMLWritable;
	import flash.events.EventDispatcher;
	
	/**
	 * Standard ICollection implementation.  When possible collection objects should
	 * extend Collection.  Collection classes contain a collection array for storing
	 * generic data of non-specific types.  Collections are key components in being
	 * able to represent child objects in XML.  Non-property XML nodes within an XML
	 * element, represent collection items within the parent element's respective
	 * instance.  Avatar, for example, extends Collection to allow an arbitrary number
	 * of child Feature items to be associated with the Avatar to make up an avatar
	 * character.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class Collection extends EventDispatcher implements ICollection, IXMLWritable, IClonable {
		
		/**
		 * The name of the property used to reference values
		 * within the collection by string key (as a hash).
		 */
		public static const nameKey:String = "name";
		
		/**
		 * Generic object for storing custom data (metadata). This
		 * can be, but doesn't have to be a Metadata instance. The
		 * advantage of using a Metadata instance is that it 
		 * implements IClonable and can be cloned.
		 */
		public function get meta():Object { return _meta; }
		public function set meta(value:Object):void {
			_meta = value;
		}
		private var _meta:Object;
		
		/**
		 * The name identifier for the Collection object. Within
		 * the Avatar Core framework, names are used to make 
		 * associations with different objects such as features 
		 * and definitions in associated libraries.
		 */
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		private var _name:String;
		
		/**
		 * When true, new items of the same name of existing
		 * items will cause the existing items to be removed
		 * before added to the collection themselves.
		 */
		public function get requireUniqueNames():Boolean { return _requireUniqueNames; }
		public function set requireUniqueNames(value:Boolean):void {
			_requireUniqueNames = value;
		}
		private var _requireUniqueNames:Boolean = true;
		
		/**
		 * Collection array where items are stored.  Items are
		 * stored both by index and by name.  This array should
		 * not be modified directly. Instead, use the add and
		 * remove APIs.
		 */
		public function get collection():Array { return _collection; }
		private var _collection:Array = [];
		
		/**
		 * Returns a count of all items in the collection.
		 * @return The number of items in the collection.
		 */
		public function get itemCount():int {
			return _collection.length;
		}
		
		/**
		 * Constructor for creating new Collection instances. 
		 * Usually the Collection class is used as a superclass;
		 * it is not common that you would create a new
		 * Collection instance.
		 */
		public function Collection() {
			super();
		}
		
		/**
		 * Creates and returns a copy of the Collection object.
		 * @return A copy of this Collection object.
		 */
		public function clone(copyInto:Object = null):Object {
			var copy:Collection = (copyInto) ? copyInto as Collection : new Collection();
			if (copy == null) return null;
			
			copy._name = _name;
			copy._requireUniqueNames = _requireUniqueNames;
			copy._meta = Metadata.copyValue(_meta);
			copy.copyCollectionFrom(this);
			return copy;
		}
		/**
		 * Copies the collection from one ICollection into this
		 * Collection, creating clones of any object that supports
		 * the clone() member function. Objects that don't contain a clone
		 * method are copied by reference. Any objects within the
		 * current collection are removed before the copy is made.
		 * @param	source The ICollection from which to make a copy.
		 */
		public function copyCollectionFrom(source:ICollection):void {
			clearCollection();
			if (source == null) return;
			var item:*;
			var sourceCollection:Array = source.collection;
			var i:int, n:int = sourceCollection.length;
			for (i=0; i<n; i++){
				item = sourceCollection[i];
				
				// clone item into copied collection otherwise
				// include a reference
				// IClonable is not checked because other native
				// objects (e.g. flash.geom::Point) implements
				// a clone but does not implement the Avatar Core
				// IClonable interface
				if ("clone" in item){
					try {
						addItem(item.clone());
					}catch (error:Error){
						addItem(item);
					}
				}else{
					addItem(item);
				}
			}
		}
		
		/**
		 * Adds an object to the collection.  The object
		 * must be non-null.  If the lookup attribute
		 * (i.e. name) exists within the object, that value
		 * is used as a key within the collection.  If this
		 * name is changed before the object is removed from 
		 * the collection you may run into a situation where
		 * the object will continue to exist within the
		 * collection even if used with removeItem. In
		 * other words, the name value should not be modified
		 * for collection items.  If the name is not set, the 
		 * name will automatically be defined as the item's numeric
		 * location within the collection array.
		 * @param	item The object to be added to the collection.
		 * @return The object added to the collection.
		 */
		public function addItem(item:*):* {
			if (item == null) return null;
			
			if (nameKey in item){
				
				var itemName:String = item[nameKey];
				if (itemName != null && isNaN(Number(itemName))) {
					
					// remove existing item of the same name if necessary
					if (requireUniqueNames) {
						removeItemByName(itemName);
					}
					
					_collection[itemName] = item;
					
				}else{
					// if null, force name key to be the
					// index at which the item is stored
					// in the collection as an array
					item[nameKey] = String(_collection.length);
				}
			}
			
			_collection.push(item);
			return item;
		}
		
		/**
		 * Returns true if an item exists within the collection.
		 * Returns false if it does not.
		 * @param	item The item to determine if within the
		 * collection.
		 * @return True if item exists within the collection, 
		 * otherwise false.
		 */
		public function collectionItemExists(item:*):Boolean {
			if (item == null) return false;
			
			// item by index
			var index:int = _collection.indexOf(item);
			if (index != -1){
				return true;
			}
			
			// item by key
			if (nameKey in item){
				var lookupKey:String = item[nameKey];
				if (_collection[lookupKey] == item){
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Finds an item in the collection by name and returns it.
		 * @param	key The name of the item (as specified
		 * by it's name property) to be returned.
		 * @return The item found in the collection. If the item
		 * is not within the collection, null is returned.
		 */
		public function getItemByName(key:String):* {
			if (!key) return null;
			return _collection[key];
		}
		
		/**
		 * Finds items in a collection of a specific type and 
		 * returns an array of those items.
		 * @param	type The type of items to find in the collection.
		 * @return An array of collection items of the type provided.
		 * If no items are found, an empty array is returned.
		 */
		public function getItemsByType(type:Class):Array {
			var items:Array = [];
			var i:int, n:int = _collection.length;
			for (i=0; i<n; i++){
				var value:Object = _collection[i] as type;
				if (value){
					items.push(value);
				}
			}
			return items;
		}
		
		/**
		 * Removes an item from the collection.
		 * @param	item The item to remove from the collection.
		 * @return The item removed.  If the item is not within
		 * the collection, null is returned.
		 */
		public function removeItem(item:*):* {
			if (item == null) return null;
			var itemFound:Boolean = false;
			
			// item by index
			var index:int = _collection.indexOf(item);
			if (index != -1){
				_collection.splice(index, 1);
				itemFound = true;
			}
			
			// item by key
			if (nameKey in item){
				var lookupKey:String = item[nameKey];
				if (_collection[lookupKey] == item){
					delete _collection[lookupKey];
					itemFound = true;
				}
			}
			
			return itemFound ? item : null;
		}
		
		/**
		 * Removes an item within a collection by its name.
		 * @param	key The name of the item (as specified
		 * by it's name property) to be removed.
		 * @return The item removed.  If the item is not within
		 * the collection, null is returned.
		 */
		public function removeItemByName(key:String):* {
			return removeItem(getItemByName(key));
		}
		
		/**
		 * Removes all items from the collection.
		 */
		public function clearCollection():void {
			_collection.length = 0;
			var key:String;
			for (key in _collection){
				delete _collection[key];
			}
		}
		
		/**
		 * Implementation for IXMLWritable for XML generation. Collections do not
		 * include requireUniqueNames, collection, or itemCount in XML.
		 * @inheritDoc
		 */
		public function getPropertiesIgnoredByXML():Object {
			return {requireUniqueNames:1, collection:1, itemCount:1};
		}
		
		/**
		 * Implementation for IXMLWritable for XML generation. Collections place
		 * their name properties in XML attributes.
		 * @inheritDoc
		 */
		public function getPropertiesAsAttributesInXML():Object {
			return {name:1};
		}
		
		/**
		 * Implementation for IXMLWritable for XML generation. There are no default
		 * properties to be ignored in XML.
		 * @inheritDoc
		 */
		public function getDefaultPropertiesInXML():Object {
			return {};
		}
		
		/**
		 * Implementation for IXMLWritable for XML generation. getObjectAsXML is not
		 * used to generate XML for Collection.
		 * @inheritDoc
		 */
		public function getObjectAsXML():XML {
			return null;
		}
	}
}