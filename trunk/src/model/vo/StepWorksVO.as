package model.vo
{
	import model.enum.VarEnum;
	
	public class StepWorksVO implements IVariables
	{
		public var pdt_name:String;
		public var pdt_kind:String;
		public var pdt_group:String;
		public var pdt_author_grade:Number;
		public var pdt_subject:String;
		public var pdt_book_edition:String;
		public var pdt_module_type:String;
		public var pdt_author_address:String;
		
		public function get data():Array
		{
			return [	new VarEnum('pdt_name', pdt_name),
						new VarEnum('pdt_kind', pdt_kind),
						new VarEnum('pdt_group', pdt_group),
						new VarEnum('pdt_author_grade', pdt_author_grade),
						new VarEnum('pdt_subject', pdt_subject),
						new VarEnum('pdt_book_edition', pdt_book_edition),
						new VarEnum('pdt_module_type', pdt_module_type),
						new VarEnum('pdt_author_address', pdt_author_address)	];
		}
		
		public function toString():String
		{
			var __str:String = '[StepBasicVO]\r';
			for each(var i:VarEnum in data)
			{
				__str += i.toString()+ '\r';
			}
			return 	__str;
		}
	}
}