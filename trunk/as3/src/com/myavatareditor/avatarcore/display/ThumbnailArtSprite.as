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
package com.myavatareditor.avatarcore.display {
	
	import com.myavatareditor.avatarcore.Art;
	import com.myavatareditor.avatarcore.Avatar;
	import com.myavatareditor.avatarcore.Feature;
	
	/**
	 * A variation of ArtSprite that loads the thumbnail 
	 * of an Art instance.  If no thumbnail is available, a
	 * custom, child AvatarDisplay consisting of only those child
	 * art assets contained within a rendered Avatar.
	 * This class is used only to display thumbnails of an Art
	 * instance for custom purposes; It is not for use within 
	 * an AvatarDisplay object. 
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class ThumbnailArtSprite extends SourceLoaderSprite {
		
		/**
		 * Target from which to generate a thumbnail.
		 */
		public function get target():Object {
			return _target;
		}
		public function set target(value:Object):void {
			if (value == _target) return;
			
			_target = value;
			this.src = ("thumbnail" in _target) ? _target.thumbnail : null;
		}
		private var _target:Object;
		
		/**
		 * Feature associated with the thumbnail.  This is dynamically
		 * created and only available if the Art associated with this
		 * thumbnail had no thumbnail value causing the Art itself to
		 * be used as the  thumbnail's imagery.
		 */
		public function get feature():Feature {
			return _feature;
		}
		private var _feature:Feature;
		
		/**
		 * Constructor for new ThumbnailArtSprite instances.
		 */
		public function ThumbnailArtSprite(target:Object = null, autoLoad:Boolean = true) {
			super(null);
			
			mouseChildren = false;
			if (target) {
				this.target = target;
				if (autoLoad) load();
			}
		}
		
		/**
		 * Loads the thumbnail graphics into the ThumbnailArtSprite
		 * instance.
		 * @param	src An optional source to load content from.
		 */
		override public function load(src:String = null):void {
			// cleanup
			_feature = null;
			
			if (src == null && this.src == null && _target is Art){
				// render in a custom Avatar instance
				clearContent();
				addAvatarContent();
			}else{
				// generic super-defined load()
				super.load(src);
			}
		}
		
		private function addAvatarContent():void {
			var avatar:Avatar = new Avatar();
			_feature = new Feature();
			feature.art = _target as Art;
			avatar.addItem(feature);
			
			var avatarDisplay:AvatarDisplay = new AvatarDisplay();
			addInstance(avatarDisplay);
			
			// make sure on display list when constructing for
			// COMPLETE events
			avatarDisplay.avatar = avatar;
		}
	}
}