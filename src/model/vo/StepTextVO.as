package model.vo
{
	import model.enum.VarEnum;
	
	public class StepTextVO implements IVariables
	{
		public var pdt_introduce:String = null;
		public var pdt_remark:String = null;
		public var pdt_idea:String = null;
		public var pdt_process:String = null;
		public var pdt_literature:String = null;
		
		public function get data():Array
		{
			return [	new VarEnum('pdt_introduce', pdt_introduce),
						new VarEnum('pdt_remark', pdt_remark),
						new VarEnum('pdt_idea', pdt_idea),
						new VarEnum('pdt_process', pdt_process),
						new VarEnum('pdt_literature', pdt_literature)	];
		}
		public function toString():String
		{
			var __str:String = '[StepTextVO]\r';
			for each(var i:VarEnum in data)
			{
				__str += i.toString()+ '\r';
			}
			return 	__str;
		}
	}
	
	
}