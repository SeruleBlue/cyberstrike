package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class UI_DamagePopup extends MovieClip
	{
		var par:MovieClip;
		var amt:int;
		var inc:int = 1;
		
		public function UI_DamagePopup(_par:MovieClip, _amt:int)
		{
			par = _par;
			amt = Math.abs(_amt);
			x += Math.random() * 30 - 15;
			y += Math.random() * 40 - 120;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, step);
		}
		
		private function step(e:Event):void
		{
			pop.tf_text.text = Math.ceil(amt * inc * .1);
			if (++inc == 11)
				removeEventListener(Event.ENTER_FRAME, step);
		}
	
		private function completed():void
		{
			if (par)
				par.removeChild(this);
		}
	}
}
