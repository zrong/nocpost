package view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.interfaces.IStep;

	public class StepCopartnerComplexMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepCopartnerComplexMediator';
		
		public function StepCopartnerComplexMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
	}
}