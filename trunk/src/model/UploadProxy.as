package model
{
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class UploadProxy extends Proxy
	{
		public static const NAME:String = 'UploadProxy'
		public function UploadProxy(data:Object=null)
		{
			super(NAME, new Array());
		}
		
	}
}