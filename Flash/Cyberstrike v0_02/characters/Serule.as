package characters
{
	import moves.Lightning;
	import moves.BlulectricBarrage;
	import moves.DefaultPhysical;
	import moves.Cure;

	public class Serule extends A_Character
	{
		
		public function Serule(_battle:Battle, _avatarIndex:int)
		{
			super(_battle, _avatarIndex);
			
			cName = "Serule";
			isPC = true;
			
		//		   B    A	C  L
			 HP = [325,	0,	0, 55    ];	
			ATK = [  7,	0,	0,  1.875];	
			DEF = [ 10,	0,	0,  3.750];	
			MAG = [ 18,	0,	0,  5.750];	
			MGR = [ 17,	0,	0,  5.375];	
			ACC = [ 21,	0,	0,  0    ];	
			EVA = [ 12,	0,	0,  0    ];	
			SPD = [  5,	0,	0,  0.125];	
			OVR = [100,	0,	0,  6.250];	
			AGG = [  0,	0,	0,  0    ];	
			LUK = [  0,	0,	0,  0    ];	
			ATB = [  5,	0,	0,  0    ];	
			
			OVR[A] = 300;	// temp
			
			ELEMOD[ICE] = 1.33;
			ELEMOD[LIG] = 0.25;
			
			MOVES = [new Lightning(), new DefaultPhysical(), new Cure(), new BlulectricBarrage()];
		}
	}
}