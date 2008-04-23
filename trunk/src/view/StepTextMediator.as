package view
{
	import flash.events.Event;
	
	import model.GetInfoProxy;
	import model.type.TextVarNameType;
	import model.vo.StepTextVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepText;
	import view.interfaces.IStep;

	public class StepTextMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepTextMediator';
		
		private var _data:XML;
		private var _getInfoProxy:GetInfoProxy;
		
		public function StepTextMediator($name:String, viewComponent:Object=null)
		{
			super($name, viewComponent);
			_getInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			
			stepText.addEventListener(StepText.DEBUG_FILL, _debugFill);
		}
		
		private function get stepText():StepText
		{
			return viewComponent as StepText;
		}
		
		override public function listNotificationInterests():Array
		{
			return [	ApplicationFacade.RPC_STEP_GET_INFO_DONE	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RPC_STEP_GET_INFO_DONE:
					_data = _getInfoProxy.getData() as XML;
					_update();
					break;
			}
		}
			
		private function _update():void
		{
			var __modify:XML = XML(_data.mod_content[0]);
			//Logger.info('StepText.{1}的__modify：{2}', varName, __modify);
			if(ConfigProxy.IS_MODIFY)
			{
				textTA.text = __modify[stepText.varName];
			}
			else
			{
				if(Config.IS_USER)
				{
					textTA.text = __modify[stepText.varName];
				}
				else
				{
					//textTA.text = '';
				}
			}
		}
		
		public function buildVariable():void
		{
			if(stepText.isRequired)
			{
				stepText.validate();
				_sendVO();
			}
		}
		
		private function _sendVO():void
		{
			var __vo:StepTextVO = new StepTextVO();
			switch(stepText.name)
			{
				case TextVarNameType.IDEA:
					__vo.pdt_idea = stepText.textTA.text;
					break;
				case TextVarNameType.INTRODUCE:
					__vo.pdt_introduce = stepText.textTA.text;
					break;
				case TextVarNameType.LITERATURE:
					__vo.pdt_literature = stepText.textTA.text;
					break;
				case TextVarNameType.PROCESS:
					__vo.pdt_process = stepText.textTA.text;
					break;
				case TextVarNameType.REMARK:
					__vo.pdt_remark = stepText.textTA.text;
					break;
			}
			sendNotification(ApplicationFacade.VAR_UPDATE, __vo);
		}
		
		//==========================
		private function _debugFill(evt:Event):void
		{
			for(var i:int = 0; i <= 3; i++)
			{
				stepText.textTA.text += '测试内容'+stepText.label;
			}
			
		}
		//==========================
		
	}
}