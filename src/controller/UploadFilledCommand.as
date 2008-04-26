/**
 * 当上传数组被填充的时候此Command调用
 * */
package controller
{
	import model.UploadProxy;
	import model.type.StepType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class UploadFilledCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __uploadProxy:UploadProxy = facade.retrieveProxy(UploadProxy.NAME) as UploadProxy;
			switch(notification.getType())
			{
				case StepType.RPC_STEP_PHOTO:
					__uploadProxy.uploadPhoto = notification.getBody() as Array;
					break;
				case StepType.RPC_STEP_UPLOAD:
					__uploadProxy.uploadFile = notification.getBody() as Array;
					break;
			}
			
		}
	}
}