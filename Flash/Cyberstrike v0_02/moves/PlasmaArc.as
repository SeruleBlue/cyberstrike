package moves
{
	public class PlasmaArc extends A_Move
	{
		public function PlasmaArc()
		{
			mName = "PlasmaArc";
			nameArr = [mName, mName, mName];

			PHY = [ 0,  0,  0];
			MAG = [13, 17, 21];
			ATB = [1.0, 0.5, 3.5];
		}
	}
}