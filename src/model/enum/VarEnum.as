package model.enum
{
	public class VarEnum
	{
		public var name:String;
		public var value:*;
		
		public function VarEnum($name:String=null, $value:*=null)
		{
			name = $name;
			value = $value;
		}
		
		public function toString():String
		{
			return 	'[VarEnum]' + 
					'name=' + name +
					', '+
					'value=' + value;
		}

	}
}