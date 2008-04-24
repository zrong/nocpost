package view.sub
{
	import model.GetInfoProxy;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.interfaces.ICopartner;
	import view.sub.component.CopartnerComplex;
	import view.sub.component.UploadResource;

	public class CopartnerComplexMediator extends Mediator implements ICopartner
	{
		public static const NAME:String = 'CopartnerComplexMediator';
		
		private var _getInfoProxy:GetInfoProxy;
		private var _nationList:XMLList;
		private var _copartnerInfo:XML;
		private var _copartnerID:String = '';
		
		public function CopartnerSimpleMediator($name:String, viewComponent:Object=null)
		{
			super($name, viewComponent);
			_getInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			_nationList = (_getInfoProxy.getData() as XML).nation.item;
			copartner.nationCB.dataProvider = _nationList;
		}
		
		private function get copartner():CopartnerComplex
		{
			return viewComponent as CopartnerComplex;
		}
		
		public function get uploadResource():UploadResource
		{
			
		}
		
		public function set index($index:int):void
		{
			copartner.uploadItem.index = $index;
		}
		
		public function getVariable():String
		{
			copartner.validate();
			var __arr:Array = new Array();
			__arr.push(_copartnerID);
			__arr.push(copartner.nameTI.text);
			__arr.push(copartner.emailTI.text);
			__arr.push(copartner.phoneTI.text);
			__arr.push(copartner.sexRBG.selectedValue);
			__arr.push(copartner.(nationCB.selectedIndex==-1)?'':copartner.nationCB.selectedItem.@id);
			__arr.push(copartner.mobileTI.text);
			__arr.push(copartner.ageNS.value);
			return __arr.join(',');
		}
		
		public function setVariable($xml:XML):void
		{
			Logger.info('setVariable执行：\n{1}', $xml);
			_copartnerInfo = $xml;
			_copartnerID = _copartnerInfo.@id;
			copartner.nameTI.text = _copartnerInfo.name;
			copartner.emailTI.text = _copartnerInfo.email;
			copartner.phoneTI.text = _copartnerInfo.phone;
			copartner.mobileTI.text = _copartnerInfo.mobphone;
			copartner.sexRBG.selectedValue = _copartnerInfo.sex;
			copartner.ageNS.value = _copartnerInfo.age;
			copartner.nationCB.selectedIndex = _getNationIndex(_copartnerInfo.nation);
		}
		
		/**
		 * 返回已经选择的nation的值在nation列表中的索引值
		 * */
		private function _getNationIndex($id:String):int
		{
			for(var i:int=0; i<nationList.length(); i++)
			{
				if(nationList[i].@id == $id)
				{
					return i;
				}
			}
			return -1;
		}
	
	}
}