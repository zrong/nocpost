package controller
{
	import flash.external.ExternalInterface;
	
	import model.type.ErrorType;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ErrorCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getType())
			{
				case ErrorType.ALERT:
					alert(notification.getBody().toString());
					break;
				case ErrorType.ERROR:
					alert(notification.getBody().toString());
					close();
					break;
			}
		}
		
		
		private function alert($str:String):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call('alert', $str);
			}
			else
			{
				Alert.show($str);
			}
		}
		
		private function close():void
		{
			Logger.info('执行Output.close()');
			if(ExternalInterface.available)
			{
				Logger.info('执行ExternalInterface.call');
				//ExternalInterface.call('window.close()');
				ExternalInterface.call('delFlash');
			}
			else
			//如果不能使用JavaScript代码，就直接卸载application的所有子显示对象
			{
				Application.application.removeAllChildren();
			}
		}
	}
}