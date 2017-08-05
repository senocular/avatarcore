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
	
	import com.myavatareditor.avatarcore.Feature;
	import com.myavatareditor.avatarcore.display.ArtSprite;
	
	/**
	 * Interface for behaviors used to modify or otherwise influence
	 * the presentation of an avatar on the screen. Any behavior used
	 * within a Feature of FeatureDefinition's behavior collection should
	 * implement this interface.  Behavior objects within behaviors collections
	 * have their methods called during two steps of the avatar presentation
	 * process: once when avatar sprites are being created, and once when
	 * those sprites are being drawn.  In each case, these operations 
	 * happen after the respective operations of the Feature class internally.
	 * The one exception is with parent-related adjustments which occur after.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public interface IBehavior extends IClonable {
		
		/**
		 * A callback used by AvatarDisplay objects in creating the ArtSprite
		 * instances necessary to display an avatar feature visually.  This
		 * is used by IBehavior objects to control what sprites appear on screen.
		 * AvatarDisplay objects first call Feature.getArtSprites to get the
		 * sprites from the defined feature as specified by that feature's
		 * related Art object (commonly this is one art asset but can be
		 * many if that Art contains multiple Art instances itself).  Then, for
		 * each behavior, IBehavior.getArtSprites is called passing
		 * in the feature for which sprites are being created as well
		 * as the sprites already created by that feature or any previous 
		 * IBehavior that was run before the current.  The sprites returned
		 * then become part part of the visible set to be passed to the next
		 * feature or what will ultimately be the AvatarDisplay that initially made
		 * the request for the feature's art sprites.
		 * @param	feature The feature for which art sprites are being created.
		 * @param	sprites Sprites created so far for this feature.
		 * @return The sprites to ultimately be used by an AvatarDisplay in displaying
		 * the feature.
		 */
		function getArtSprites(feature:Feature, sprites:Array):Array;
		
		/**
		 * A callback used by AvatarDisplay objects in drawing the various ArtSprite
		 * instances used to display an avatar feature visually. This is used
		 * by IBehavior objects to control how sprites apprar on screen.
		 * AvatarDisplay objects first call Feature.drawArtSprite to draw the
		 * sprites from the defined feature as specified by that feature's
		 * related Adjust and Color objects.  Then, for each behavior,
		 * IBehavior.drawArtSprite is called for each art sprite allowing it to
		 * manipulate the sprite further.  Each IBehavior is able to affect the
		 * visual representation of the sprite in the order in which it is defined
		 * in a behaviors collection with the last in the collection the last
		 * behavior able to have any affect.
		 * @param	artSprite The art sprite being drawn.
		 */
		function drawArtSprite(artSprite:ArtSprite):void;
	}
}