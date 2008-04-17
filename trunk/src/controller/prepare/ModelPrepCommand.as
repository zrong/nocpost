package controller.prepare
{
	import model.ConfigProxy;
	import model.GetInfoProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ModelPrepCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerProxy(new ConfigProxy());
			facade.registerProxy(new GetInfoProxy());
		}
		
	}
}