package view
{
	import model.ConfigProxy;
	import model.GetInfoProxy;
	import model.type.StepType;
	import model.vo.StepCopartnerVO;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepCopartnerComplex;
	import view.interfaces.IStepBuildSub;
	import view.sub.CopartnerComplexMediator;
	import view.sub.component.CopartnerComplex;

	public class StepCopartnerComplexMediator extends Mediator implements IStepBuildSub
	{
		public static const NAME:String = 'StepCopartnerComplexMediator';
		private var _mediatorNameList:Array = [];
		private var _data:XML;
		private var _list:XMLList;	//修改的时候提供的已有的信息列表
		
		public function StepCopartnerComplexMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_data = (facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy).getData() as XML;
			if(ConfigProxy.IS_MODIFY)
			{
				_list = _data.mod_content.pdt_author_other_info.item;
			}
		}
		
		private function get _view():StepCopartnerComplex
		{
			return viewComponent as StepCopartnerComplex;
		}
		
		public function buildSub($num:int):void
		{
			Logger.info('StepCopartnerComplexMediator.buildSub执行 ');
			_mediatorNameList = new Array();
			_view.removeAllChildren();
			if($num > 0)
			{			
				for(var i:int=0; i< $num; i++)
				{
					//是否显示详细信息，生成的填写合作者信息的表单是不同的
					var __copartner:CopartnerComplex = new CopartnerComplex();
					__copartner.label = '合作者'+(i+1);
					_view.addChild(__copartner);
					var __mediator:CopartnerComplexMediator = new CopartnerComplexMediator(i, __copartner);
					if(ConfigProxy.IS_MODIFY)
					{						
						__mediator.setVariable(_list[i]);
					}
					facade.registerMediator(__mediator);
					_mediatorNameList.push(__mediator.getMediatorName());
				}
			}
		}
		
		public function removeSub():void
		{			
			while(_mediatorNameList.length > 0)
			{
				var __name:String = _mediatorNameList.shift().toString();
				var __mediator:CopartnerComplexMediator = facade.retrieveMediator(__name) as CopartnerComplexMediator;
				//移除所有建立的详细参与者信息的mediator之前，先移除详细信息中的照片信息的mediator
				__mediator.removePhotoMediator();
				facade.removeMediator(__name);
			}
			_view.removeAllChildren();
		}
		
		public function buildVariable():void
		{
			Logger.info('StepCopartnerComplexMediator.buildVariable调用,_mediatorNameList.length:{0}', _mediatorNameList.length);
			_sendVO();
			_sendPhoto();
		}
		
		private function _sendVO():void
		{
			var __vo:StepCopartnerVO = new StepCopartnerVO();
			var __arr:Array = new Array();
			for each(var i:String in _mediatorNameList)
			{
				var __mediator:CopartnerComplexMediator = facade.retrieveMediator(i) as CopartnerComplexMediator;
				__arr.push(__mediator.getVariable());
			}
			__vo.pdt_author_other_info = __arr.join(ConfigProxy.SEPARATOR);			
			sendNotification(ApplicationFacade.VAR_UPDATE, __vo);
		}
		
		private function _sendPhoto():void
		{
			var __arr:Array = new Array();
			for each(var i:String in _mediatorNameList)
			{
				var __mediator:CopartnerComplexMediator = facade.retrieveMediator(i) as CopartnerComplexMediator;
				__arr.push(__mediator.getPhoto());
			}
			//将要上传的照片填充到UploadProxy中，并指名是第三步中填充的，是照片类型
			sendNotification(ApplicationFacade.UPLOAD_FILE_FILLED, __arr, StepType.RPC_STEP_PHOTO);
		}
	}
}