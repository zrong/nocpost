/**
 * 当第一步开始提交变量数据的时候，执行这个命令
 * */
package controller
{
	import model.SetInfoProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class VarSubmitCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			sendNotification(ApplicationFacade.SUBMIT_PANEL_BUILD);	//首先建立百分比条
			var __setInfoProxy:SetInfoProxy = facade.retrieveProxy(SetInfoProxy.NAME) as SetInfoProxy;
			__setInfoProxy.setInfo();			
		}		
	}
}