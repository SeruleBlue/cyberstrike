package moves
{
	public class DefaultPhysical extends A_Move
	{
		public function DefaultPhysical()
		{
			mName = "Attack";
			nameArr = [mName, mName, mName];

			PHY = [ 8,  9, 11];
			MAG = [ 0,  0,  0];
			ATB = [0.4, 0.1, 4.0];
		}
	}
}