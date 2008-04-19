package controller.prepare
{
	import controller.GetConfigDoneCommand;
	import controller.GetInfoDoneCommand;
	import controller.VarUpdateCommand;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class CtrlPrepCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerCommand(ApplicationFacade.STEP_GET_CONFIG_DONE, GetConfigDoneCommand);
			facade.registerCommand(ApplicationFacade.STEP_GET_INFO_DONE, GetInfoDoneCommand);
			
			facade.registerCommand(ApplicationFacade.VAR_UPDATE, VarUpdateCommand);
		}
		
	}
}