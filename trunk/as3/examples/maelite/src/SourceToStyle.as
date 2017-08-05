package {
	
	import com.myavatareditor.avatarcore.Art;
	import com.myavatareditor.avatarcore.Avatar;
	import com.myavatareditor.avatarcore.Feature;
	import com.myavatareditor.avatarcore.IBehavior;
	import com.myavatareditor.avatarcore.display.ArtSprite;
	
	/**
	 * Behavior to copy the Art.src value from the affected Feature
	 * to another Feature's artStyle property.  The Feature to have
	 * its artStyle changed is identified by the targetFeatureName property.
	 */
	public class SourceToStyle implements IBehavior {
		
		/**
		 * The name of the Feature for which the source of the
		 * assigned Feature is assigned to its style.
		 */
		public var targetFeatureName:String;
		private var locked:Boolean = false; // prevents recursion
		
		/**
		 * Constructor for new SourceToStyle instances.
		 * @param	targetFeatureName
		 */
		public function SourceToStyle(targetFeatureName:String = null){
			this.targetFeatureName = targetFeatureName;
		}
		
		/**
		 * Returns the art sprites used by the Feature.  SourceToStyle does
		 * not change the sprites being used.
		 */
		public function getArtSprites(feature:Feature, sprites:Array):Array {
			
			// do not allow nested calls which could create 
			// an infinite redraw recursion loop
			if (!locked){
				locked = true;
				try {
					
					var styledFeature:Feature = feature.avatar.getItemByName(targetFeatureName) as Feature;
					
					// if the currrent Feature's Art has children, use its first
					// child's src, otherwise use the src of the art itself
					var featureArt:Art = feature.getRenderedArt();
					var children:Array = featureArt.getItemsByType(Art);
					styledFeature.artStyle = (children.length) ? String(Art(children[0]).src) : String(featureArt.src);
					
				}catch (error:Error){
					// avatar or styledFeature probably not found
				}
				locked = false;
			}
			
			return sprites;
		}
		
		/**
		 * SourceToStyle takes no action for drawArtSprite.
		 */
		public function drawArtSprite(artSprite:ArtSprite):void {}
		
		/**
		 * Creates and returns a new SourceToStyle instance with all
		 * the same properties as the current.
		 * @return A new SourceToStyle instance.
		 */
		public function clone(copyInto:Object = null):Object {
			var copy:SourceToStyle = (copyInto) ? copyInto as SourceToStyle : new SourceToStyle();
			copy.targetFeatureName = targetFeatureName;
			return copy;
		}
	}
}