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
	
	/**
	 * Prints a message to the terminal (standard out) via trace() 
	 * and/or a PrintWindow instance if one has been created. The print
	 * function does nothing if the printed message specifies a level
	 * that is less than the value of PrintLevel.reporting.
	 * @see PrintLevel#reporting
	 * @author Trevor McCauley; www.senocular.com
	 */
	public function print(message:*, level:int = 0, source:* = null):void {
		// validate 
		if (level < PrintLevel.reporting){
			return;
		}
		
		// massaging the message
		var msg:String = String(message);
		
		if (level in PrintLevel.prefixes){
			msg = PrintLevel.prefixes[level] + msg;
		}
		
		if (PrintLevel.includeSource && source){
			msg = source.toString() + msg;
		}
		
		// tracing the message
		if (!PrintLevel.omitTrace){
			trace(msg);
		}
		
		// display in print window
		var window:PrintWindow = PrintWindow.getInstance();
		if (window){
			window.print(msg);
		}
	}
}

