package view
{
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.SubmitPanel;

	public class SubmitPanelMediator extends Mediator
	{
		
		public static const NAME:String = 'SubmitPanelMediator';
		
		public function SubmitPanelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get submitPanel():SubmitPanel
		{
			return viewComponent as SubmitPanel;
		}
		
		override public function listNotificationInterests():Array
		{
			return [	ApplicationFacade.VAR_SUBMIT_SET_PROGRESS_BAR	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.VAR_SUBMIT_SET_PROGRESS_BAR:
					submitPanel.setPB.apply(null, notification.getBody() as Array);
					break;
			}
		}
		
		public function removeSubmitPanel():void
		{
			PopUpManager.removePopUp(submitPanel);
		}
		
		
	}
}