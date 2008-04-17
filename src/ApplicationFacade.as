package
{
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{
		public static var STARTUP:String = 'startup';
		
		public static var STEP_GET_CONFIG_DONE:String = 'stepGetConfigDone';
		public static var STEP_GET_INFO_DONE:String = 'stepGetInfoDone';
		public static var STEP_SET_INFO_DONE:String = 'stepSetInfoDone';
		public static var STEP_UPLOAD_DONE:String = 'stepUploadDone';
		
		public static function getInstance():ApplicationFacade
		{
			if(instance == null) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		public function startup(app:Object):void
		{
			sendNotification(STARTUP, app);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand( STARTUP, StartupCommand );
		}
		
	}
}