package utils
{
	import flash.external.ExternalInterface;
	
	import mx.core.Application;
	
	import net.zengrong.utils.Logger;
	
	public final class Output
	{
		public static function alert($str:String):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call('alert', $str);
			}
			else
			{
				Logger.debug($str);
			}
		}
		
		public static function close():void
		{
			Logger.info('执行Output.close()');
			if(ExternalInterface.available)
			{
				Logger.info('执行ExternalInterface.call');
				//ExternalInterface.call('window.close()');
				ExternalInterface.call('delFlash');
			}
			else
			//如果不能使用JavaScript代码，就直接卸载application的所有子显示对象
			{
				Application.application.removeAllChildren();
			}
		}
	}
}