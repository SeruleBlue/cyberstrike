package
{
	import flash.display.MovieClip;

	public class D_Console extends MovieClip
	{
		private var diagArr:Array = [];
		private var MAX_LEN:int = 7;
		private var i:int;
		private var j:int;
		private var str:String;
		
		public function D_Console()
		{
			tf.text = "";
			updateText("Battle started.");
		}
		
		public function updateText(s:String):void
		{
			j = diagArr.length;
			if (j == MAX_LEN)
				diagArr.shift();
			diagArr.push(s);
			
			str = "";
			j = diagArr.length;
			for (i = 0; i < j; i++)
				str += diagArr[i] + "\n";
			tf.text = str;
		}
	}
}
