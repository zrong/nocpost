package controller.prepare
{
	import model.ConfigProxy;
	import model.GetInfoProxy;
	import model.SetInfoProxy;
	import model.UploadProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ModelPrepCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerProxy(new ConfigProxy());
			facade.registerProxy(new GetInfoProxy());
			facade.registerProxy(new SetInfoProxy());
			facade.registerProxy(new UploadProxy());
		}
		
	}
}