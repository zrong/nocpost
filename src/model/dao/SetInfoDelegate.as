/**
 * 数据获取部分，当mod_step为setp_get_info时（从PHP获取的值）
 * */
package model.dao
{
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class SetInfoDelegate
	{
		private var _responder:IResponder;
		private var _service:HTTPService;
		
		public function SetInfoDelegate($responer:IResponder)
		{
			_service = new HTTPService();
			_service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			_service.method = URLRequestMethod.POST;
			_responder = $responer;
		}
		
		public function setInfo($url:String, $param:URLVariables=null):void
		{			
			_service.url = $url;
			var __token:AsyncToken = _service.send($param); 
			__token.addResponder(_responder);
		}

	}
}