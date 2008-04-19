package view
{
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class StepWorksMediator extends Mediator
	{
		public static const NAME:String = 'StepWorksMediator';
		public function StepWorksMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
	}
}