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
	import com.myavatareditor.avatarcore.*;
	import com.myavatareditor.avatarcore.display.*;
	import com.myavatareditor.avatarcore.xml.*;
	import flash.display.Sprite;

	/**
	 * Document class for Avatar Core Hello world! example.
	 */
	public class HelloWorld extends Sprite {
		public function HelloWorld(){
			
			// defines Avatar object 
			var avatarXML:XML =
				<Avatar xmlns="com.myavatareditor.avatarcore">
					<Feature>
						<art src="http://www.myavatareditor.com/avatarcore/images/tutorial/hello_world.png" />
					</Feature>
				</Avatar>;
			
			// object used to parse XML into its respective
			// object instance(s)
			var xmlParser:XMLDefinitionParser = new XMLDefinitionParser();
			
			// an Avatar instance generated from the XML. It
			// inherently contains the Feature object and the Art
			// (in the Feature) as defined by the XML being parsed
			var avatar:Avatar = xmlParser.parse(avatarXML) as Avatar;

			// the visual display object to represent the Avatar
			// on screen
			var avatarDisplay:AvatarDisplay = new AvatarDisplay(avatar);
			addChild(avatarDisplay);
			
		}
	}
}