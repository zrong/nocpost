package controller.setConfig
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SetIsTeacherCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			ConfigProxy.IS_TEACHER = notification.getBody() as Boolean;
		}
	}
}