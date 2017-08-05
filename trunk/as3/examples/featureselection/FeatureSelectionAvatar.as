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
	
	import com.myavatareditor.avatarcore.Avatar;
	import com.myavatareditor.avatarcore.Definitions;
	import com.myavatareditor.avatarcore.events.SimpleDataEvent;
	import com.myavatareditor.avatarcore.debug.PrintLevel;
	import com.myavatareditor.avatarcore.display.AvatarDisplay;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	// Dependencies: class names here assures these classes are loaded in
	// the SWF even if not explicitly used (i.e. only referenced via XML)
	import com.myavatareditor.avatarcore.Constrain; Constrain;
	import com.myavatareditor.avatarcore.Mirror; Mirror;
	
	/**
	 * Sample avatar viewer SWF.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class FeatureSelectionAvatar extends Sprite {
		
		public var avatarDisplay:AvatarDisplay = new AvatarDisplay();
		private var definitions:Definitions = new Definitions();

		public function FeatureSelectionAvatar() {
			PrintLevel.reporting = PrintLevel.DEBUG;
			
			addChild(avatarDisplay);
			definitions.addEventListener(Event.COMPLETE, definitionsAvailable, false, 0, true);
			definitions.load(new URLRequest("feature_selection_definitions.xml"));
		}

		private function definitionsAvailable(event:SimpleDataEvent):void {
			avatarDisplay.avatar = definitions.getItemByName("myAvatar") as Avatar;
			dispatchEvent(new Event("avatarReady", true));
		}
	}
}