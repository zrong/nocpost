package view
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.NavButton;

	public class NavButtonMediator extends Mediator
	{
		public static const NAME:String = 'NavButtonMediator';
		
		public function NavButtonMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			nav.addEventListener(NavButton.PREV, prevClick);
			nav.addEventListener(NavButton.NEXT, nextClick);
			nav.addEventListener(NavButton.ACCEPT, acceptClick);
			nav.addEventListener(NavButton.REJECT, rejectClick);
			nav.addEventListener(NavButton.SUBMIT, submitClick);			
		}
		
		private function get nav():NavButton
		{
			return viewComponent as NavButton;
		}
		
		override public function listNotificationInterests():Array
		{
			return [	ApplicationFacade.NAV_END,
						ApplicationFacade.NAV_START,
						ApplicationFacade.NAV_BEFORE_END	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NAV_END:
					nav.removeChild(nav.nextBTN);
					nav.addChild(nav.submitBTN);
					break;
				case ApplicationFacade.NAV_START:
					nav.removeAllChildren();
					nav.addChild(nav.rejectBTN);
					nav.addChild(nav.acceptBTN);
					break;
				case ApplicationFacade.NAV_BEFORE_END:
					nav.removeChild(nav.submitBTN);
					nav.addChild(nav.nextBTN);
					break;
			}
		}
		
		private function prevClick(evt:Event):void
		{
			sendNotification(ApplicationFacade.NAV_PREV);
		}
		
		private function nextClick(evt:Event):void
		{
			sendNotification(ApplicationFacade.NAV_NEXT);
			//Logger.info((vs.selectedChild as Object).name);
			/*
			try
			{
				(vs.selectedChild as IStep).buildVariable();
				vs.selectedIndex ++;
				if(vs.selectedIndex > (vs.numChildren -2))
				{
					this.removeChild(this.nextBTN);
					this.addChild(this.submitBTN);
				}
			}
			catch(err:Error)
			{
				Logger.debug(err.getStackTrace());
				Output.alert(err.message);
			}*/	
		}
		
		private function acceptClick(evt:Event):void
		{
			nav.removeAllChildren();
			nav.addChild(nav.prevBTN);
			nav.addChild(nav.nextBTN);
			sendNotification(ApplicationFacade.NAV_ACCEPT);
		}
		
		private function rejectClick(evt:Event):void
		{
			
		}
		
		private function submitClick(evt:Event):void
		{
			sendNotification(ApplicationFacade.NAV_SUBMIT);
			/*
			try
			{
				(vs.selectedChild as StepUpload).validateUpload(); 
				Application.application.submit();
			}
			catch(err:Error)
			{
				Logger.debug(err.getStackTrace());
				Output.alert(err.message);
			}
			*/
		}
	}
}