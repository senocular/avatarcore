package {
	
	import com.myavatareditor.avatarcore.Adjust;
	import com.myavatareditor.avatarcore.Color;
	import com.myavatareditor.avatarcore.Constrain;
	import com.myavatareditor.avatarcore.display.ThumbnailArtSprite;
	import com.myavatareditor.avatarcore.display.Viewport;
	import com.myavatareditor.avatarcore.Feature;
	import com.myavatareditor.avatarcore.Art;
	import com.myavatareditor.avatarcore.FeatureDefinition;
	import com.myavatareditor.avatarcore.Range;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	/**
	 * A button for changing feature art (type).
	 */
	public class ArtTypeButton extends Sprite {
		
		private var feature:Feature; // feature to modify when clicked
		private var art:Art; // the library art for the feature to reference when updated
		
		public function ArtTypeButton(feature:Feature, art:Art, definition:FeatureDefinition){
			this.feature = feature;
			this.art = art;
			
			initializeThumbnail(definition);
			
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, clickToUpdateHandler, false, 0, true);
		}
		
		private function initializeThumbnail(definition:FeatureDefinition):void {
			
			// create a thumbnail for the Art
			var thumb:ThumbnailArtSprite = new ThumbnailArtSprite(art);
			
			// if no thumbnail is referenced, the thumb sprite will
			// dynamically create an avatar with one feature to draw
			// the art. If that feature exists, modify it to appear
			// better in the preview through coloring and adjusts
			var thumbFeature:Feature = thumb.feature;
			if (thumbFeature){
				
				
				// #1. apply color from definition
				var colors:Array = definition.colorSet.getItemsByType(Color);
				if (colors.length){
					
					// use metadata, if available, to pick color
					// default to the first color (at 0 index)
					var index:int = 0;
					if (definition.meta && definition.meta.thumbnailColor){
						index = int(definition.meta.thumbnailColor);
					}
					
					// assign color. a clone is used to ensure nothing
					// changed in the feature's color modifies the original
					// in the library which should remain unchanged
					thumbFeature.color = Color(colors[index]).clone() as Color;
				}
				
				
				// #2. get a middle-value rotation from the constraint
				// if available and it contains a rotation range
				// scale and position is handled automatically by the
				// thumbnail sprite
				var constrains:Array = definition.behaviors.getItemsByType(Constrain);
				if (constrains.length){
					
					var constrain:Constrain = constrains[constrains.length - 1]; // last constrain
					var range:Range = constrain.rotation;
					if (range){
						
						var adjust:Adjust = new Adjust();
						adjust.rotation = range.valueAt(.5); // 50% into range
						thumbFeature.adjust = adjust;
					}
				}
			}
			
			
			// add the thumbnail to a fitted viewport
			// matching the size of this button
			var view:Viewport = new Viewport(width, height, thumb);
			view.fitContent(5); // center and scale to fit
			view.filters = [new DropShadowFilter(2, 45, 0, 0.5, 2, 2)];
			addChild(view);
		}
		
		private function clickToUpdateHandler(event:MouseEvent):void {
			
			// set referenced avatar feature to reference the 
			// art specified by this button when it was created
			feature.artName = art.name;
		}
	}
}