package view
{
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class StepUploadMediator extends Mediator
	{
		public static const NAME:String = 'StepUploadMediator';
		
		public function StepUploadMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
	}
}