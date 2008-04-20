package view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepUpload;
	import view.interfaces.IStep;

	public class StepUploadMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepUploadMediator';
		
		public function StepUploadMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get stepUpload():StepUpload
		{
			return viewComponent as StepUpload;
		}
		
	}
}