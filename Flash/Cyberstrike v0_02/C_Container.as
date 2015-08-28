package 
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class C_Container extends MovieClip
	{
		public var completed:Boolean;
		
		public function C_Container()
		{
			completed = false;
		}
		
		public function step(e:Event):Boolean
		{
			// -- override this function
			return completed;
		}
	}
}
