package model
{
	import flash.net.URLVariables;
	
	import model.vo.IVariables;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class SetInfoProxy extends Proxy
	{
		public static const NAME:String = 'SetInfoProxy';
		
		public function SetInfoProxy(data:Object=null)
		{
			super(NAME, new URLVariables());
		}
		
		/**
		 * 将每一步中的vo数据更新到集成的变量中来
		 * */
		public function updateData($var:IVariables):void
		{
			for(var i:String in $var)
			{
				data[i] = $var[i];
			}
		}
		
	}
}