package controller.setConfig
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SetIsCopartnerComplexCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			ConfigProxy.IS_NEED_COPARTNER_INFO = notification.getBody() as Boolean;
		}
	}
}