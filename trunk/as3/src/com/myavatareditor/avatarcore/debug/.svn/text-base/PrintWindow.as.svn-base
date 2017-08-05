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
package com.myavatareditor.avatarcore.debug {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * A generic print window for displaying print messages
	 * from the print function. If more than one PrintWindow
	 * instance is created, only the last window will receive
	 * print text.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class PrintWindow extends Sprite {
		
		/**
		 * Returns the last PrintWindow instance created. Generally
		 * only one instance of of PrintWindow is created and used
		 * for all messaging.  If a PrintWindow instance has not yet
		 * been created, this will return null.
		 * @return A reference to the last PrintWindow instance
		 * created.
		 */
		public static function getInstance():PrintWindow {
			return instance;
		}
		private static var instance:PrintWindow;
		
		/**
		 * The textfield used within the PrintWindow for displaying
		 * text.
		 */
		public function get textField():TextField {
			return _textField;
		}
		private var _textField:TextField;
		
		/**
		 * Constructor for new PrintWindow instances.
		 * @param	width The width of the window.
		 * @param	height The height of the window.
		 */
		public function PrintWindow(width:Number = 100, height:Number = 100) {
			instance = this;
			createTextField(width, height);
		}
		
		/**
		 * Displays the string representation of the supplied content 
		 * in the PrintWindow instance on a new line.
		 * @param	msg The message to display in the PrintWindow.
		 */
		public function print(msg:*):void {
			var txt:String = _textField.text;
			if (txt) txt += "\n";
			txt += String(msg);
			_textField.text = txt;
		}
		
		/**
		 * Clears the text within the PrintWindow.
		 */
		public function clear():void {
			_textField.text = "";
		}
		
		private function createTextField(width:Number = 100, height:Number = 100):void {
			_textField = new TextField();
			_textField.width = width;
			_textField.height = height;
			_textField.background = true;
		}
	}
}