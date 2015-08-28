package moves
{
	public class BlulectricBarrage extends A_Move
	{
		public function BlulectricBarrage()
		{
			mName = "Blulectric Barrage";
			nameArr = [mName, mName, mName];

			PHY = [ 0,  0,  0];
			MAG = [19, 23, 30];
			ATB = [3.0, 1.0, 7.0];
			
			eleAttr[LIG] = true;
		}
	}
}