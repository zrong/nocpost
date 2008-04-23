package view
{
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ApplicationMediator extends Mediator
	{
		public static const NAME:String = 'ApplicationMediator';
		private var _submitPanel:SubmitPanel;
		private var _submitPanelMediator:SubmitPanelMediator;
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get app():post
		{
			return viewComponent as post;
		}
		
		override public function listNotificationInterests():Array
		{
			return [	ApplicationFacade.RPC_STEP_GET_INFO_DONE,
						ApplicationFacade.RPC_STEP_SET_INFO_FAIL,
						ApplicationFacade.RPC_STEP_SET_INFO_DONE	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RPC_STEP_GET_INFO_DONE:
					
					break;
				case ApplicationFacade.RPC_STEP_SET_INFO_DONE:
					_buildSubmitPanel();
					break;
				case ApplicationFacade.RPC_STEP_SET_INFO_FAIL:
					PopUpManager.removePopUp(_submitPanel);
					break;
			}
		}
		
		private _buildSubmitPanel():void
		{
			_submitPanel = PopUpManager.createPopUp(app, SubmitPanel, true) as SubmitPanel;
			PopUpManager.centerPopUp(_submit);
			_submitPanelMediator = new SubmitPanelMediator(_submitPanel);;
		}
	}
}