package
{
	import controller.StartupCommand;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{
		public static const STARTUP:String = 'startup';
		public static const ERROR:String = 'error';
		
		public static const RPC_STEP_GET_CONFIG_DONE:String = 'stepGetConfigDone';
		
		public static const RPC_STEP_GET_INFO_DONE:String = 'stepGetInfoDone';
		public static const RPC_STEP_GET_INFO_FAIL:String = 'stepGetInfoFail';
		public static const RPC_STEP_GET_INFO_ERROR:String = 'stepGetInfoError';
		
		public static const RPC_STEP_SET_INFO_DONE:String = 'stepSetInfoDone';
		public static const RPC_STEP_SET_INFO_FAIL:String = 'stepSetInfoFail';
		public static const RPC_STEP_SET_INFO_ERROR:String = 'stepSetInfoError';
		
		public static const RPC_STEP_SET_INFO_DONE:String = 'stepSetInfoDone';
		public static const RPC_STEP_UPLOAD_DONE:String = 'stepUploadDone';
		
		public static const NAV_ACCEPT:String = 'navAccept';
		public static const NAV_REJECT :String = 'navReject';
		public static const NAV_PREV:String = 'navPrev';
		public static const NAV_NEXT:String = 'navNext';
		public static const NAV_SUBMIT:String = 'navSubmit';
		public static const NAV_END:String = 'navEnd';
		public static const NAV_BEFORE_END:String = 'navBeforeEnd';	//beforeEnd的意思是倒数第二个
		public static const NAV_START:String = 'navStart';
		
		public static const VAR_UPDATE:String = 'varUpdate';
		public static const VAR_SUBMIT:String = 'varSubmit';
		public static const VAR_SUBMIT_SET_PROGRESS_BAR:String = 'varSubmitSetPB';
		
		public static const SET_CONFIG_IS_TEACHER:String = 'setIsTeacher';
		public static const SET_CONFIG_IS_COPARTNER_COMPLEX:String = 'setIsCopartnerComplex';
		
		public static const BUILD_TEACHER:String = 'buildTeacher';
		public static const BUILD_STUDENT:String = 'buildStudent';
		
		public static const UPLOAD_FILE_FILLED:String = 'uploadFileFilled';
		public static const UPLOAD_FILE_SUBMIT:String = 'uploadFileSubmit';
		
		public static const SUBMIT_PANEL_BUILD:String = 'spBuild';
		public static const SUBMIT_PANEL_REMOVE:String = 'spRemove';
		
		public static const PROJECT_CHANGE:String = 'projectChange';
		
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