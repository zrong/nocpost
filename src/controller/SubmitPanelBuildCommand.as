package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.SubmitPanelMediator;
	import view.component.SubmitPanel;

	public class SubmitPanelBuildCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __submitPanel:SubmitPanel = PopUpManager.createPopUp(app, SubmitPanel, true) as SubmitPanel;
			PopUpManager.centerPopUp(__submitPanel);
			var __submitPanelMediator:SubmitPanelMediator = new SubmitPanelMediator(__submitPanel);;
			facade.registerMediator(__submitPanelMediator);
		}
	}
}