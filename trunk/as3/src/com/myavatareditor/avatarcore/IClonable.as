package com.myavatareditor.avatarcore {
	
	/**
	 * Interface for AvatarCore objects that implement
	 * cloning.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public interface IClonable {
		/**
		 * Creates and returns a copy of the current instance.
		 * @param	copyInto A variable for internal use only, this
		 * value represents the instance of a superclass into
		 * which properties of the current class are to be copied
		 * into.  This allows superclasses to copy private data
		 * into subclasses when a subclass creates a copy and 
		 * gives it to the super clone via: super.clone(copy);
		 * When an implementation of clone receives a copy, it 
		 * uses that instance instead of creating a new instance
		 * of its own.
		 * @return A copy of the current instance.
		 */
		function clone(copyInto:Object = null):Object;
	}
	
}