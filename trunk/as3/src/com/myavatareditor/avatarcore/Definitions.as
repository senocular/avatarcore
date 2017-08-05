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
	
	import com.myavatareditor.avatarcore.debug.print;
	import com.myavatareditor.avatarcore.debug.PrintLevel;
	import com.myavatareditor.avatarcore.events.SimpleDataEvent;
	import com.myavatareditor.avatarcore.xml.XMLDefinitionParser;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * Dispatched when xml has been loaded into a Definitions instance
	 * or when there was an error in the process of loading the xml.
	 */
	[Event(name="complete", type="com.myavatareditor.avatarcore.events.SimpleDataEvent")]
	
	/**
	 * A collection of definitions such as Library and Avatar instances 
	 * to be used with the Avatar Core framework. These are typically 
	 * definitions acquired from XML.  One specific feature of the Definitions
	 * class is that it handles the linking of Library and Avatar instances
	 * when an avatar is added to the Definitions collection and a Library
	 * exists within the collection with the name specified in 
	 * Avatar.libraryName.  Upon adding that avatar, it's library is set to
	 * that respective Library instance.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class Definitions extends Collection {
		
		private var xmlLoader:URLLoader = new URLLoader();
		
		/**
		 * Custom addItem which creates associations with avatars
		 * and libraries when avatars specify a libraryName.
		 * @param	item The item to be added to the collection.
		 * @return The item added to the collection.
		 */
		public override function addItem(item:*):* {
			if (item is Avatar){
				
				// associate avatar with library
				updateAvatar(item as Avatar);
				
			}else if (item is Library){
				
				// work the other way around, associating
				// new libraries with any avatars
				updateAvatarFromLibrary(item as Library);
			}
			
			return super.addItem(item);
		}
		
		/**
		 * Constructor for creating new Definition instances. 
		 * Definition instances are typically created through
		 * XML.
		 */
		public function Definitions(xml:XML = null) {
			xmlLoader.addEventListener(Event.COMPLETE, xmlCompleteHandler, false, 0, true);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlCompleteHandler, false, 0, true);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlCompleteHandler, false, 0, true);
			if (xml){
				parse(xml);
			}
		}
		
		/**
		 * Creates and returns a copy of the Definitions object.
		 * @return A copy of this Definitions object.
		 */
		override public function clone(copyInto:Object = null):Object {
			var copy:Definitions = (copyInto) ? copyInto as Definitions : new Definitions();
			if (copy == null) return null;
			super.clone(copy);
			
			return copy;
		}
		
		/**
		 * Loads and parses an XML file into the Definitions object. 
		 * When loaded, all collection content in this object are cleared
		 * and the first Definitions node in the XML file is found and
		 * parsed into this object.  A SimpleDataEvent of the type
		 * Event.COMPLETE is dispatched when this process is complete. If 
		 * there was an error, the COMPLETE event is still dispatched, but
		 * the SimpleDataEvent.error property will contain the error that
		 * occured.
		 * @param	request A URLRequest linking to the xml file to be loaded.
		 */
		public function load(request:URLRequest):void {
			try {
				xmlLoader.load(request);
			}catch (error:Error){
				
				// synchronous error, dispatch event with the error
				var completeEvent:SimpleDataEvent = new SimpleDataEvent(Event.COMPLETE, false, false, null, error);
				dispatchEvent(completeEvent);
			}
		}
		
		private function xmlCompleteHandler(event:Event):void {
			var completeEvent:SimpleDataEvent = new SimpleDataEvent(Event.COMPLETE, false, false, xmlLoader.data);
			
			if (event is ErrorEvent){
				completeEvent.error = event;
			}else{
				var xml:XML;
				
				try {
					xml = new XML(xmlLoader.data);
					xmlLoader.data = xml;
				}catch (error:Error){
					completeEvent.error = error;
				}
				
				parse(xml);
			}
			
			dispatchEvent(completeEvent);
		}
		
		/**
		 * Sets the definition of the Definitions object based on the
		 * XML provided, this works much in the same way as loadXML but
		 * does not load the XML from a URL. Rather, it is passed directly
		 * into this method.
		 * @param	xml XML to be parsed into this Definitions object.
		 */
		public function parse(xml:XML):void {
			if (xml == null) return;
			var definitions:XMLList = xml + xml..Definitions;
		
			if (definitions.length()){
				clearCollection();
				var parser:XMLDefinitionParser = new XMLDefinitionParser();
				parser.parseInto(definitions[0], this); // use the first if many
			}else{
				print("Definitions object cannot be derived from XML because no <Definitions> node exists", PrintLevel.WARNING, this);
			}
		}
		
		/**
		 * Updates an avatar with Library objects within the Definition
		 * collection with names that match the Avatar's libraryName
		 * property. Matching Library objects are assigned to the Avatar's
		 * library.
		 * @param	avatar The Avatar to find a linked library from those
		 * available in the Definitions collection.
		 */
		private function updateAvatar(avatar:Avatar):void {
			if (avatar == null || avatar.libraryName == null) return;
			var library:Library = getItemByName(avatar.libraryName) as Library;
			if (library){
				avatar.library = library;
			}
		}
		
		/**
		 * Runs through all Avatar objects in the Definitions collection
		 * calling Definitions.updateAvatar() for each.
		 */
		private function updateAvatars():void {
			var avatarItem:Avatar;
			var items:Array = collection;
			var i:int = items.length;
			while (i--){
				avatarItem = items[i] as Avatar;
				if (avatarItem){
					updateAvatar(avatarItem);
				}
			}
		}
		
		/**
		 * Updates avatars within the Definition collection with 
		 * the Library objects passed
		 * @param	library The Library object to use to assocate any
		 * avatars within the collection that might relate to it.
		 */
		private function updateAvatarFromLibrary(library:Library):void {
			var libraryName:String = library.name;
			if (libraryName){
				var avatarItem:Avatar;
				var items:Array = collection;
				var i:int = items.length;
				while (i--){
					avatarItem = items[i] as Avatar;
					if (avatarItem && avatarItem.libraryName == libraryName){
						avatarItem.library = library;
					}
				}
			}
		}
	}
}