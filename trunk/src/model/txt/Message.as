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
		
		public static const LABEL_STEP_COPARTNER:String = "<font size='14' color='#ff0000'><b>第三步：合作者</b></font>";
		
		public static const LABEL_STEP_HELPPINGTEACHER:String = "<font size='14' color='#ff0000'><b>第四步：辅导教师</b></font>";
		public static const LABEL_STEP_IDEA:String = "<font size='14' color='#ff0000'><b>第五步：创作思想</b></font><br>解释作品创作的背景、目的和意义列、列明哪些部分属自己原创";
		public static const LABEL_STEP_PROCESS:String = "<font size='14' color='#ff0000'><b>第六步：创作过程</b></font><br>解释运用了哪些技术或技巧完成主题创作";
		public static const LABEL_STEP_LITERATURE:String = "<font size='14' color='#ff0000'><b>第七步：参考资源</b></font><br>详细列明参考或引用他人资源的出处";
		
		public static const LABEL_STEP_INTRODUCE:String = "<font size='14' color='#ff0000'><b>第四步：作品概要</b></font>";
		public static const LABEL_STEP_REMARK:String = "<font size='14' color='#ff0000'><b>第五步：备注</b><br>若作品联系人不是作者本人，可在此注明联系人的通讯方式</font>";;
		
		public static const LABEL_STEP_UPLOAD_TEACHER:String = "<font size='14' color='#ff0000'><b>第六步:上传文件（完成）</b>";
		public static const LABEL_STEP_UPLOAD_STUDENT:String = "<font size='14' color='#ff0000'><b>第八步:上传文件（完成）</b>";;
		
		public function Message()
		{
			throw new Error('不能建立实例！');
		}

	}
}