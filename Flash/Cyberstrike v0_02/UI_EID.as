package 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import characters.A_Character;

	// Enemy IDentifier
	public class UI_EID extends MovieClip
	{
		public var char:A_Character;
		
		private var ui:MovieClip;
		
		private var BAR_BASE:Number = -195.05;
		private var BAR_WIDTH:Number = 130.05;		// width of HP/ATB bar
		
		private var hpTgtPos:Number = -65;
		private var BAR_CLOSE:Number = BAR_WIDTH * .015;
		private var BAR_STEP:Number = BAR_WIDTH * .01;

		public function UI_EID()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			ui = main;
			stop();
		}
		
		public function setCharacter(_char:A_Character):void
		{
			char = _char;
			char.UIdisp = this;
			
			ui.tf_name.text = char.cName;
			// -- TODO set mods

			step();
		}
		
		public function step():void
		{
			if (!char) return;

			var hpPerc:Number = char.HP[1] / char.HP[2];
			hpTgtPos = BAR_BASE + BAR_WIDTH * hpPerc;
			if (ui.ui_hp.bar.x != hpTgtPos)
			{
				ui.ui_hp.bar.x += BAR_STEP * (ui.ui_hp.bar.x < hpTgtPos ? 1 : -1);
				if (Math.abs(hpTgtPos - ui.ui_hp.bar.x) < BAR_CLOSE)
					ui.ui_hp.bar.x = hpTgtPos;
				if (hpPerc <= .25)
					ui.ui_hp.bar.gotoAndStop(3);
				else if (hpPerc <= .5)
					ui.ui_hp.bar.gotoAndStop(2);
				else
					ui.ui_hp.bar.gotoAndStop(1);
			}
		}
		
		public function shake():void
		{
			gotoAndPlay("shake");
		}
	}
}
