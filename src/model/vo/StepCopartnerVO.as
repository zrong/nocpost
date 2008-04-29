package model.vo
{
	import model.enum.VarEnum;
	
	public class StepCopartnerVO implements IVariables
	{
		public var pdt_author_other_info:String = null;
		public var pdt_author_other:String = null;
		
		public function get data():Array
		{
			var __enum:VarEnum = new VarEnum();
			var __arr:Array = [];
			if(pdt_author_other != null)
			{
				__enum.name = 'pdt_author_other';
				__enum.value = pdt_author_other;
				__arr.push(__enum);
			}
			if(pdt_author_other_info != null)
			{
				__enum.name = 'pdt_author_other_info';
				__enum.value = pdt_author_other_info;
				__arr.push(__enum);
			}
			return __arr;
		}
		
		public function toString():String
		{
			var __str:String = '[StepCopartnerVO]\r';
			for each(var i:VarEnum in data)
			{
				__str += i.toString()+ '\r';
			}
			return 	__str;
		}
	}
}