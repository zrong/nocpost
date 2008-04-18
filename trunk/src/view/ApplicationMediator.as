package view
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ApplicationMediator extends Mediator
	{
		public static const NAME:String = 'ApplicationMediator';
		
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
			return [	ApplicationFacade.STEP_GET_INFO_DONE	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.STEP_GET_INFO_DONE:
					
					break;
			}
		}		
	}
}