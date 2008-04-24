package controller
{
	import model.UploadProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class UploadSubmitCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			sendNotification(ApplicationFacade.SUBMIT_PANEL_BUILD);	//首先建立百分比条
			var __uploadProxy:UploadProxy = facade.retrieveProxy(UploadProxy.NAME) as UploadProxy;
			__uploadProxy.upload();	
		}
	}
}