package 
{
	import flash.display.MovieClip;

	public class UI_Actor extends MovieClip
	{
		public function UI_Actor()
		{
		}
		
		public function flip(isNormal:Boolean):void
		{
			eid.scaleX = Math.abs(eid.scaleX) * (isNormal ? 1 : -1);
			tf_name.scaleX = Math.abs(tf_name.scaleX) * (isNormal ? 1 : -1);
			spellbox.scaleX = Math.abs(spellbox.scaleX) * (isNormal ? 1 : -1);
			ui_active.scaleX = Math.abs(ui_active.scaleX) * (isNormal ? 1 : -1);
		}
	}
}