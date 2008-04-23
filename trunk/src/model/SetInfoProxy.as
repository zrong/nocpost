package model
{
	import flash.net.URLVariables;
	
	import model.dao.SetInfoDelegate;
	import model.type.ErrorType;
	import model.type.StepType;
	import model.vo.IVariables;
	
	import mx.rpc.IResponder;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class SetInfoProxy extends Proxy implements IResponder
	{
		public static const NAME:String = 'SetInfoProxy';
		private var _submitVar:URLVariables = new URLVariables();
		
		public function SetInfoProxy(data:Object=null)
		{
			super(NAME, new XML();
		}
				
		public function setInfo():void
		{
			data[StepType.STEP_NAME] = StepType.STEP_SET_INFO;
			data[ModeType.MODE_NAME] = ConfigProxy.MOD_TYPE;
			data.pdt_id = ConfigProxy.PDT_ID;
			
			var __delegate:SetInfoDelegate = new SetInfoDelegate(this);
			try
			{
				__delegate.setInfo(ConfigProxy.URL, _submitVar);
				sendNotification(ApplicationFacade.VAR_SUBMIT_SET_PROGRESS_BAR,[true, '提交数据到服务器', '提交数据到服务器，请稍候...']);
			}
			catch(err:Error)
			{
				sendNotification(ApplicationFacade.ERROR, err.message, ErrorType.ALERT);
			}
		}
		
		/**
		 * 将每一步中的vo数据更新到集成的变量中来
		 * */
		public function updateData($var:IVariables):void
		{
			for(var i:String in $var)
			{
				if($var[i] != null)
				{
					_submitVar[i] = $var[i];
				}
			}
			Logger.debug('要提交的变量：{0}' , data);
		}
		
		public function result($data:Object):void
		{
			Logger.info('_http提交成功！\n{0}', $data.result);
			if($data.result.is_error=='true')
			{
				sendNotification(ApplicationFacade.ERROR, '提交数据失败，请重新提交。', ErrorType.ALERT);
				_removeSubmitPanel();
			}
			else
			//数据提交和写入都成功，进入上传文件流程
			{
				Logger.info('提交数据成功！准备开始上传流程。');
				data = $data.result as XML;
				_removeSubmitPanel();
				//sendNotification(ApplicationFacade.UPLOAD_FILE_SUBMIT);
			}
		}
		
		public function fault($info:Object):void
		{
			Logger.info('_http提交失败！\n{0}\n错误id：{1}\n错误信息：{2}', $info.fault, $info.messageId, $info.message);
			sendNotification(ApplicationFacade.ERROR, '提交数据失败，请重新提交。', ErrorType.ALERT);
			_removeSubmitPanel();
		}
		
		private _removeSubmitPanel():void
		{
			sendNotification(ApplicationFacade.SUBMIT_PANEL_REMOVE);
		}
		
	}
}