package view
{
	import model.ConfigProxy;
	import model.GetInfoProxy;
	import model.vo.StepHelppingTeacherVO;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepHelppingTeacher;
	import view.interfaces.IStepBuildSub;
	import view.sub.HelppingTeacherMediator;
	import view.sub.component.HelppingTeacher;

	public class StepHelppingTeacherMediator extends Mediator implements IStepBuildSub
	{
		public static const NAME:String = 'StepHelppingTeacherMediator';
		private var _mediatorNameList:Array = [];
		private var _data:XML;
		private var _list:XMLList;
		
		public function StepHelppingTeacherMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_data = (facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy).getData() as XML;
			if(ConfigProxy.IS_MODIFY)
			{
				_list = _data.mod_content.pdt_teacher.item;
			}
		}
		
		private function get _view():StepHelppingTeacher
		{
			return viewComponent as StepHelppingTeacher;
		}
		
		public function buildSub($num:int):void
		{
			Logger.info('StepHelppingTeacherMediator.buildSub执行 ');
			_mediatorNameList = new Array();	//清空原来的辅导教师数组
			cat.helppingTeacherTile.removeAllChildren();	//移除当前辅导教师容器中的所有辅导教师
			if($tnum > 0)
			//如果数量大于0，就按照数量在容器中建立辅导教师
			{
				for(var j:int=0; j< $num; j++)
				{
					var __helppingTeacher:HelppingTeacher = new HelppingTeacher();
					__helppingTeacher.label = '辅导教师'+(j+1);
					_view.addChild(__helppingTeacher);	//把建立的辅导教师加入显示列表
					var __mediator:HelppingTeacherMediator = new HelppingTeacherMediator(j, __helppingTeacher);
					if(ConfigProxy.IS_MODIFY)
					{
						//修改信息的时候，必须有提交过的辅导教师信息，才允许填充
						if(_list.length() > 0)
						{
							var __info:XML = _list[j] as XML;
							if(__info != null)
							{
								__mediator.setVariable(__info);
							}
						}
					}
					facade.registerMediator(__mediator);
					_mediatorNameList.push(__mediator.getMediatorName());		//把建立的辅导教师的Mediator名称加入数组，以便于移除辅导教师的时候解除注册
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
			Logger.info('StepHelppingTeacherMediator.buildVariable调用,_mediatorNameList.length:{0}', _mediatorNameList.length);
			_sendVO();
		}
		
		private function _sendVO():void
		{
			var __vo:StepHelppingTeacherVO = new StepHelppingTeacherVO();
			var __arr:Array = new Array();
			for each(var i:String in _mediatorNameList)
			{
				var __mediator:ICopartner = facade.retrieveMediator(i);
				__arr.push(__mediator.getVariable());
			}
			__vo.pdt_teacher = __arr.join(ConfigProxy.SEPARATOR);			
			sendNotification(ApplicationFacade.VAR_UPDATE, __vo);
		}		
	}
}