package utils
{
	import flash.net.URLVariables;
	
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;
	
	import net.zengrong.utils.Logger;
	[Bindable]
	public final class Config
	{
		public static var CONFIG_DATA:XML;		//第一次获取（get_info）的时候保存在这个变量中
		public static var RESULT_DATA:XML;	//数据提交后返回的信息保存在这个变量中
		public static var SUBMIT_VAR:URLVariables = new URLVariables();	//要提交的变量
		public static var UPLOAD_FILES:Array = new Array();	//要上传的文件对象数组
		public static var UPLOAD_COPARTNER_PHOTO:Array = new Array();	//合作者的照片数组，仅当需要合作者详细信息的时候，这个数组才有用
		public static var IS_NEED_COPARTNER_INFO:Boolean;	//是否需要详细的合作者信息
		
		public static var URL:String;	//保存要提交的网址，此值从URL变量传来
		public static var PDT_ID:String;	//保存作品的ID，此值从URL变量传来
		public static var USER_TYPE:String;	//保存用户类型，此值从URL变量传来
		public static var MOD_TYPE:String;	//保存对数据库进行操作的类型，此值从URL变量传来，可能的值见utils.type.ModeType
		
		public static var IS_MODIFY:Boolean;	//保存当前对数据库到做的类型是否是添加，这个值是为了方便调用，因为每次判断Config.MOE_TYPE==mod太费事情
		public static var IS_USER:Boolean;		//保存当前用户是否是参赛用户，这个值是为了方便调用，因为每次判断Config.USER_TYPE==3太费时
		
		public static const SEPARATOR:String = '[*]';
		//public static var SUBMIT_HTTP:HTTPService = new HTTPService();
		
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
		
		public static function validate($valid:Array, $error:String='带星号的项目为必填项'):Boolean
		{
			Logger.info("Config.validate执行,$valid.length:{1}", $valid.length);
			var __validatorResults:Array = Validator.validateAll($valid);
			Logger.info("__validatorResults.length:{1}", __validatorResults.length);
			if(__validatorResults.length > 0){
				//将光标定位到第一个错误
				var __v:ValidationResultEvent = __validatorResults[0] as ValidationResultEvent;
				//Logger.info('__v.results：{1}', __v.results);
				if(__v.target != null)
				{
					var __t:UIComponent = __v.target.source as UIComponent;
					//Logger.info('__t:{1}', __t);
					if(__t == null)
					//如果__t获取失败（例如__t是RadioButtonGroup类，不属于UIComponent，因此__t的值会变成null），就获取Validator的listener
					{
						//这是的__t其实是maleRB
						__t = (__v.target as Validator).listener as UIComponent;
					}
					__t.setFocus();
					Logger.debug('检测字段：\n{1}', __t.id);
					throw new Error(__t.name+' 填写有误：'+__v.message);
				}				
				return false;
			}
			return true;
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
		
		public static function toByteNum($mb:Number):int
		{
			return $mb*1048576;
		}
		
		public static function getProjectXML($info:XML):XML
		{
			var __project:XML = $info.project.item.(@id==$info.mod_content.pdt_kind)[0] as XML;
			//根据修改信息中提供的项目id值获取当前用户选择的项目值
		 	Config.IS_NEED_COPARTNER_INFO = (__project.author_need_info == '1');
		 	return __project;
		}
	}
}