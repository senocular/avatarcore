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
	
	/**
	 * Defines a numeric rannge by which a number
	 * can be constrained between a min and max value.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class Range implements IXMLWritable {
		
		/**
		 * The name of the Range instance.
		 */
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		private var _name:String;
		
		/**
		 * Minimum value in the range.
		 */
		public function get min():Number { return _min; }
		public function set min(value:Number):void {
			_min = value;
			updateSpan();
		}
		private var _min:Number;
		
		/**
		 * Maximum value in the range.
		 */
		public function get max():Number { return _max; }
		public function set max(value:Number):void {
			_max = value;
			updateSpan();
		}
		private var _max:Number;
		
		/**
		 * The difference between min and max
		 */
		public function get span():Number { return _span; }
		private var _span:Number;
		
		/**
		 * Number of steps allowable between the min and max
		 * values of the range. Steps are calculated only when 
		 * getting a range value through stepValue(). When less 
		 * than 1, the range is considered to have no steps.  When
		 * equal to 1, the range as a whole is considered to be 
		 * representative of one step and stepValue() will not
		 * restrict inputs to the range.  When more than 1, calling
		 * stepValue() will restrict within the range boundaries
		 * and restict to the values of that range as divided evenly
		 * by the specified number of steps.
		 */
		public function get steps():int {
			return _steps;
		}
		public function set steps(value:int):void {
			_steps = value;
			updateStepSpan();
		}
		private var _steps:int = 0;
		
		/**
		 * The span for each step given the set number of steps.
		 * If steps is not set, or is less than 1, 0 is returned.
		 * If steps is 1, stepSpan will equal span.
		 */
		public function get stepSpan():Number {
			return _stepSpan;
		}
		private var _stepSpan:Number = 0;
		
		/**
		 * Constructor for creating new Range instances.
		 */
		public function Range(min:Number = 0, max:Number = 0, steps:int = 0) {
			_min = min;
			_max = max;
			_steps = steps;
			updateSpan();
		}
		
		/**
		 * @inheritDoc
		 */
		public function toString():String {
			return "[Range "+_min+", "+_max+"]";
		}
		
		/**
		 * Creates and returns a copy of the Range object.
		 * @return A copy of this Range object.
		 */
		public function clone(copyInto:Object = null):Object {
			var copy:Range = (copyInto) ? copyInto as Range : new Range();
			if (copy == null) return null;
			
			copy._min = _min;
			copy._max = _max;
			copy._steps = _steps;
			copy._name = _name;
			copy.updateSpan();
			return copy;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObjectAsXML():XML {
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPropertiesIgnoredByXML():Object {
			return {span:1, stepSpan:1};
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPropertiesAsAttributesInXML():Object {
			return {min:1, max:1, steps:1};
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDefaultPropertiesInXML():Object {
			return {min:0, max:1, steps:0}; 
		}
		
		/**
		 * In the case where min is greater than max,
		 * normalize will reverse those values to ensure
		 * min is, in fact, smaller.
		 */
		public function normalize():void {
			if (_min > _max) {
				var temp:Number = _min;
				_min = _max;
				_max = temp;
				updateSpan();
			}
		}
		
		/**
		 * Returns the passed value clamped within
		 * the range of the Range min and max values.
		 * If the value passed is greater than max, 
		 * max is returned. If the value is less than
		 * min, min is returned.  If the value is between
		 * min and max, the original value is returned.
		 */
		public function clamp(value:Number):Number {
			if (value < _min) return _min;
			if (value > _max) return _max;
			return value;
		}
		
		/**
		 * Returns the value within the range at the
		 * passed percent within the range.
		 */
		public function valueAt(percent:Number):Number {
			return clamp(_min + _span * percent);
		}
		
		/**
		 * Returns the value within the range at the
		 * step index provided.  If there are no steps
		 * in the range, min is returned.
		 */
		public function valueAtStepIndex(index:int):Number {
			return _min + _stepSpan * index;
		}
		
		/**
		 * Returns the percent within the range that the
		 * passed value exists within the range.
		 */
		public function percentAt(value:Number):Number {
			if (_span == 0) return 0;
			value = clamp(value);
			return (value - _min)/_span;
		}
		
		/**
		 * Returns the stepped value of the range, or the value
		 * closest to the division with the range divided steps
		 * times.  This method will use the steps property of the
		 * current Range instance to determine the step value.  If
		 * that value has not been set or is less than 1, no stepping
		 * occurs.  When 1, the range represents one step and values
		 * are not restricted to the range. When steps is greater than
		 * 1, stepValue automatically clamps the value to the range
		 * and the values of the range as divided evenly
		 * by the specified number of steps.
		 * @param value The value to convert into a stepped value.
		 * @return A stepped value of the range.
		 */
		public function stepValue(value:Number):Number {
			if (_steps != 1) {
				var clamped:Number = clamp(value);
				if (value != clamped) return clamped;
			}
			if (_steps < 1) return value;
			
			var pos:Number = Math.round((value - _min)/_stepSpan);
			return _min + pos * _stepSpan;
		}
		
		/**
		 * Provides the step index, or the number of steps from min using
		 * stepSpen to reach the step value of the value provided.
		 * @param	value A value within the range to 
		 * @return The step index for the value passed. If a step index
		 * does not apply, -1 is returned.
		 */
		public function stepIndex(value:Number):int {
			if (_steps < 1) return -1;
			return Math.round((stepValue(value) - _min)/_stepSpan);
		}
		
		private function updateSpan():void {
			_span = _max - _min;
			updateStepSpan();
		}
		
		private function updateStepSpan():void {
			if (_steps < 1){
				_stepSpan = 0;
			}else if (_steps == 1){
				_stepSpan = _span;
			}else{
				_stepSpan = _span/(_steps - 1);
			}
		}
	}
}