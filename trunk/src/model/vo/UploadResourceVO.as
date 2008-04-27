/**
 * 保存一个要上传的文件信息，包括的引用和这次文件上传需要带上的变量
 * */
package model.vo
{
	import flash.net.FileReference;
	
	public class UploadResourceVO
	{
		public var file:FileReference;	//要上传的文件对象
		public var id:String;			//上传的文件的id,uploadItem.@id
		public var index:String;		//上传文件的index,uploadItem.index
		
		public function UploadResourceVO($file:FileReference, $id:String=null, $index:String=null)
		{
			file = $file;
			id = $id;
			index = $index;
		}
	}
}