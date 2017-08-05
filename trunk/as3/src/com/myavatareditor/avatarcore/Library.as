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
	
	import com.myavatareditor.avatarcore.Collection;
	import com.myavatareditor.avatarcore.events.FeatureDefinitionEvent;
	import flash.events.Event;
	
	/**
	 * Dispatched when a new FeatureDefinition instance is added to the 
	 * Library.
	 */
	[Event(name="featureDefinitionEventAdded", type="com.myavatareditor.avatarcore.events.FeatureDefinitionEvent")]
	
	/**
	 * Dispatched when an existing FeatureDefinition instance within the
	 * Library is changed.
	 */
	[Event(name="featureDefinitionEventChanged", type="com.myavatareditor.avatarcore.events.FeatureDefinitionEvent")]
	
	/**
	 * Dispatched when an existing FeatureDefinition instance within the
	 * Library is removed.
	 */
	[Event(name="featureDefinitionEventRemoved", type="com.myavatareditor.avatarcore.events.FeatureDefinitionEvent")]
	
	/**
	 * A collection of FeatureDefinition objects to be associated with an Avatar
	 * object's Feature objects.  At any time an avatar can change its library to
	 * another allowing it to completely change it's appearance.  Libraries are 
	 * not required for avatars; avatars can optionally reference Art, Color, and 
	 * Adjust objects directly. Using library reduces redundancy between available
	 * assets and those used by avatars.  Libraries also allow avatar editors to
	 * know what characteristics are available to avatars as users modify them.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class Library extends Collection {
		
		/**
		 * When true, events are not dispatched.  This is useful
		 * for batch operations where events are not necessary
		 * such as cloning.
		 */
		protected function get suppressEvents():Boolean { return _suppressEvents; }
		protected function set suppressEvents(value:Boolean):void {
			_suppressEvents = value;
		}
		private var _suppressEvents:Boolean = false;
		
		/**
		 * Constructor for new Library instances.
		 */
		public function Library(name:String = null) {
			this.name = name;
			super();
		}
		
		/**
		 * Returns string version of this Library instance.
		 */
		override public function toString():String {
			return "[Library name=\"" + name + "\"]";
		}
		
		/**
		 * Creates and returns a copy of the Library object.
		 * @return A copy of this Library object.
		 */
		override public function clone(copyInto:Object = null):Object {
			suppressEvents = true;
			try {
				var copy:Library = (copyInto) ? copyInto as Library : new Library();
				if (copy == null) return null;
				super.clone(copy);
			}catch (err:*){
				// errors pass through. Errors must be
				// handled however, to allow suppressEvents 
				// to be restored to false
				throw(err);
			}finally{
				suppressEvents = false;
			}
			return copy;
		}
		
		/**
		 * Custom addItem for Library objects that dispatches the appropriate
		 * ADDED or ADDED events
		 * depending on whether or not the item already exists within the
		 * library collection.
		 * @param	item
		 * @return
		 */
		public override function addItem(item:*):* {
			var eventType:String;
			
			// remove existing item by name without events
			// assumes (forces) requireUniqueNames true
			var itemName:String = (Collection.nameKey in item) ? item[Collection.nameKey] : null;
			if (itemName && super.removeItemByName(itemName)) { 
				eventType = FeatureDefinitionEvent.CHANGED;
			}else {
				eventType = FeatureDefinitionEvent.ADDED;
			}
			
			var added:* = super.addItem(item);
			if (added is FeatureDefinition) {
				
				var definition:FeatureDefinition = added as FeatureDefinition;
				
				// remove definition from any previous library
				// definitions require one library for the
				// interaction of updates through redraw()
				var oldLibrary:Library = definition.library;
				if (oldLibrary && oldLibrary != this){
					oldLibrary.removeItem(definition);
				}
				
				// link definition to this library
				definition.library = this;
				
				dispatchEvent(new FeatureDefinitionEvent(eventType, false, false, added as FeatureDefinition));
			}
			return added;
		}
		
		/**
		 * Custom removeItem for Library objects that dispatches the
		 * REMOVED event for FeatureDefinition objects
		 * removed from the library collection.
		 * @param	item The item to remove.
		 * @return The item removed.
		 */
		public override function removeItem(item:*):* {
			var removed:* = super.removeItem(item);
			if (removed is FeatureDefinition) {
				dispatchEvent(new FeatureDefinitionEvent(FeatureDefinitionEvent.REMOVED, false, false, removed as FeatureDefinition));
			}
			return removed;
		}
		
		/**
		 * Invokes a FeatureDefinitionEvent.CHANGED event to indicate to
		 * objects that the definition has changed.  This mirrors the 
		 * behavior of FeatureDefinition.redraw() which is typically called
		 * instead of this method.
		 * @param	definition The FeatureDefinition within the Library
		 * instance that needs to be redrawn.
		 * @param	originalName The original name for the definition of a cause
		 * for the redraw includes changing the name. Since links are made through
		 * names, an original name helps identify old references.
		 * @see FeatureDefinition#redraw()
		 * @private
		 */
		internal function redrawFeatureDefinition(definition:FeatureDefinition, originalName:String = null):void {
			if (definition == null) return;
			dispatchEvent(new FeatureDefinitionEvent(FeatureDefinitionEvent.CHANGED, false, false, definition, originalName));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispatchEvent(event:Event):Boolean {
			return (suppressEvents) ? false : super.dispatchEvent(event);
		}
	}
}