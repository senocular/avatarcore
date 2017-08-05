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
	
	import com.myavatareditor.avatarcore.Feature;
	import flash.events.Event;
	
	/**
	 * Event class for Feature-specific events.  In addition to
	 * standard event properties, this class includes a feature
	 * member representing the Feature for which the event is
	 * associated.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class FeatureEvent extends Event {
		
		/**
		 * Constant for added event type.
		 * @see Avatar#featureEventAdded
		 */
		public static const ADDED:String = "featureEventAdded";
		/**
		 * Constant for removed event type.
		 * @see Avatar#featureEventRemoved
		 */
		public static const REMOVED:String = "featureEventRemoved";
		/**
		 * Constant for changed event type.
		 * @see Avatar#featureEventChanged
		 */
		public static const CHANGED:String = "featureEventChanged";
		
		/**
		 * The Feature object associated with this event.
		 */
		public function get feature():Feature { return _feature; }
		public function set feature(value:Feature):void {
			_feature = value;
		}
		private var _feature:Feature;
		
		/**
		 * Associations are made through names, so when a name changes, an
		 * original name can be included to help reference objects that
		 * made references using the old name.
		 */
		public function get originalName():String { return _originalName; }
		public function set originalName(value:String):void {
			_originalName = value;
		}
		private var _originalName:String;
		
		/**
		 * Constructor for new FeatureEvent instances.
		 */
		public function FeatureEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, 
				feature:Feature = null, originalName:String = null) {
			super(type, bubbles, cancelable);
			this.feature = feature;
			this.originalName = originalName;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event {
			return new FeatureEvent(type, bubbles, cancelable, _feature, _originalName);
		}
	}
}