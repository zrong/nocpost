package view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.interfaces.IStep;

	public class StepTeacherPayMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepTeacherPayMediator';
		
		public function StepTeacherPayMediator($mediatorName:String=null, viewComponent:Object=null)
		{
			super($mediatorName, viewComponent);
		}
		
		public function buildVariable():void{}
	}
}