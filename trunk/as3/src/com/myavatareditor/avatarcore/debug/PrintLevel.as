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
	 * Information relating to the print function, notably print
	 * levels used when reporting different forms of data in calls to
	 * print. Specifying a print level determines whether or not the
	 * print is made visible based on its relationship to 
	 * PrintLevel.reporting.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class PrintLevel {
		
		public static const DEBUG:int			= -1;
		public static const NORMAL:int			= 0;
		public static const WARNING:int			= 1;
		public static const ERROR:int			= 2;
		public static const FATAL_ERROR:int		= 3;
		
		/**
		 * Normally, print will trace messages using
		 * the trace() method. When omitTrace is true, 
		 * trace() is not called with print.
		 */
		public static var omitTrace:Boolean		= false;
		
		/**
		 * When true, prefixes the source.toString() of the print
		 * call to the beginning of the print message.
		 */
		public static var includeSource:Boolean	= false;
		
		/**
		 * Represents the lowest error level to report
		 * in print messages.
		 */
		public static var reporting:int		= NORMAL;
		
		/**
		 * Collection of prefixes used to prepend to a printed message
		 * based on its level.
		 */
		public static const prefixes:Array = ["", "[Warning] ", "[Error] ", "[FATAL ERROR] "];
		
	}
	
}