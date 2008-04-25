package view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.interfaces.IStep;

	public class StepCopartnerSimpleMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepCopartnerSimpleMediator';
		
		public function StepCopartnerSimpleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
	}
}