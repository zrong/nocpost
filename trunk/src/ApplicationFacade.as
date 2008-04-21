package
{
	import controller.StartupCommand;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{
		public static var STARTUP:String = 'startup';
		public static var ERROR:String = 'error';
		
		public static var RPC_STEP_GET_CONFIG_DONE:String = 'stepGetConfigDone';
		
		public static var RPC_STEP_GET_INFO_DONE:String = 'stepGetInfoDone';
		public static var RPC_STEP_GET_INFO_FAIL:String = 'stepGetInfoFail';
		public static var RPC_STEP_GET_INFO_ERROR:String = 'stepGetInfoError';
		
		public static var RPC_STEP_SET_INFO_DONE:String = 'stepSetInfoDone';
		public static var RPC_STEP_UPLOAD_DONE:String = 'stepUploadDone';
		
		public static var NAV_ACCEPT:String = 'navAccept';
		public static var NAV_REJECT :String = 'navReject';
		public static var NAV_PREV:String = 'navPrev';
		public static var NAV_NEXT:String = 'navNext';
		public static var NAV_SUBMIT:String = 'navSubmit';
		public static var NAV_END:String = 'navEnd';
		public static var NAV_BEFORE_END:String = 'navBeforeEnd';	//beforeEnd的意思是倒数第二个
		public static var NAV_START:String = 'navStart';
		
		public static var VAR_UPDATE:String = 'varUpdate';
		
		public static var SET_CONFIG_IS_TEACHER:String = 'setIsTeacher';
		public static var SET_CONFIG_IS_NEED_COPARTNER_INFO:String = 'setIsNeedCopartnerInfo';
		public static var SET_CONFIG_UPLOAD_COPARTNER_PHOTO:String = 'setUploadCopartnerPhoto';
		
		public static var BUILD_TEACHER:String = 'buildTeacher';
		public static var BUILD_STUDENT:String = 'buildStudent';
		
		public static function getInstance():ApplicationFacade
		{
			if(instance == null) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		public function startup(app:Object):void
		{
			Logger.TYPE = Logger.TRACE;
			sendNotification(STARTUP, app);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand( STARTUP, StartupCommand );
		}
		
	}
}