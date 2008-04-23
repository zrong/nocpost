package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.SubmitPanelMediator;

	public class SubmitPanelRemoveCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __submitPanelMediator:SubmitPanelMediator = facade.retrieveMediator(SubmitPanelMediator.NAME) as SubmitPanelMediator;
			__submitPanelMediator.removeSubmitPanel();
			facade.removeMediator(SubmitPanelMediator.NAME);
		}
	}
}