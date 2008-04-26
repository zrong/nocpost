package model
{
	import flash.net.FileReference;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class UploadProxy extends Proxy
	{
		public static const NAME:String = 'UploadProxy'
		
		private var _photo:Array;	//第三步详细的参与者信息中的参与者照片（仅教师有）
		private var _file:Array;	//最后一步要上传的所有文件
		
		public function UploadProxy(data:Object=null)
		{
			super(NAME, new Array());
		}
		
		public function set uploadPhoto($photoArr:Array):void
		{
			_photo = $photoArr;
		}
		
		public function set uploadFile($fileArr:Array):void
		{
			_file = $fileArr;
		}
		
		public function addUpload($file:FileReference):void
		{
			(data as Array).push($file);
		}
		
	}
}