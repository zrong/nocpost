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
		
		public static var IS_NEED_COPARTNER_INFO:Boolean;	//是否需要详细的合作者信息
		
		public static var URL:String;	//保存要提交的网址，此值从URL变量传来
		public static var PDT_ID:String;	//保存作品的ID，此值从URL变量传来
		public static var USER_TYPE:String;	//保存用户类型，此值从URL变量传来
		public static var MOD_TYPE:String;	//保存对数据库进行操作的类型，此值从URL变量传来，可能的值见model.type.ModeType
		
		public static var IS_MODIFY:Boolean;	//保存当前对数据库到做的类型是否是添加，这个值是为了方便调用，因为每次判断Config.MOE_TYPE==mod太费事情
		public static var IS_USER:Boolean;		//保存当前用户是否是参赛用户，这个值是为了方便调用，因为每次判断Config.USER_TYPE==3太费时
		public static var IS_TEACHER:Boolean;	//保存当前用户是否是教师用户。
		
		public static const SEPARATOR:String = '[*]';
		
		public function ConfigProxy()
		{
			super(NAME, new URLVariables());
		}
		
		public function getConfig():void
		{
			Logger.TYPE = Logger.TRACE;
			Logger.TYPE = Logger.FIREBUG;
			var __param:Object = Application.application.parameters; 
			URL = __param.config;
			USER_TYPE = __param.user_type;
			PDT_ID = __param.pdt_id;
			MOD_TYPE = __param.mod_type;
			
			IS_MODIFY = (MOD_TYPE == ModeType.MODIFY);
			IS_USER = (USER_TYPE == UserType.USER);
			//====================调试信息
			//IS_MODIFY = false;
			//URL = '../assets/get_info.xml';
			//URL = '/noc_source/zpsc/zp_upload_deal_all.php?mod_step=step_get_info';
			USER_TYPE = '99';
			PDT_ID = '2';
			//=====================
			
			buildUrlGetInfoVar();
			
			Logger.debug('url:{0}',data);
			sendNotification(ApplicationFacade.RPC_STEP_GET_CONFIG_DONE);
		}
		
		private function buildUrlGetInfoVar():void
		{
			data[StepType.RPC_STEP_NAME] = StepType.RPC_STEP_GET_INFO;
			data.pdt_id = PDT_ID;
			data.mod_type = MOD_TYPE;
		}
		
		/**
		 * 自动把传来的字节转成MB或者KB
		 * */
		public static function toByteName($byte:int):String
		{
			Logger.debug('toByName执行,$byte:{1}',$byte);
			var __name:String;
			var __num:Number;
			if($byte < 1048576)
			{
				__name = 'KB';
				__num = $byte/1024;
			}
			else
			{
				__name = 'MB';
				__num = $byte/1048576;
			}
			return Math.floor(__num*10)/10+__name;
		}
		
		public static  function toByteNum($mb:Number):int
		{
			return $mb*1048576;
		}
	}
}