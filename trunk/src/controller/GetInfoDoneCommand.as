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
			
			//在获取到XML资料时更新几个常用变量的值
			var __modify:XML = XML(__data.mod_content[0]);	//涉及到修改的XML内容
			var __isModifyOrUser:Boolean = (ConfigProxy.IS_MODIFY||ConfigProxy.IS_USER);
			if(__isModifyOrUser)
			{
				ConfigProxy.IS_NEED_COPARTNER_INFO = (__data.project.item.(@id==__modify.pdt_kind)[0] as XML).author_need_info == '1';
				ConfigProxy.IS_TEACHER = (__data.project.item.(@id==__modify.pdt_kind)[0] as XML).is_teacher == '1';
			}
		}
	}
}