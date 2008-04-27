package controller.prepare
{
	import controller.*;
	import controller.setConfig.*;
	
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
			facade.registerCommand(ApplicationFacade.VAR_SUBMIT, VarSubmitCommand);
			
			facade.registerCommand(ApplicationFacade.SET_CONFIG_IS_TEACHER, SetIsTeacherCommand);
			facade.registerCommand(ApplicationFacade.SET_CONFIG_IS_COPARTNER_COMPLEX, SetIsCopartnerComplexCommand);
			
			facade.registerCommand(ApplicationFacade.UPLOAD_FILE_FILLED, UploadFilledCommand);
			
			facade.registerCommand(ApplicationFacade.SUBMIT_PANEL_BUILD, SubmitPanelBuildCommand);
			facade.registerCommand(ApplicationFacade.SUBMIT_PANEL_REMOVE, SubmitPanelRemoveCommand);
		}
		
	}
}