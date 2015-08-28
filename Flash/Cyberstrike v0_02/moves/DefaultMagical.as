package moves
{
	public class DefaultMagical extends A_Move
	{
		public function DefaultMagical()
		{
			mName = "M.Attack";
			nameArr = [mName, mName, mName];

			PHY = [ 0,  0,  0];
			MAG = [ 8,  9, 11];
			ATB = [0.4, 0.1, 4.0];
		}
	}
}