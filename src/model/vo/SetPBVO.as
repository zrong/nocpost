/**
 * 保存SubmitPanel中的SetPB函数的参数
 * */
package model.vo
{
	import flash.net.FileReference;
	
	public class SetPBVO
	{
		public function SetPBVO(	$indeterminate:Boolean=true,
									$title:String='',
									$pbLabel:String='',
									$mode:String='event',
									$source:FileReference=null				
								)
		{
			indeterminate = $indeterminate;
			title = $title;
			label = $pbLabel;
			mode = $mode;
			source = $source;
		}
		public var indeterminate:Boolean;
		public var title:String;
		public var label:String;
		public var mode:String;
		public var source:FileReference;		
	}
}