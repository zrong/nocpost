package view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepCopartnerComplex;
	import view.interfaces.IStepBuildSub;
	import view.sub.CopartnerComplexMediator;
	import view.sub.component.CopartnerComplex;

	public class StepCopartnerComplexMediator extends Mediator implements IStepBuildSub
	{
		public static const NAME:String = 'StepCopartnerComplexMediator';
		private var _mediatorNameList:Array = [];
		
		public function StepCopartnerComplexMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
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
			if($cnum > 0)
			{			
				for(var i:int=0; i< $cnum; i++)
				{
					//是否显示详细信息，生成的填写合作者信息的表单是不同的
					var __copartner:CopartnerComplex = new CopartnerComplex();
					var __mediatorName:String = CopartnerComplexMediator.NAME + i.toString();
					var __copartnerMediator:CopartnerComplexMediator = new CopartnerComplexMediator(__mediatorName, __copartner);
					__copartnerMediator.index = i;
					__copartner.label = '合作者'+(i+1);
					_view.addChild(__copartner);
					facade.registerMediator(__copartnerMediator);
					_mediatorNameList.push(__mediatorName);
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
			Logger.info('_buildCopartnerStrinForSubmit调用,_copartnerArray.length:{0}', _copartnerArray.length);

			var __arr:Array = new Array();
			var __photoArr:Array = new Array();
			for each(var i:String in _mediatorNameList)
			{
				var __mediator:ICopartner = facade.retrieveMediator(i);
				__arr.push(__mediator.getVariable());
				//__photoArr.push((__mediator as CopartnerComplexMediator).photoUW as UploadResource);
			}
			if(ConfigProxy.IS_NEED_COPARTNER_INFO)
			{
				//如果处于“网络教研团队”类型，就将要上传的文件填充到UploadProxy中，并指名是第二步中填充的
				sendNotification(ApplicationFacade.UPLOAD_FILE_FILLED, __photoArr, StepType.RPC_STEP_PHOTO);
			}
			return __arr.join(ConfigProxy.SEPARATOR);
		}
	}
}