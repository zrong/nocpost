package controller.prepare
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ApplicationMediator;

	public class ViewPrepCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new ApplicationMediator(notification.getBody()));
			var __configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			__configProxy.getConfig();
		}
		
	}
}