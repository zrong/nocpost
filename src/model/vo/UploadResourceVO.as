/**
 * 保存一个要上传的文件信息，包括的引用和这次文件上传需要带上的变量
 * */
package model.vo
{
	import flash.net.FileReference;
	import flash.net.URLVariables;
	
	public class UploadResourceVO
	{
		public var file:FileReference;
		public var submitVar:URLVariables;
		
		public function UploadResourceVO($file:FileReference, $var:URLVariables)
		{
			file = $file;
			submitVar = $var;
		}
	}
}