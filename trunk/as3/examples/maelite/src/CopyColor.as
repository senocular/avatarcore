package {
	
	import com.myavatareditor.avatarcore.Feature;
	import com.myavatareditor.avatarcore.IBehavior;
	import com.myavatareditor.avatarcore.display.ArtSprite;
	
	/**
	 * Behavior to copy the colorName used by this Feature to
	 * the target Feature.
	 */
	public class CopyColor implements IBehavior {
		
		/**
		 * The name of the Feature into which the colorName is
		 * to be copied.
		 */
		public var targetFeatureName:String;
		private var locked:Boolean = false; // prevents recursion
		
		/**
		 * Constructor for new CopyColor instances.
		 * @param	targetFeatureName Name of the feature to copy
		 * the color into.
		 */
		public function CopyColor(targetFeatureName:String = null){
			this.targetFeatureName = targetFeatureName;
		}
		
		/**
		 * Returns the art sprites used by the Feature.  CopyColor does
		 * not change the sprites being used.
		 */
		public function getArtSprites(feature:Feature, sprites:Array):Array {
			
			// do not allow nested calls which could create 
			// an infinite redraw recursion loop
			if (!locked){
				locked = true;
				try {
					
					var targetFeature:Feature = feature.avatar.getItemByName(targetFeatureName) as Feature;
					targetFeature.colorName = feature.colorName;
					// ^ setting will call an update which risks recursion loop 
					// (which necessitates the lock)
					
				}catch (error:Error){
					// avatar or styledFeature probably not found
				}
				locked = false;
			}
			return sprites;
		}
		
		/**
		 * CopyColor takes no action for drawArtSprite.
		 */
		public function drawArtSprite(artSprite:ArtSprite):void {}
		
		/**
		 * Creates and returns a new CopyColor instance with all
		 * the same properties as the current.
		 * @return A new CopyColor instance.
		 */
		public function clone(copyInto:Object = null):Object {
			var copy:CopyColor = (copyInto) ? copyInto as CopyColor : new CopyColor();
			copy.targetFeatureName = targetFeatureName;
			return copy;
		}
	}
}