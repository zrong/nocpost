package controller.setConfig
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SetUploadCopartnerPhotoCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			ConfigProxy.UPLOAD_COPARTNER_PHOTO = notification.getBody() as Array;
		}
	}
}