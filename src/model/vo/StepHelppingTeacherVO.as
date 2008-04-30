package model.vo
{
	import model.enum.VarEnum;
	
	public class StepHelppingTeacherVO implements IVariables
	{
		public var pdt_teacher:String = null;
		
		public function get data():Array
		{
			return [	new VarEnum('pdt_teacher', pdt_teacher)	];
		}
		public function toString():String
		{
			var __str:String = '[StepHelppingTeacherVO]\r';
			for each(var i:VarEnum in data)
			{
				__str += i.toString()+ '\r';
			}
			return 	__str;
		}
	}
}