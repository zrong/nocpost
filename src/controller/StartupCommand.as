package controller
{
	
	import controller.prepare.*;
	
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class StartupCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ModelPrepCommand);
			addSubCommand(CtrlPrepCommand);
			addSubCommand(ViewPrepCommand);
		}
	}
}