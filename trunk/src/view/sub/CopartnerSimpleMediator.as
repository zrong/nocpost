package view.sub
{
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class CopartnerSimpleMediator extends Mediator
	{
		public static const NAME:String = 'CopartnerSimpleMediator';
		
		public function CopartnerSimpleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		
	}
}