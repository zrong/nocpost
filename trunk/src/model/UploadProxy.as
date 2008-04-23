package model
{
	import flash.net.FileReference;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class UploadProxy extends Proxy
	{
		public static const NAME:String = 'UploadProxy'
		public function UploadProxy(data:Object=null)
		{
			super(NAME, new Array());
		}
		
		public function addUpload($file:FileReference):void
		{
			(data as Array).push($file);
		}
		
	}
}