package view
{
	import model.ConfigProxy;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepHelppingTeacher;
	import view.interfaces.IStepBuildSub;
	import view.sub.HelppingTeacherMediator;
	import view.sub.component.HelppingTeacher;

	public class StepHelppingTeacherMediator extends Mediator implements IStepBuildSub
	{
		public static const NAME:String = 'StepHelppingTeacherMediator';
		private var _mediatorNameList:Array = [];
		
		public function StepHelppingTeacherMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get _view():StepHelppingTeacher
		{
			return viewComponent as StepHelppingTeacher;
		}
		
		public function buildVariable():void
		{
			Logger.info('StepHelppingTeacherMediator.buildVariable调用,_mediatorNameList.length:{0}', _mediatorNameList.length);
			var __arr:Array = new Array();
			for each(var i:String in _mediatorNameList)
			{
				var __mediator:ICopartner = facade.retrieveMediator(i);
				__arr.push(__mediator.getVariable());
			}
			return __arr.join(ConfigProxy.SEPARATOR);
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
					var __id:String = (j+1).toString();
					var __mediatorName:String = HelppingTeacherMediator.NAME + __id;
					var __helppingTeacher:HelppingTeacher = new HelppingTeacher();
					__helppingTeacher.label = '辅导教师'+__id;
					_view.addChild(__helppingTeacher);	//把建立的辅导教师加入显示列表
					facade.registerMediator(new HelppingTeacherMediator(__mediatorName, __helppingTeacher));	//注册辅导教师的Mediator
					_mediatorNameList.push(__mediatorName);		//把建立的辅导教师的Mediator名称加入数组，以便于移除辅导教师的时候解除注册
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
		
	}
}