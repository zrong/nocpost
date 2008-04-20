package model
{
	import flash.net.URLVariables;
	
	import model.type.*;
	
	import mx.core.Application;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	[Bindable]
	public class ConfigProxy extends Proxy
	{
		public static const NAME:String = 'ConfigProxy';
		
		public static var CONFIG_DATA:XML;		//第一次获取（get_info）的时候保存在这个变量中
		public static var RESULT_DATA:XML;	//数据提交后返回的信息保存在这个变量中
		public static var SUBMIT_VAR:URLVariables = new URLVariables();	//要提交的变量
		public static var UPLOAD_FILES:Array = new Array();	//要上传的文件对象数组
		public static var UPLOAD_COPARTNER_PHOTO:Array = new Array();	//合作者的照片数组，仅当需要合作者详细信息的时候，这个数组才有用
		public static var IS_NEED_COPARTNER_INFO:Boolean;	//是否需要详细的合作者信息
		
		public static var URL:String;	//保存要提交的网址，此值从URL变量传来
		public static var URL_GET_INFO_VAR:URLVariables;	//保存要获取信息时提交的变量
		public static var PDT_ID:String;	//保存作品的ID，此值从URL变量传来
		public static var USER_TYPE:String;	//保存用户类型，此值从URL变量传来
		public static var MOD_TYPE:String;	//保存对数据库进行操作的类型，此值从URL变量传来，可能的值见model.type.ModeType
		
		public static var IS_MODIFY:Boolean;	//保存当前对数据库到做的类型是否是添加，这个值是为了方便调用，因为每次判断Config.MOE_TYPE==mod太费事情
		public static var IS_USER:Boolean;		//保存当前用户是否是参赛用户，这个值是为了方便调用，因为每次判断Config.USER_TYPE==3太费时
		public static var IS_TEACHER:Boolean;	//保存当前用户是否是教师用户。
		
		public static const SEPARATOR:String = '[*]';
		
		public function ConfigProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function getConfig():void
		{
			var __param:Object = Application.application.parameters; 
			URL = __param.config;
			USER_TYPE = __param.user_type;
			PDT_ID = __param.pdt_id;
			MOD_TYPE = __param.mod_type;
			
			IS_MODIFY = (MOD_TYPE == ModeType.MODIFY);
			IS_USER = (USER_TYPE == UserType.USER);
			//====================调试信息
			IS_MODIFY = false;
			URL = '../assets/get_info.xml';
			//Config.URL = 'http://10.2.1.3/noc/zpsc/zp_upload_deal_all.php?mod_step=step_get_info';
			//Config.URL = 'http://10.2.1.3/noc/zpsc/zp_upload_deal_all.php?mod_step=step_get_info&pdt_id=2&mod_type=mod';
			USER_TYPE = '99';
			PDT_ID = '2';
			//=====================
			
			URL_GET_INFO_VAR = buildUrlGetInfoVar();
			
			Logger.debug('url:{0}',URL_GET_INFO_VAR);
			sendNotification(ApplicationFacade.RPC_STEP_GET_CONFIG_DONE);
		}
		
		private function buildUrlGetInfoVar():URLVariables
		{
			var __var:URLVariables = new URLVariables();
			__var[StepType.RPC_STEP_NAME] = StepType.RPC_STEP_GET_INFO;
			__var.pdt_id = PDT_ID;
			__var.mod_type = MOD_TYPE;
			return __var;
		}
	}
}