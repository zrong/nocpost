package controller
{
	import model.SetInfoProxy;
	import model.vo.IVariables;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class VarUpdateCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __setInfoProxy:SetInfoProxy = facade.retrieveProxy(SetInfoProxy.NAME) as SetInfoProxy;
			__setInfoProxy.updateData(notification.getBody() as IVariables);
		}
	}
}