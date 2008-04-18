package controller
{
	import model.GetInfoProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class GetInfoDoneCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __getInfoProxy:GetInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			var __data:XML = __getInfoProxy.getData() as XML;
			
		}
	}
}