package model
{
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class GetInfoProxy extends Proxy implements IResponder
	{
		public static const NAME:String = 'GetInfoProxy';
		
		public function GetInfoProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
		}
		
		public function result(data:Object):void
		{
		}
		
		public function fault(info:Object):void
		{
		}
		
	}
}