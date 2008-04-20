package controller.prepare
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.*;

	public class ViewPrepCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var __app:post = notification.getBody() as post;
			
			facade.registerMediator(new ApplicationMediator(__app));
			facade.registerMediator(new NavButtonMediator(__app.nav));
			facade.registerMediator(new StepVSMediator(__app.vs));			
			facade.registerMediator(new StepBasicMediator(__app.vs.stepBasic));
			facade.registerMediator(new StepWorksMediator(__app.vs.stepWorks));
			//facade.registerMediator(new StepUploadMediator(__app.vs.stepUpload));
			
			var __configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			__configProxy.getConfig();
		}
		
	}
}