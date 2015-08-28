package moves
{
	public class Lightning extends A_Move
	{
		public function Lightning()
		{
			mName = "Thunder";
			nameArr = [mName, "Thundera", "Thundaga"];

			PHY = [ 0,  0,  0];
			MAG = [13, 17, 21];
			ATB = [1.0, 0.5, 3.5];
			
			eleAttr[LIG] = true;
		}
	}
}