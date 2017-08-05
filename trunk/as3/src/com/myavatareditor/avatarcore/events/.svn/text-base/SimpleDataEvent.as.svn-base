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
	import flash.events.Event;
	
	/**
	 * Event occuring when a simple data transaction occurs.  SimpleDataEvents
	 * are simple in that a single event can be used to represent a successful
	 * data transaction and/or represent an instance where an error occurred.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class SimpleDataEvent extends Event {
		
		/**
		 * Raw data related to this event. 
		 */
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			_data = value;
		}
		private var _data:Object;
		
		/**
		 * Any error associated with this event.  This can be
		 * in the form of a Error or ErrorEvent object depending
		 * on where the error occured and how. If null, no error
		 * occurred.  Including the error as a property allows the
		 * data event to be dispatched as a single type rather than
		 * multiple types for each type error and non error situation.
		 * If the event dispatched contains an error value, the event
		 * is considered an error event, otherwise a successful one.
		 */
		public function get error():Object { return _error; }
		public function set error(value:Object):void {
			_error = value;
		}
		private var _error:Object = null;
		
		/**
		 * Constructor for creating new DataEvent instances.
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	data Data associated with this event.  This may or
		 * may not be null independently of errors.
		 * @param	error An error associated with the event if one
		 * occurred. If an error does occur, it does not always mean that
		 * there is no data.
		 */
		public function SimpleDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null, error:Object = null) { 
			super(type, bubbles, cancelable);
			this.data = data;
			this.error = error;
		} 
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event { 
			return new SimpleDataEvent(type, bubbles, cancelable, data, error);
		}
	}
}