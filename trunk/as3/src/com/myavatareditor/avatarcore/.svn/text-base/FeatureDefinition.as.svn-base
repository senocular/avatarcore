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
	
	import com.myavatareditor.avatarcore.display.ArtSprite;
	import com.myavatareditor.avatarcore.xml.IXMLWritable;
	
	/**
	 * Defines characteristics to be referenced by avatar features.  Characteristics
	 * include possible art, color selections, adjustments and optional
	 * constraints.  Features reference these characteristics
	 * by name.  Features reference feature definitions when they share the same 
	 * name.  This connection is made when an Avatar instance is associated with a 
	 * Library instance.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class FeatureDefinition extends FeatureBase {
		
		/**
		 * Setting the name of FeatureDefinitions automatically
		 * calls redraw, including the original name to allow
		 * updates of Features that linked to this definition
		 * by the original name (breaking that link).
		 */
		override public function set name(value:String):void {
			var thisName:String = this.name;
			if (thisName == value) return;
			
			// redrawing will happen after updating the parent
			// hierarchy which must be done after the value is
			// set so suppress drawing that would occur in 
			// super and draw after updating parents
			suppressDraw = true;
			try {
				super.name = value;
			}catch (error:*){}
			suppressDraw = false;
			
			if (_library && autoRedraw){
				redraw(thisName);
			}
		}
		
		/**
		 * The library that is associated with this FeatureDefinition.  
		 * This is set automatically when the FeatureDefinition is added
		 * to a library through Library.addItem(). This property serves
		 * as a reference to the library instance in that relationship.
		 * Each FeatureDefinition can only exist within one Library at
		 * a time.
		 */
		public function get library():Library { return _library; }
		public function set library(value:Library):void {
			_library = value;
			if (autoRedraw) redraw();
		}
		private var _library:Library;
		
		/**
		 * Variations of art available for this feature
		 * definition. An artSet cannot be null.
		 */
		public function get artSet():ArtSet { return _artSet; }
		public function set artSet(value:ArtSet):void {
			if (value){
				_artSet = value;
				if (autoRedraw) redraw();
			}
		}
		private var _artSet:ArtSet = new ArtSet();
		
		/**
		 * Default Art to be copied into a Feature if it does not
		 * yet already have one explicit set for it. This includes
		 * not yet having set a value for artName.
		 * Defaults are set when a Feature is added to an Avatar
		 * or when Avatar.library is set.
		 */
		public function get defaultArt():Art { return _defaultArt; }
		public function set defaultArt(value:Art):void {
			_defaultArt = value;
			if (autoRedraw) redraw();
		}
		private var _defaultArt:Art;
		
		/**
		 * Variations of colors (color transforms) that can be
		 * applied to art within this definition.   A colorSet
		 * cannot be null.
		 */
		public function get colorSet():SetCollection { return _colorSet; }
		public function set colorSet(value:SetCollection):void {
			if (value){
				_colorSet = value;
				if (autoRedraw) redraw();
			}
		}
		private var _colorSet:SetCollection = new SetCollection();
		
		/**
		 * Default Color to be copied into a Feature if it does not
		 * yet already have one explicit set for it. This includes
		 * not yet having set a value for colorName.
		 * Defaults are set when a Feature is added to an Avatar
		 * or when Avatar.library is set.
		 */
		public function get defaultColor():Color { return _defaultColor; }
		public function set defaultColor(value:Color):void {
			_defaultColor = value;
			if (autoRedraw) redraw();
		}
		private var _defaultColor:Color;
		
		/**
		 * Variations of adjusts that can be applied to
		 * art within this definition.  A adjustSet
		 * cannot be null.
		 */
		public function get adjustSet():SetCollection { return _adjustSet; }
		public function set adjustSet(value:SetCollection):void {
			if (value){
				_adjustSet = value;
				if (autoRedraw) redraw();
			}
		}
		private var _adjustSet:SetCollection = new SetCollection();
		
		/**
		 * Default Adjust to be copied into a Feature if it does not
		 * yet already have one explicit set for it. This includes
		 * not yet having set a value for adjustName.
		 * Defaults are set when a Feature is added to an Avatar
		 * or when Avatar.library is set.
		 */
		public function get defaultAdjust():Adjust { return _defaultAdjust; }
		public function set defaultAdjust(value:Adjust):void {
			_defaultAdjust = value;
			if (autoRedraw) redraw();
		}
		private var _defaultAdjust:Adjust;
		
		/**
		 * Constructor for creating new FeatureDefinition instances.
		 */
		public function FeatureDefinition(name:String = null) {
			super(name);
		}
		
		/**
		 * Indicates to a linked library that this FeatureDefinition
		 * has been changed.  This only applies to definitions contained 
		 * within a Library instance since this operation causes the
		 * containing Library instance to dispatch a 
		 * FeatureDefinitionEvent.CHANGED event so objects can react to
		 * data (definition) within the library being modified.
		 * @param	originalName This is the previous name of the 
		 * FeatureDefinition object if the reason for a redraw included
		 * a name change.  This is necessary to allow both related
		 * Features to be notified of the redraw, the Feature sharing 
		 * the current name of the FeatureDefinition and the Feature
		 * that was linked to the FeatureDefinition by the original name.
		 */
		override public function redraw(originalName:String = null):void {
			if (_library && !suppressDraw){
				_library.redrawFeatureDefinition(this, originalName);
			}
		}
		
		/**
		 * Creates a FeatureDefinition copy.
		 * @return A copy of this FeatureDefinition instance.
		 */
		override public function clone(copyInto:Object = null):Object {
			var copy:FeatureDefinition = (copyInto) ? copyInto as FeatureDefinition : new FeatureDefinition();
			if (copy == null) return null;
			super.clone(copy);
			
			if (_defaultAdjust) copy._defaultAdjust = _defaultAdjust.clone() as Adjust;
			if (_defaultArt) copy._defaultArt = _defaultArt.clone() as Art;
			if (_defaultColor) copy._defaultColor = _defaultColor.clone() as Color;
			copy._adjustSet = _adjustSet.clone() as SetCollection;
			copy._artSet = _artSet.clone() as ArtSet;
			copy._colorSet = _colorSet.clone() as SetCollection;
			
			// no library is copied - if a Library is cloned, it
			// will add this instance to it's collection at that
			// time which is when the library for this definition
			// is set
			
			return copy;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function getPropertiesIgnoredByXML():Object {
			var obj:Object = super.getPropertiesIgnoredByXML();
			obj.library = 1;
			return obj;
		}

	}
}