package 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import characters.A_Character;
	
	// Character Portrait
	public class UI_CP extends MovieClip
	{
		public var char:A_Character;
		
		private var ui:MovieClip;
		private var overclock:Array;
		private var OC_BASE:int = 51;		// y coordinate: 17 = 100%, 51 = 0%
		private var OC_HEIGHT:int = 34;		// OC_BASE - (OC % * OC_HEIGHT) for correct bar placement
		
		private var BAR_BASE:Number = -190.3;
		private var BAR_WIDTH:Number = 123.15;		// width of HP/ATB bar
		
		private var hpTgtPos:Number = 123.15;
		private var BAR_CLOSE:Number = BAR_WIDTH * .015;
		private var BAR_STEP:Number = BAR_WIDTH * .01;
		
		private var prevATB:Number = -1;		// only update ATB frame/mask if this changes
		private var prevATBstate:String = "";

		public function UI_CP()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			ui = base.main;
			stop();
		}
		
		public function setCharacter(_char:A_Character):void
		{
			char = _char;
			if (!char)
			{
				visible = false;
				return;
			}
			
			visible = true;
			char.UIdisp = this;
			
			try
			{
				ui.portrait.gotoAndStop(char.cName);
			} catch (err:Error)
			{
				ui.portrait.gotoAndStop("default");
			}
			
			ui.tf_name.text = char.cName;
			ui.tf_lvl.text = char.lvl.toString();
			// -- TODO set mods
			overclock = [ui.UI_overclock0, ui.UI_overclock1, ui.UI_overclock2, ui.UI_overclock3];			
			ui.tf_hp.text = (Math.round(char.HP[2])).toString();

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
				ui.tf_hp.text = (Math.round((ui.ui_hp.bar.x * .00812 + 1.5453) * char.HP[2])).toString();
			}

			ui.ui_atb.UI_ready.visible = char.ATB[1] == char.ATB[2];
			ui.ui_atb.bar.x = BAR_BASE + BAR_WIDTH * (char.ATB[1] / 10);
			if (prevATB != char.ATB[2])
			{
				prevATB = char.ATB[2];
				ui.ui_atb.atbFrame.x = ui.ui_atb.atbMask.x = BAR_BASE + BAR_WIDTH * (char.ATB[2] / 10);	// B = 0
			}
			if (prevATBstate != char.cState)			// set ATB color
			{
				prevATBstate = char.cState;
				ui.ui_atb.bar.gotoAndStop(prevATBstate == "IDLE" ? 1 : 2);
			}

			var i:int;
			var oc:Boolean = (char.ocActive || char.OVR[1] == 400);
			ui.UI_overclock.visible = oc;
			var perc:Number;
			for (i = 0; i < 4; i++)
			{
				overclock[i].bar.gotoAndStop(oc ? i+1 : 1);		// -- TODO fix
				perc = char.OVR[1] - (i * 100);
				if (perc > 100) perc = 1;
				else perc *= .01;
				overclock[i].bar.y = OC_BASE - (OC_HEIGHT * perc);
			}
		}
		
		public function shake():void
		{
			base.gotoAndPlay("shake");
		}
	}
}
