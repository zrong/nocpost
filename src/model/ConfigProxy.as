package model
{
	import flash.net.URLVariables;
	
	import model.type.*;
	
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
		
		public static const SEPARATOR:String = '[*]';
		
		public static const REQUIRED_FIELD_ERROR:String = '此项为必填！'; 
		public static const TOO_SHORT_ERROR:String = '输入的文字不得少于{0}个！';
		public static const TOO_LONG_ERROR:String = '输入的文字不得多于{0}个！';
		
		public static const INVALID_CHAR_ERROR:String = 'E-mail地址中有错误字符。';
		public static const INVALID_DOMAIN_ERROR:String = 'E-mail地址中的域名不符合规范。';
		public static const INVALID_IP_DOMAIN_ERROR:String = 'E-mail地址中的IP格式域名不符合规范。';
		public static const INVALID_PERIODS_IN_DOMAIN_ERROR:String = '域名中的“.”错误。';
		public static const MISSING_AT_SIGN_ERROR:String = 'E-mail地址缺少“@”符号。';
		public static const MISSING_PERIODS_IN_DOMAIN_ERROR:String = '域名中缺少“.”。';
		public static const MISSING_USER_NAME_ERROR:String = 'E-mail地址缺少用户名。';
		public static const TOO_MANY_ANT_SIGN_ERROR:String = 'E-mail地址中的“@”符号太多。';
		
		public function ConfigProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function getConfig():void
		{
			var __param:Object = Application.application.parameters; 
			ConfigProxy.URL = __param.config;
			ConfigProxy.USER_TYPE = __param.user_type;
			ConfigProxy.PDT_ID = __param.pdt_id;
			ConfigProxy.MOD_TYPE = __param.mod_type;
			
			ConfigProxy.IS_MODIFY = (Config.MOD_TYPE == ModeType.MODIFY);
			ConfigProxy.IS_USER = (Config.USER_TYPE == UserType.USER);
			//====================调试信息
			ConfigProxy.IS_MODIFY = false;
			ConfigProxy.URL = '../assets/get_info.xml';
			//Config.URL = 'http://10.2.1.3/noc/zpsc/zp_upload_deal_all.php?mod_step=step_get_info';
			//Config.URL = 'http://10.2.1.3/noc/zpsc/zp_upload_deal_all.php?mod_step=step_get_info&pdt_id=2&mod_type=mod';
			ConfigProxy.USER_TYPE = '99';
			ConfigProxy.PDT_ID = '2';
			//=====================
			
			URL_GET_INFO_VAR = new URLVariables();
			URL_GET_INFO_VAR[StepType.STEP_NAME] = StepType.STEP_GET_INFO;
			URL_GET_INFO_VAR.pdt_id = ConfigProxy.PDT_ID;
			URL_GET_INFO_VAR.mod_type = ConfigProxy.MOD_TYPE;
			
			sendNotification(ApplicationFacade.STEP_GET_CONFIG_DONE);
		}
	}
}