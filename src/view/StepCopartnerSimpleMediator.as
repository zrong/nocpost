package view
{
	import model.ConfigProxy;
	import model.GetInfoProxy;
	import model.vo.StepCopartnerVO;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepCopartnerSimple;
	import view.interfaces.ICopartner;
	import view.interfaces.IStepBuildSub;
	import view.sub.CopartnerSimpleMediator;
	import view.sub.component.CopartnerSimple;

	public class StepCopartnerSimpleMediator extends Mediator implements IStepBuildSub
	{
		public static const NAME:String = 'StepCopartnerSimpleMediator';
		private var _mediatorNameList:Array = [];
		private var _data:XML;
		private var _list:XMLList;	//修改的时候提供的已有的信息列表
		
		public function StepCopartnerSimpleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_data = (facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy).getData() as XML;
			if(ConfigProxy.IS_MODIFY)
			{
				_list = _data.mod_content.pdt_author_other_info.item;
			}
		}
		
		public function get _view():StepCopartnerSimple
		{
			return viewComponent as StepCopartnerSimple;
		}
		
		public function buildSub($num:int):void
		{
			Logger.info('StepCopartnerSimpleMediator.buildSubView执行 ');
			//Logger.info('copartnerTile.height:{0},titleWidth:{1}', cat.copartnerTile.height, cat.copartnerTile.tileWidth);
			_mediatorNameList =  new Array();
			_view.removeAllChildren();
			if($num > 0)
			{			
				for(var i:int=0; i< $cnum; i++)
				{
					//是否显示详细信息，生成的填写合作者信息的表单是不同的
					var __copartner:CopartnerSimple = new CopartnerSimple();;
					__copartner.label = '合作者'+(i+1);
					_view.addChild(__copartner);
					var __mediator:CopartnerSimpleMediator = new CopartnerSimpleMediator(i, __copartner);;
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
				facade.removeMediator(_mediatorNameList.shift().toString());
			}
			_view.removeAllChildren();
		}
		
		public function buildVariable():void
		{
			Logger.info('StepCopartnerSimpleMediator.buildVariable调用,_mediatorNameList.length:{0}', _mediatorNameList.length);
			_sendVO();			
		}
		
		private function _sendVO():void
		{
			var __vo:StepCopartnerVO = new StepCopartnerVO();
			var __arr:Array = new Array();
			for each(var i:String in _mediatorNameList)
			{
				var __mediator:ICopartner = facade.retrieveMediator(i);
				__arr.push(__mediator.getVariable());
			}
			__vo.pdt_author_other = __arr.join(ConfigProxy.SEPARATOR);			
			sendNotification(ApplicationFacade.VAR_UPDATE, __vo);
		}
	}
}