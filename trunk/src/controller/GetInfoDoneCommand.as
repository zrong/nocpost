package controller
{
	import model.ConfigProxy;
	import model.GetInfoProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class GetInfoDoneCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __getInfoProxy:GetInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			var __data:XML = __getInfoProxy.getData() as XML;
			
			//如果是修改状态或者是用户状态，就根据mod_content获取project的值，并发布一个projectChange事件
			var __isModifyOrUser:Boolean = (ConfigProxy.IS_MODIFY||ConfigProxy.IS_USER);
			if(__isModifyOrUser)
			{
				var __project:XML = __data.project.item.(@id==__data.mod_content.pdt_kind)[0] as XML;				
				sendNotification(ApplicationFacade.PROJECT_CHANGE, __project);
			}
		}
	}
}