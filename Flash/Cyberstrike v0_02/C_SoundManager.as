package
{
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class C_SoundManager
	{
		private var eng:MovieClip;
		public var sndMap:Object = new Object();
		public var bgm:SoundChannel;
		public var sndTF:SoundTransform = new SoundTransform();
		public var timer:Timer;
		public var fade:int = 0;
		public var maxFade:int = 1;

		public function C_SoundManager(_eng:MovieClip)
		{
			eng = _eng;
			// -- add sound definitions here		
			sndMap["SFX_readyBeep"] = new SFX_readyBeep();

			//sndMap["BGM_MissionNormal"] = new BGM_MissionNormal();	

		}
		
		public function playBGM(s:String):void
		{
			stopBGM();
			bgm = sndMap[s].play(0, int.MAX_VALUE);
		}
		
		public function stopBGM():void
		{
			if (bgm)
			{
				bgm.stop();
				fade = 0;
				if (timer)
				{
					if (timer.hasEventListener(TimerEvent.TIMER))
						timer.removeEventListener(TimerEvent.TIMER, tick);
					timer.stop();
				}
			}
		}
		
		// duration in frames
		public function fadeBGM(duration:int = 30):void
		{
			fade = maxFade = duration;
			sndTF.volume = 1;
			timer = new Timer(33);
			timer.addEventListener(TimerEvent.TIMER, tick);
			timer.start();
		}
		
		private function tick(e:TimerEvent):void
		{
			sndTF.volume = fade / maxFade;
			if (bgm)
				bgm.soundTransform = sndTF;
			if (--fade <= 0)
				stopBGM();
		}
		
		public function playSound(s:String):void
		{
			sndMap[s].play();
		}
		
		public function shutUp():void
		{
			SoundMixer.stopAll();
		}
	}
}
