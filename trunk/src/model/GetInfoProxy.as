package model
{
	import model.dao.GetInfoDelegate;
	
	import mx.rpc.IResponder;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class GetInfoProxy extends Proxy implements IResponder
	{
		public static const NAME:String = 'GetInfoProxy';
		
		public function GetInfoProxy(data:Object=null)
		{
			super(NAME, new XML());
		}
		
		public function getInfo():void
		{
			var __delegate:GetInfoDelegate = new GetInfoDelegate(this);
			try
			{
				__delegate.getInfo(ConfigProxy.URL, ConfigProxy.URL_GET_INFO_VAR);
			}
			catch(err:Error)
			{
				sendNotification(ApplicationFacade.RPC_STEP_GET_INFO_ERROR, err.toString());
			}
		}
		
		public function result($data:Object):void
		{
			Logger.info('HTTP提交返回成功');
			data = $data.result as XML;
			//Logger.info(data.province);
			sendNotification(ApplicationFacade.RPC_STEP_GET_INFO_DONE);
		}
		
		public function fault($info:Object):void
		{
			Logger.info('HTTP提交返回失败：\n{0}\n{1}{2}',$info.fault.getStackTrace(), $info.messageId, $info.message);
			sendNotification(ApplicationFacade.ERROR, $info.fault.message+"\n"+$info.message.toString());
		}
		
	}
}