package model.txt
{
	[Bindable]
	public class Message
	{
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
		
		public function Message()
		{
			throw new Error('不能建立实例！');
		}

	}
}