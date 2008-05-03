package view.sub
{
	import model.GetInfoProxy;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.interfaces.ICopartner;
	import view.sub.component.HelppingTeacher;

	public class HelppingTeacherMediator extends Mediator implements ICopartner
	{
		public static const NAME:String = 'HelppingTeacherMediator';

		private var _getInfoProxy:GetInfoProxy;
		private var _nationList:XMLList;
		private var _helppingTeacherInfo:XML;
		//辅导教师ID，仅当修改的时候有值
		public var helppingTeacherID:String = '';
		private var _isRequired:Boolean = false;
		
		public function HelppingTeacherMediator($index:int, viewComponent:Object=null)
		{
			super(NAME + $index.toString(), viewComponent);
			_getInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			_nationList = (_getInfoProxy.getData() as XML).nation.item;
			_view.nationCB.dataProvider = _nationList;
			if($index == 0)
			//只有第一个辅导教师才是必需的
			{
				_isRequired = true;
			}
		}
		
		private function get _view():HelppingTeacher
		{
			return viewComponent as HelppingTeacher;
		}
				
		public function getVariable():String
		{
			Logger.debug('HelppingTeacherMediator.getVariable执行, isRequired:{0}',_isRequired); 
			if(_isRequired)
			//如果需要检查辅导教师的信息才进行检查
			{
				_view.validate();
			}
			var __arr:Array = new Array();
			__arr.push(helppingTeacherID);
			__arr.push(_view.nameTI.text);
			__arr.push(_view.emailTI.text);
			__arr.push(_view.mobileTI.text);
			__arr.push(_view.sexRBG.selectedValue);
			__arr.push((_view.nationCB.selectedIndex==-1)?'':_view.nationCB.selectedItem.@id);
			return __arr.join(',');
		}
		
		public function setVariable($xml:XML):void
		{
			Logger.info('setVariable执行：\n{1}', $xml);
			_helppingTeacherInfo = $xml;
			helppingTeacherID = _helppingTeacherInfo.@id;
			_view.nameTI.text = _helppingTeacherInfo.name;
			_view.emailTI.text = _helppingTeacherInfo.email;
			_view.mobileTI.text = _helppingTeacherInfo.phone;
			_view.sexRBG.selectedValue = _helppingTeacherInfo.sex;
			_view.nationCB.selectedIndex = _getNationIndex(_helppingTeacherInfo.nation);
		}
		
		/**
		 * 返回已经选择的nation的值在nation列表中的索引值
		 * */
		private function _getNationIndex($id:String):int
		{
			for(var i:int=0; i<_nationList.length(); i++)
			{
				if(_nationList[i].@id == $id)
				{
					return i;
				}
			}
			return -1;
		}
	}
}