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
	
	import com.myavatareditor.avatarcore.events.FeatureDefinitionEvent;
	import com.myavatareditor.avatarcore.IBehavior;
	import com.myavatareditor.avatarcore.debug.print;
	import com.myavatareditor.avatarcore.debug.PrintLevel;
	import com.myavatareditor.avatarcore.display.ArtSprite;
	import com.myavatareditor.avatarcore.events.FeatureEvent;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * Represents a feature within an avatar.  Features describe a part
	 * of an avatar and how it is represented by graphical assets and 
	 * physical adjustments such as position, scale, or color. Feature
	 * values can be defined directly within the feature itself or link
	 * to definitions within a FeatureDefinitioninstance of a library which
	 * gets associated with the feature when an avatar containing the feature
	 * is linked with a Library object.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class Feature extends FeatureBase {
		
		private static const defaultSetID:String = "0"; // collection 'name' if not provided
		
		/**
		 * Setting the name of Features automatically calls
		 * updateParentHierarchy() in the associated Avatar instance
		 * and redraws the feature.
		 */
		override public function set name(value:String):void {
			if (this.name == value) return;
			
			// redrawing will happen after updating the parent
			// hierarchy which must be done after the value is
			// set so suppress drawing that would occur in 
			// super and draw after updating parents
			suppressDraw = true;
			try {
				super.name = value;
			}catch (error:*){}
			suppressDraw = false;
			
			if (_avatar && autoRedraw){
				_avatar.updateParentHierarchy();
				redraw();
			}
		}
		
		/**
		 * A specific Art object to be applied to an avatar. This can contain
		 * an Art definition or, if a name property is defined, be linked
		 * to an Art definition within a respective FeatureDefinition object.
		 * When set, the feature is automatically updated.
		 */
		public function get art():Art { return _art; }
		public function set art(value:Art):void {
			_art = value;
			if (autoRedraw) redraw();
		}
		private var _art:Art;
		
		/**
		 * The art name used by Features to associate themselves with
		 * art in FeatureDefinition objects. This value does not have 
		 * precedence over Feature.art.name if available, however will
		 * be used if this Feature has no art value.
		 */
		public function get artName():String { return _artName; }
		public function set artName(value:String):void {
			if (_artName == value) return;
			_artName = value;
			if (autoRedraw) redraw();
		}
		private var _artName:String;
			
		/**
		 * Style name for this feature.  When defined, art associated
		 * with this feature must be of the same style to be visible.
		 * When set, the feature is automatically updated. artStyle is
		 * an optional helper method that is ignored when not used. It
		 * only applies when Art instances used by this feature have
		 * for them a defined Art.style property.
		 */
		public function get artStyle():String { return _artStyle; }
		public function set artStyle(value:String):void {
			if (_artStyle == value) return;
			_artStyle = value;
			if (autoRedraw) redraw();
		}
		private var _artStyle:String; // defaults to not using
		
		/**
		 * Adjustments (position, size, and rotation) to be applied
		 * to a feature and its art.  When null, no adjustment is
		 * applied (x=0, y=0, scale=1, rotation=0). If a name property is
		 * defined, it can be linked to an Color definition within a 
		 * respective FeatureDefinition object.  This adjust is applied
		 * on top of a definitions baseAdjust if defined. When set, the
		 * feature is automatically updated.
		 */
		public function get adjust():Adjust { return _adjust; }
		public function set adjust(value:Adjust):void {
			_adjust = value;
			if (autoRedraw) redraw();
		}
		private var _adjust:Adjust;
		
		/**
		 * This property is a shortcut for referencing adjusts by name in a 
		 * referenced library. Feature.adjust.name will be used if available,
		 * otherwise this value will be used to reference a FeatureDefinition's
		 * Adjust in an Avatar's library. Using Feature name properties can make
		 * Feature definitions simpler when libraries are being used.
		 */
		public function get adjustName():String { return _adjustName;  }
		public function set adjustName(value:String):void {
			if (_adjustName == value) return;
			_adjustName = value;
			if (autoRedraw) redraw();
		}
		private var _adjustName:String;
		
		/**
		 * A specific color to be applied to an avatar. This can contain
		 * a Color definition or, if a name property is defined, be linked
		 * to an Color definition within a respective FeatureDefinition object.
		 * When set, the feature is automatically updated.
		 */
		public function get color():Color { return _color; }
		public function set color(value:Color):void {
			_color = value;
			if (autoRedraw) redraw();
		}
		private var _color:Color;
		
		/**
		 * This property is a shortcut for referencing color by name in a 
		 * referenced library. Feature.color.name will be used if available,
		 * otherwise this value will be used to reference a FeatureDefinition's
		 * Color in an Avatar's library. Using Feature name properties can make
		 * Feature definitions simpler when libraries are being used.
		 */
		public function get colorName():String { return _colorName; }
		public function set colorName(value:String):void {
			if (_colorName == value) return;
			_colorName = value;
			if (autoRedraw) redraw();
		}
		private var _colorName:String;
		
		/**
		 * A reference to the parent feature referenced by parentName. This
		 * is automatically set when parentName is set.
		 */
		public function get parent():Feature { return _parent; }
		public function set parent(value:Feature):void {
			if (value){
				if (!_avatar){
					print("Parents cannot be set when a feature is not associated with an avatar", PrintLevel.ERROR, this);
					return;
				}else if (value._avatar != _avatar) {
					print("Parent features must share the same avatar", PrintLevel.ERROR, this);
					return;
				}
			}
			
			setParent(value);
			
			if (_avatar && autoRedraw){
				_avatar.updateParentHierarchy();
				redraw();
			}
		}
		private var _parent:Feature;
		
		/**
		 * Private set parent method without public-facing validation and redraw.
		 * This is isolated since parent assignment can happen through 
		 * updateParentHierarchy which may cause unnecessary updates.
		 */
		private function setParent(feature:Feature):void {
			_parent = feature;
			super.parentName = (feature) ? feature.name : null; // super set to prevent re-update
		}
		
		/**
		 * Setting the parent name for Features automatically calls
		 * updateParentHierarchy() in the associated Avatar instance
		 * and redraws the feature.
		 */
		override public function set parentName(value:String):void {
			if (parentName == value) return;
			
			// redrawing will happen after updating the parent
			// hierarchy which must be done after the value is
			// set so suppress drawing that would occur in 
			// super and draw after updating parents
			suppressDraw = true;
			try {
				super.parentName = value;
			}catch (error:*){}
			suppressDraw = false;
			
			if (_avatar && autoRedraw){
				_avatar.updateParentHierarchy();
				redraw();
			}
		}
		
		/**
		 * Identifies how many parents this feature has as specified
		 * by it's parent (or parentName) property.
		 */
		public function get parentCount():int { return _parentCount; }
		private var _parentCount:int;
		
		/**
		 * The avatar that is associated with this feature.  This is 
		 * set automatically when the feature is added to an avatar
		 * through Avatar.addItem(). This property serves as a reference
		 * to the avatar instance in that relationship. Each Feature
		 * can only exist within one Avatar at a time.
		 */
		public function get avatar():Avatar { return _avatar; }
		public function set avatar(value:Avatar):void {
			_avatar = value;
			
			// the avatar will need to update its parent
			// hierarchy to update the feature's parents
			_parent = null;
			_parentCount = 0;
		}
		private var _avatar:Avatar;
		
		/**
		 * The feature definition that is to be associated with this
		 * Feature.  This reference is obtained directly through 
		 * the associated Avatar based on the Avatar's name and
		 * associated Library instance.
		 */
		public function get definition():FeatureDefinition {
			if (_avatar == null) return null;
			
			var thisName:String = this.name;
			if (!thisName) return null;
			
			var library:Library = _avatar.library;
			if (library == null) return null;
			
			return library.getItemByName(thisName);
		}
		
		/**
		 * Constructor for creating new Feature instances.
		 */
		public function Feature(name:String = null) {
			super(name);
		}
		
		/**
		 * Creates a Feature copy.  Any associated Avatar or Definition objects
		 * are not copied. These would be reassigned when the cloned feature
		 * is added into a separate Avatar's collection (for example if an
		 * Avatar object containing features is cloned, the cloned features
		 * would be associated with the new Avatar resulting from the Avatar
		 * clone and would not be responsible for creating their own copies).
		 * @return A copy of this Feature instance.
		 */
		override public function clone(copyInto:Object = null):Object {
			var copy:Feature = (copyInto) ? copyInto as Feature : new Feature();
			if (copy == null) return null;
			super.clone(copy);
			
			copy._artStyle = _artStyle;
			copy._artName = _artName;
			copy._colorName = _colorName;
			copy._adjustName = _adjustName;
			if (_color) copy._color = _color.clone() as Color;
			if (_adjust) copy._adjust = _adjust.clone() as Adjust;
			if (_art) copy._art = _art.clone() as Art;
			
			// no avatar is copied - if an Avatar is cloned, it
			// will add this instance to it's collection at that
			// time which is when the avatar for this feature is set
			// no definition is copied; this is handled by Avatar
			// no parent information is retained; this is handled by Avatar
			
			return copy;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function getPropertiesIgnoredByXML():Object {
			var obj:Object = super.getPropertiesIgnoredByXML();
			obj.avatar = 1;
			obj.definition = 1;
			obj.parent = 1;
			obj.parentCount = 1;
			return obj;
		}
		
		/**
		 * Indicates to Avatar stakeholders (i.e. AvatarDisplay) that this feature
		 * has been  changed.  This only applies to features contained within
		 * an Avatar instance since this operation causes the containing Avatar 
		 * instance to dispatch a FeatureEvent.CHANGED event so objects can react to
		 * data (feature) within the avatar being modified. Unless autoRedraw is set
		 * to false, this will automatically get called when properties in Feature
		 * are set.
		 */
		override public function redraw(originalName:String = null):void {
			if (_avatar && !suppressDraw){
				_avatar.redrawFeature(this, originalName);
			}
		}
		
		/**
		 * Copies feature characteristics (Art, Colors, Adjusts, and Behaviors)
		 * from the referenced feature definition into the feature's own
		 * characteristics.  This would be used to create a self-contained
		 * version of the feature that would be able to be displayed 
		 * without the library.
		 */
		public function consolidate():void {
			
			var thisDefinition:FeatureDefinition = this.definition;
			if (thisDefinition){
				
				var defArt:Art;
				var defColor:Color;
				var defAdjust:Adjust;
				
				name = thisDefinition.name;
				parentName = thisDefinition.parentName;
				
				defArt = thisDefinition.artSet.getItemByName(artName) as Art;
				art = (defArt) ? defArt.clone() as Art : null;
				
				defColor = thisDefinition.colorSet.getItemByName(colorName) as Color;
				color = (defColor) ? defColor.clone() as Color : null;
				
				defAdjust = thisDefinition.adjustSet.getItemByName(adjustName) as Adjust;
				adjust = (defAdjust) ? defAdjust.clone() as Adjust : null;
				
				defAdjust = thisDefinition.baseAdjust;
				baseAdjust = (defAdjust) ? defAdjust.clone() as Adjust : null;
				
				behaviors.clearCollection();
				behaviors.copyCollectionFrom(thisDefinition.behaviors);
			}else{
				print("Cannot consolidate Feature [name:" + name + "] because it is not linked to a library definition", PrintLevel.WARNING, this);
			}
		}
		
		/**
		 * Returns the art sprites needed to represent this feature.
		 * This is called internally by AvatarDisplay to create the sprites
		 * used to present the avatar on screen.
		 * @param	sprites Any set of pre-existing art sprites
		 * assumed to be necessary for the feature.
		 * @return An array of art sprites.
		 */
		public function getArtSprites(sprites:Array = null):Array {
			if (sprites == null){
				sprites = [];
			}
			
			// use definition art through name reference if available
			// otherwise fallback to local art object
			var featureArt:Art = getRenderedArt();
			var i:int;
			var collection:Array;
			
			if (featureArt == null){
				print("Creating Feature Art; no feature art found for "+this, PrintLevel.WARNING, this);
				return sprites;
			}
			
			// get the style used by this feature
			var currStyle:String = getRenderedArtStyle();
			
			// if the Art for this feature doesn't contain
			// any collection items (child Art objects) use
			// it as a single art asset, otherwise use its
			// children.
			collection = featureArt.collection;
			if (collection.length == 0) {
				
				// single Art object as one art sprite
				if (currStyle == featureArt.style) {
					sprites.push(new ArtSprite(featureArt, this));
				}
				
			}else{
				
				// multiple Art objects as a group
				var childArt:Art;
				i = collection.length;
				while (i--){
					childArt = collection[i] as Art;
					if (childArt) {
						
						// add if style matches the art's style
						// by default, they should both be null
						// and therefore match
						if (currStyle == childArt.style) {
							sprites.push(new ArtSprite(childArt, this));
						}
					}
				}
				
				// in the case that no child sprites were
				// found in the collection, revert back to
				// using the original art. This would happen if the
				// Art collection had only non-Art items
				if (sprites.length == 0 && currStyle == featureArt.style) {
					sprites.push(new ArtSprite(featureArt, this));
				}
			}
			
			// call getArtSprites for behaviors
			var behavior:IBehavior;
			var thisDefinition:FeatureDefinition = this.definition;
			collection = thisDefinition ? thisDefinition.behaviors.collection : behaviors.collection;
			i = collection.length;
			while (i--){
				behavior = collection[i] as IBehavior;
				if (behavior){
					sprites = behavior.getArtSprites(this, sprites);
				}
			}
			
			return sprites;
		}
		
		/**
		 * Returns the Art object used by this feature to display itself
		 * visually.  This can come from one of two source, the feature's
		 * own art definition, or a referenced Art in an artSet from a
		 * linked FeatureDefinition instance.  If such an Art object does not
		 * exist, null is returned.
		 * @return The Art object used by this feature to display itself
		 * visually.
		 */
		public function getRenderedArt():Art {
			var featureArt:Art;
			// find the rendered art name to use
			// to get an art from the linked definition
			var renderedArtName:String = null;
			
			var thisDefinition:FeatureDefinition = this.definition;
			if (thisDefinition){
				
				// from assigned instance
				if (_art){
					renderedArtName = _art.name;
				}
				// explicitly provided name
				if (!renderedArtName){
					renderedArtName = _artName;
				}
				// default from definition
				if (!renderedArtName){
					renderedArtName = thisDefinition.artSet.defaultName;
				}
				
				// grab art from definition by discovered name
				if (renderedArtName){
					featureArt = thisDefinition.artSet.getItemByName(renderedArtName) as Art;
				}
			}
			
			// art in avatar if not found in definition
			if (featureArt == null) {
				featureArt = _art;
			}
			
			// last resort: get first item in definition
			if (featureArt == null && thisDefinition){
				var defaultArt:Art = thisDefinition.artSet.getItemByName(defaultSetID) as Art;
				if (defaultArt){
					print("Could not resolve an art name for "+this+"; using the first in the definition set as a default", PrintLevel.NORMAL, this);
					featureArt = defaultArt;
				}
			}
			
			// return featureArt whether or not its defined
			// unlike with adjust and color, art here can be null
			return featureArt;
		}
		
		/**
		 * Returns the Art style used by this Feature.  This will normally be the
		 * the value of Feature.artStyle.  If that's not defined, the ArtSet of the 
		 * associated FeatureDefinition is checked for a defaultStyleName value.
		 * If neither is defined, null is returned.
		 * @return A string representing the Art style used to render this Feature.
		 */
		public function getRenderedArtStyle():String {
			
			// for styles, the explicitly defined style has precedence
			if (_artStyle){
				return _artStyle;
			}
			
			// if no explicit style, look to definition
			var thisDefinition:FeatureDefinition = this.definition;
			if (thisDefinition){
				// art from definition
				return thisDefinition.artSet.defaultStyleName;
			}
			
			return null;
		}
		
		/**
		 * Returns the Adjust object used by this feature to display itself
		 * visually. This adjustment is a combination of any baseAdjust as well
		 * as the defined adjust. This can come from one of two sources, the feature's
		 * own adjust and baseAdjust definitions, or those referenced from a
		 * linked FeatureDefinition instance.  If such an Adjust object does not
		 * exist, a new, default Adjust instance is returned.  The adjust returned
		 * by getRenderedAdjust does not account for parent adjustments.
		 * @return The Adjust object used by this feature to display itself
		 * visually. This will never be a direct reference to a Feauture's or
		 * FeatureDefinition's own Adjust object; always a new Adjust reference.
		 */
		public function getRenderedAdjust():Adjust {
			var featureBaseAdjust:Adjust;
			var featureAdjust:Adjust;
			
			var thisDefinition:FeatureDefinition = this.definition;
			if (thisDefinition){
				
				// base adjust from definition
				featureBaseAdjust = thisDefinition.baseAdjust;
				
				// find the rendered adjust name to use
				// to get an art from the linked definition
				var renderedAdjustName:String;
				
				// from assigned instance
				if (_adjust){
					renderedAdjustName = _adjust.name;
				}
				// explicitly provided name
				if (!renderedAdjustName){
					renderedAdjustName = _adjustName;
				}
				// default from definition
				if (!renderedAdjustName){
					renderedAdjustName = thisDefinition.adjustSet.defaultName;
				}
				
				// grab art from definition by discovered name
				if (renderedAdjustName){
					featureAdjust = thisDefinition.adjustSet.getItemByName(renderedAdjustName) as Adjust;
				}
			}
			
			// baseAdjust in avatar if not found in definition
			if (featureBaseAdjust == null) {
				featureBaseAdjust = baseAdjust;
			}
			
			// transform in avatar if not found in definition
			if (featureAdjust == null) {
				featureAdjust = _adjust;
			}
			
			// last resort: get first item in definition
			if (featureAdjust == null && thisDefinition){
				var defaultAdjust:Adjust = thisDefinition.adjustSet.getItemByName(defaultSetID) as Adjust;
				if (defaultAdjust){
					print("Could not resolve an adjust name for "+this+"; using the first in the definition set as a default", PrintLevel.NORMAL, this);
					featureAdjust = defaultAdjust;
				}
			}
			
			// resolve final adjust from found and base
			// only return clones, not original adjusts
			if (featureAdjust){
				featureAdjust = featureAdjust.clone() as Adjust;
				if (featureBaseAdjust) {
					featureAdjust.add(featureBaseAdjust);
				}
				return featureAdjust;
			}
			
			// no feature adjust found, but base adjust
			// exists so just return that
			if (featureBaseAdjust){
				return featureBaseAdjust.clone() as Adjust;
			}
			
			// none found; return new
			return new Adjust();
		}
		
		/**
		 * Returns the Color object used by this feature to display itself
		 * visually.  This can come from one of two source, the feature's
		 * own color definition, or a referenced Color in a colorSet from a
		 * linked FeatureDefinition instance. If such a Color object does not
		 * exist, a new, default Color instance is returned.
		 * @return The Color object used by this feature to display itself
		 * visually.
		 */
		public function getRenderedColor():Color {
			var featureColor:Color;
			
			var thisDefinition:FeatureDefinition = this.definition;
			if (thisDefinition){
				
				// find the rendered adjust name to use
				// to get an art from the linked definition
				var renderedColorName:String;
				
				// from assigned instance
				if (_color){
					renderedColorName = _color.name;
				}
				// explicitly provided name
				if (!renderedColorName){
					renderedColorName = _colorName;
				}
				// default from definition
				if (!renderedColorName){
					renderedColorName = thisDefinition.colorSet.defaultName;
				}
				
				// grab art from definition by discovered name
				if (renderedColorName){
					featureColor = thisDefinition.colorSet.getItemByName(renderedColorName) as Color;
				}
			}
			
			// color in avatar if not found in definition
			if (featureColor == null) {
				featureColor = _color;
			}
			
			// last resort: get first item in definition
			if (featureColor == null && thisDefinition){
				var defaultColor:Color = thisDefinition.colorSet.getItemByName(defaultSetID) as Color;
				if (defaultColor){
					print("Could not resolve a color name for "+this+"; using the first in the definition set as a default", PrintLevel.NORMAL, this);
					featureColor = defaultColor;
				}
			}
			
			// return featureColor if defined, otherwise 
			// new default color
			return featureColor || new Color();
		}
		
		/**
		 * Returns the behaviors collection being used to render this Feature
		 * instance.  This could be either the Feature's own behaviors
		 * collection or the collection referenced through the related
		 * FeatureDefinition.
		 * @return An ICollection representative of the Feature's behaviors.
		 */
		public function getRenderedBehaviors():ICollection {
			var thisDefinition:FeatureDefinition = this.definition;
			return thisDefinition ? thisDefinition.behaviors : behaviors;
		}
		
		/**
		 * Applies feature adjustments to an art sprite. This
		 * is called internally by AvatarDisplay to render the sprites
		 * it creates to present the avatar on screen.
		 * @param	artSprite The art sprite to apply feature
		 * adjustments to.
		 */
		public function drawArtSprite(artSprite:ArtSprite):void {
			if (artSprite == null) return;
			
			// apply transformation matrix
			setArtSpriteMatrix(artSprite, getRenderedAdjust().getMatrix())
			
			// apply color
			// 0 colorize -> no color; NaN/other colorize -> color
			var spriteArt:Art = artSprite.art;
			var colorSetting:ColorTransform = (spriteArt && spriteArt.colorize !== 0)
					? getRenderedColor()
					: new ColorTransform();
			setArtSpriteColor(artSprite, colorSetting);
			
			
			// call drawArtSprite for behaviors
			var behavior:IBehavior;
			var collection:Array = getRenderedBehaviors().collection;
			var i:int, n:int = collection.length;
			for (i=0; i<n; i++){
				behavior = collection[i] as IBehavior;
				if (behavior){
					applyArtSpriteBehavior(artSprite, behavior);
				}
			}
			
			// apply parent adjustments
			if (_parent){
				applyArtSpriteParentTransform(artSprite, getConcatenatedParentMatrix());
			}
		}
		
		/**
		 * Sets the matrix (visual transform including position, rotation and size) 
		 * to an ArtSprite when it's being drawn.
		 * @param	artSprite The ArtSprite being drawn.
		 * @param	matrix The transform information for the ArtSprite. The standard
		 * behavior sets this matrix to ArtSprite.transform.matrix.
		 */
		protected function setArtSpriteMatrix(artSprite:ArtSprite, matrix:Matrix):void {
			artSprite.transform.matrix = matrix;
		}
		
		/**
		 * Sets the color to an ArtSprite when it's being drawn.
		 * @param	artSprite The ArtSprite being drawn.
		 * @param	color The color information for the ArtSprite. The standard
		 * behavior sets this color to ArtSprite.transform.colorTransform.
		 */
		protected function setArtSpriteColor(artSprite:ArtSprite, color:ColorTransform):void {
			artSprite.transform.colorTransform = color;
		}
		
		/**
		 * Applies a behavior to an ArtSprite.  For each behavior being applied,
		 * this function is called.
		 * @param	artSprite The ArtSprite being drawn.
		 * @param	behavior The behavior being applied to the ArtSprite.
		 */
		protected function applyArtSpriteBehavior(artSprite:ArtSprite, behavior:IBehavior):void {
			behavior.drawArtSprite(artSprite);
		}
		
		/**
		 * Applies the inherited transforms from the parent hierarchy
		 * of an art sprite to an art sprite. Transforms inherited include
		 * position and rotation. Scale or visibility is not inherited but
		 * position is affected by parent scaling.
		 * @param	artSprite The ArtSprite being drawn.
		 * @param	parentMatrix A matrix representative of the compound
		 * matrices of the feature's parents.
		 */
		protected function applyArtSpriteParentTransform(artSprite:ArtSprite, parentMatrix:Matrix):void {
			
			// NOTE: this approach (after v0.1.5) does not hide a sprite if its
			// parent is not correctly found
			
			// position
			var position:Point = new Point(artSprite.x, artSprite.y);
			position = parentMatrix.transformPoint(position);
			artSprite.x = position.x;
			artSprite.y = position.y;
			
			// rotation
			artSprite.rotation += Math.atan2(parentMatrix.b, parentMatrix.a) * 180/Math.PI;
			
			// scale is not inherited
		}
		
		/**
		 * Returns the matrix representing the (pseudo) parent coordinate space
		 * of the feature as determined by the adjust transforms of all parent
		 * features.  This method is used by drawArtSprite to correctly render
		 * a feature's art within it's parent.
		 * @return A matrix representing the combined matrices of all the
		 * parent objects.
		 */
		public function getConcatenatedParentMatrix():Matrix {
			var concatenatedMatrix:Matrix = new Matrix();
			var par:Feature = _parent;
			while (par){
				concatenatedMatrix.concat( par.getRenderedAdjust().getMatrix() );
				par = par._parent;
			}
			return concatenatedMatrix;
		}
		
		/**
		 * Finds and updates the parent property with the Feature in 
		 * the current avatar with a name matching parentName. This 
		 * function is automatically called when parentName is set,
		 * or when redraw() is called.
		 * @private
		 */
		internal function updateParent():void {
			var parentFeatureName:String;
			
			var thisDefinition:FeatureDefinition = this.definition;
			if (thisDefinition){
				parentFeatureName = thisDefinition.parentName;
			}
			if (parentFeatureName == null){
				parentFeatureName = parentName;
			}
			
			if (parentFeatureName && _avatar){
				var foundParent:Feature = _avatar.getItemByName(parentFeatureName) as Feature;
				if (foundParent){
					setParent(foundParent);
				}else{ 
				
					// if a parent is not found yet a name is given, keep the name
					// and leave the parent alone (aetting it will change the name)
					// just issue a warning in the case that a parent was expected
				
					print("Parent feature for "+this+" could not be found", PrintLevel.WARNING, this);
				}
			}else{
				_parent = null;
			}
		}
		
		/**
		 * Updates the count associated with the number of ancestors of
		 * this feature as determined by its parent and its parent's parents.
		 * Parent count is used to determine the order in which features are
		 * drawn.  Features which are the parents of other features must be 
		 * drawn first so their children can inherit their most up-to-date
		 * characteristics (namely applied adjustments and behaviors).
		 * @private
		 */
		internal function updateParentCount():void {
			_parentCount = 0;
			var recursionLookup:Dictionary = new Dictionary(true); // check to make sure parents don't create loop
			var parentFeature:Feature = _parent;
			
			while (parentFeature){
				recursionLookup[parentFeature] = true;
				parentFeature = parentFeature.parent;
								
				if (parentFeature && recursionLookup[parentFeature]) {
					// recursion occured
					print("Recursion in feature parent references", PrintLevel.ERROR, this);
					break;
				}
				_parentCount++;
			}
		}
		
		/**
		 * Copies defaults from a linked FeatureDefinition into this instance.
		 * @private
		 */
		internal function assignDefaults():void {
			
			var thisDefinition:FeatureDefinition = this.definition;
			if (thisDefinition){
				suppressDraw = true;
				try {
					// copy any defaults from definition
					if (_art == null){
						var defArt:Art = thisDefinition.defaultArt;
						if (defArt) art = defArt.clone() as Art;
					}
					if (_adjust == null){
						var defAdjust:Adjust = thisDefinition.defaultAdjust;
						if (defAdjust) adjust = defAdjust.clone() as Adjust;
					}
					if (_color == null){
						var defColor:Color = thisDefinition.defaultColor;
						if (defColor) color = defColor.clone() as Color;
					}
				}catch (error:*){
					print("Assigning Feature defaults: " + error.message, PrintLevel.ERROR, this);
				}
				suppressDraw = false;
			}
		}
	}
}