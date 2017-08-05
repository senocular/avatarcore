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
package com.myavatareditor.avatarcore.events {
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * Event class for source-related events.  This includes when
	 * source content is loaded into a loader display object.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class SourceEvent extends Event {
		
		/**
		 * Static variable for the containerComplete event type.
		 */
		public static const COMPLETE:String = "sourceEventComplete";
		
		/**
		 * The container object associated with this event.
		 */
		public function get container():DisplayObjectContainer { return _container; }
		public function set container(value:DisplayObjectContainer):void {
			_container = value;
		}
		private var _container:DisplayObjectContainer;
		
		/**
		 * Constructor for creating new SourceEvent instances.
		 */
		public function SourceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, container:DisplayObjectContainer = null) {
			super(type, bubbles, cancelable);
			this.container = container;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event {
			return new SourceEvent(type, bubbles, cancelable, _container);
		}
	}
}