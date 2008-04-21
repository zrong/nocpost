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
		
		public function HelppingTeacherMediator($name:String, viewComponent:Object=null)
		{
			super($name, viewComponent);
			_getInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			_nationList = (_getInfoProxy.getData() as XML).nation.item;
			ht.nationCB.dataProvider = _nationList;
		}
		
		private function get ht():HelppingTeacher
		{
			return viewComponent as HelppingTeacher;
		}
				
		public function getVariable():String
		{
			var __arr:Array = new Array();
			__arr.push(helppingTeacherID);
			__arr.push(ht.nameTI.text);
			__arr.push(ht.emailTI.text);
			__arr.push(ht.mobileTI.text);
			__arr.push(ht.sexRBG.selectedValue);
			__arr.push((ht.nationCB.selectedIndex==-1)?'':ht.nationCB.selectedItem.@id);
			return __arr.join(',');
		}
		
		public function setVariable($xml:XML):void
		{
			Logger.info('setVariable执行：\n{1}', $xml);
			_helppingTeacherInfo = $xml;
			helppingTeacherID = _helppingTeacherInfo.@id;
			ht.nameTI.text = _helppingTeacherInfo.name;
			ht.emailTI.text = _helppingTeacherInfo.email;
			ht.mobileTI.text = _helppingTeacherInfo.phone;
			ht.sexRBG.selectedValue = _helppingTeacherInfo.sex;
			ht.nationCB.selectedIndex = _getNationIndex(_helppingTeacherInfo.nation);
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