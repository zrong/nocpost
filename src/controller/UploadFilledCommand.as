/**
 * 当上传数组被填充的时候此Command调用
 * */
package controller
{
	import model.UploadProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class UploadFilledCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __uploadProxy:UploadProxy = facade.retrieveProxy(UploadProxy.NAME) as UploadProxy;
			__uploadProxy.setData(notification.getBody() as Array);
		}
	}
}