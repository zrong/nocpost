package controller
{
	
	import controller.prepare.*;
	
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class StartupCommand extends MacroCommand
	{
		override public function initializeMacroCommand():void
		{
			addSubCommand(ModelPrepCommand);
			addSubCommand(CtrlPrepCommand);
			addSubCommand(ViewPrepCommand);
		}
	}
}