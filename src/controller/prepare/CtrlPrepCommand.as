package controller.prepare
{
	import controller.ErrorCommand;
	import controller.GetConfigDoneCommand;
	import controller.GetInfoDoneCommand;
	import controller.VarUpdateCommand;
	import controller.setConfig.SetIsNeedCopartnerInfoCommand;
	import controller.setConfig.SetIsTeacherCommand;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class CtrlPrepCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerCommand(ApplicationFacade.ERROR, ErrorCommand);
			facade.registerCommand(ApplicationFacade.RPC_STEP_GET_CONFIG_DONE, GetConfigDoneCommand);
			facade.registerCommand(ApplicationFacade.RPC_STEP_GET_INFO_DONE, GetInfoDoneCommand);
			
			facade.registerCommand(ApplicationFacade.VAR_UPDATE, VarUpdateCommand);
			
			facade.registerCommand(ApplicationFacade.SET_CONFIG_IS_TEACHER, SetIsTeacherCommand);
			facade.registerCommand(ApplicationFacade.SET_CONFIG_IS_NEED_COPARTNER_INFO, SetIsNeedCopartnerInfoCommand);
		}
		
	}
}