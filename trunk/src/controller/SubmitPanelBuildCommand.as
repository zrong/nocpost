package controller
{
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ApplicationMediator;
	import view.SubmitPanelMediator;
	import view.component.SubmitPanel;

	public class SubmitPanelBuildCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __mediator:ApplicationMediator = facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;	
			var __submitPanel:SubmitPanel = PopUpManager.createPopUp(__mediator.getViewComponent() as post, SubmitPanel, true) as SubmitPanel;
			PopUpManager.centerPopUp(__submitPanel);
			var __submitPanelMediator:SubmitPanelMediator = new SubmitPanelMediator(__submitPanel);;
			facade.registerMediator(__submitPanelMediator);
		}
	}
}