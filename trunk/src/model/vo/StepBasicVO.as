package model.vo
{
	import model.enum.VarEnum;
	
	public class StepBasicVO implements IVariables
	{
		public var pdt_author:String;
		public var pdt_author_nation:String;
		public var pdt_author_sex:String;
		public var pdt_author_age:Number;
		public var pdt_area:String;
		public var pdt_author_email:String;
		public var pdt_author_phone:String;
		public var pdt_author_mobphone:String;
		public var pdt_author_zip:String;
		public var pdt_school:String;
		public var pdt_author_address:String;
		
		public function StepBasicVO()
		{
		}
		
		public function get data():Array
		{
			return [	new VarEnum('pdt_author', pdt_author),
						new VarEnum('pdt_author_nation', pdt_author_nation),
						new VarEnum('pdt_author_sex', pdt_author_sex),
						new VarEnum('pdt_author_age', pdt_author_age),
						new VarEnum('pdt_area', pdt_area),
						new VarEnum('pdt_author_email', pdt_author_email),
						new VarEnum('pdt_author_phone', pdt_author_phone),
						new VarEnum('pdt_author_mobphone', pdt_author_mobphone),
						new VarEnum('pdt_author_zip', pdt_author_zip),
						new VarEnum('pdt_school', pdt_school),
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