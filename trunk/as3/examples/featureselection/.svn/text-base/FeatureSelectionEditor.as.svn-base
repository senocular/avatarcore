/*
Copyright (c) 2009 Trevor McCauley

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
package {
	
	import com.myavatareditor.avatarcore.Art;
	import com.myavatareditor.avatarcore.Avatar;
	import com.myavatareditor.avatarcore.Color;
	import com.myavatareditor.avatarcore.Feature;
	import com.myavatareditor.avatarcore.FeatureDefinition;
	import com.myavatareditor.avatarcore.Adjust;
	import fl.controls.List;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * Sample avatar editor SWF.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class FeatureSelectionEditor extends Sprite {
		
		public var featureList:List;
		public var artList:List;
		public var colorList:List;
		public var adjustList:List;
		private var loader:Loader = new Loader();
		private var avatar:Avatar;
		private var selectedDefinition:FeatureDefinition;
		private var selectedFeature:Feature;
		
		public function FeatureSelectionEditor() {
			addChild(loader);
			loader.addEventListener("avatarReady", avatarCompleteHandler, false, 0, true);
			loader.load(new URLRequest("FeatureSelectionAvatar.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));

			featureList.addEventListener(Event.CHANGE, featureItemChangedHandler, false, 0, true);
			artList.addEventListener(Event.CHANGE, artItemChangedHandler, false, 0, true);
			colorList.addEventListener(Event.CHANGE, colorItemChangedHandler, false, 0, true);
			adjustList.addEventListener(Event.CHANGE, adjustItemChangedHandler, false, 0, true);
		}
		
		private function populateList(list:List, source:Array, selected:String):void {
			list.removeAll();
			var i:int, n:int = source.length;
			for (i=0; i<n; i++){
				list.addItem({label:source[i].name, data:source[i]});
				if (source[i].name == selected) list.selectedIndex = i;
			}
		}
		
		private function avatarCompleteHandler(event:Event):void {
			avatar = FeatureSelectionAvatar(loader.content).avatarDisplay.avatar;
			populateList(featureList, avatar.library.getItemsByType(FeatureDefinition), null);
		}
		
		private function featureItemChangedHandler(event:Event):void {
			selectedDefinition = featureList.selectedItem.data as FeatureDefinition;
			selectedFeature = avatar.getItemByName(selectedDefinition.name) as Feature;
			
			populateList(artList, selectedDefinition.artSet.getItemsByType(Art), selectedFeature.artName);
			populateList(colorList, selectedDefinition.colorSet.getItemsByType(Color), selectedFeature.colorName);
			populateList(adjustList, selectedDefinition.adjustSet.getItemsByType(Adjust), selectedFeature.adjustName);
		}
		
		private function artItemChangedHandler(event:Event):void {
			selectedFeature.artName = artList.selectedItem.label;
		}
		
		private function colorItemChangedHandler(event:Event):void {
			selectedFeature.colorName = colorList.selectedItem.label;
		}
		
		private function adjustItemChangedHandler(event:Event):void {
			selectedFeature.adjustName = adjustList.selectedItem.label;
		}
	}
}