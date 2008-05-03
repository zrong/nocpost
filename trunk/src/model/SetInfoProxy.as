package model
{
	import flash.net.URLVariables;
	
	import model.dao.SetInfoDelegate;
	import model.enum.VarEnum;
	import model.type.ErrorType;
	import model.type.ModeType;
	import model.type.StepType;
	import model.vo.IVariables;
	import model.vo.SetPBVO;
	
	import mx.rpc.IResponder;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class SetInfoProxy extends Proxy implements IResponder
	{
		public static const NAME:String = 'SetInfoProxy';
		private var _submitVar:URLVariables = new URLVariables();
		
		public function SetInfoProxy(data:Object=null)
		{
			super(NAME, new XML());
		}
				
		public function setInfo():void
		{
			_submitVar[StepType.RPC_STEP_NAME] = StepType.RPC_STEP_SET_INFO;
			_submitVar[ModeType.MODE_NAME] = ConfigProxy.MOD_TYPE;
			_submitVar.pdt_id = ConfigProxy.PDT_ID;
			
			var __delegate:SetInfoDelegate = new SetInfoDelegate(this);
			try
			{
				__delegate.setInfo(ConfigProxy.URL, _submitVar);
				var __vo:SetPBVO = new SetPBVO(true, '提交数据到服务器', '提交数据到服务器，请稍候...');
				sendNotification(ApplicationFacade.SET_PROGRESS_BAR, __vo);
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
			//Logger.debug(($var as Object).);
			for each(var i:VarEnum in $var.data)
			{
				if(i.value != null)
				{
					_submitVar[i.name] = i.value;
				}
			}
			Logger.debug('要提交的变量：{0}' , _submitVar);
		}
		
		public function result($data:Object):void
		{
			try
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
					sendNotification(ApplicationFacade.UPLOAD_FILE_SUBMIT);
				}
			}
			catch(err:Error)
			{
				sendNotification(ApplicationFacade.ERROR, err.message+'\r'+err.getStackTrace(), ErrorType.ALERT);
			}			
		}
		
		public function fault($info:Object):void
		{
			Logger.info('_http提交失败！\n{0}\n错误id：{1}\n错误信息：{2}', $info.fault, $info.messageId, $info.message);
			sendNotification(ApplicationFacade.ERROR, '提交数据失败，请重新提交。', ErrorType.ALERT);
			_removeSubmitPanel();
		}
		
		private function _removeSubmitPanel():void
		{
			sendNotification(ApplicationFacade.SUBMIT_PANEL_REMOVE);
		}
		
	}
}