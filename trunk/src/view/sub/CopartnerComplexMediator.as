package view.sub
{
	import model.GetInfoProxy;
	import model.vo.UploadResourceVO;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.interfaces.ICopartner;
	import view.sub.component.CopartnerComplex;

	public class CopartnerComplexMediator extends Mediator implements ICopartner
	{
		public static const NAME:String = 'CopartnerComplexMediator';
		
		private var _getInfoProxy:GetInfoProxy;
		private var _nationList:XMLList;
		private var _copartnerInfo:XML;
		private var _copartnerID:String = '';
		private var _photoMediator:UploadResourceMediator;
		private var _index:int;
		
		public function CopartnerSimpleMediator($index:int, viewComponent:Object=null)
		{
			super(NAME+$index.toString(), viewComponent);
			_getInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			_nationList = (_getInfoProxy.getData() as XML).nation.item;
			_view.nationCB.dataProvider = _nationList;
			_index = $index;
			_view.uploadItem.index = $index;
			_initPhoto();
		}
		
		private function _initPhoto():void
		{
			//photoMediator的名称用CopartnerComplexMediator的名称加上UploadResourceMediator的名称加上CopartnerComplexMediator的序号表示
			_photoMediator = new UploadResourceMediator(NAME+UploadResourceMediator.NAME+_index, _view.photo);
			facade.registerMediator(_photoMediator);
		}
		
		private function get _view():CopartnerComplex
		{
			return viewComponent as CopartnerComplex;
		}
		
		public function getPhoto():UploadResourceVO
		{
			return _photoMediator.getUpload();
		}
		
		public function getVariable():String
		{
			_view.validate();
			var __arr:Array = new Array();
			__arr.push(_copartnerID);
			__arr.push(_view.nameTI.text);
			__arr.push(_view.emailTI.text);
			__arr.push(_view.phoneTI.text);
			__arr.push(_view.sexRBG.selectedValue);
			__arr.push(_view.(nationCB.selectedIndex==-1)?'':_view.nationCB.selectedItem.@id);
			__arr.push(_view.mobileTI.text);
			__arr.push(_view.ageNS.value);
			return __arr.join(',');
		}
		
		public function setVariable($xml:XML):void
		{
			Logger.info('setVariable执行：\n{1}', $xml);
			_copartnerInfo = $xml;
			_copartnerID = _copartnerInfo.@id;
			_view.nameTI.text = _copartnerInfo.name;
			_view.emailTI.text = _copartnerInfo.email;
			_view.phoneTI.text = _copartnerInfo.phone;
			_view.mobileTI.text = _copartnerInfo.mobphone;
			_view.sexRBG.selectedValue = _copartnerInfo.sex;
			_view.ageNS.value = _copartnerInfo.age;
			_view.nationCB.selectedIndex = _getNationIndex(_copartnerInfo.nation);
		}
		
		public function removePhotoMediator():void
		{
			facade.removeMediator(_photoMediator.getMediatorName());
			_photoMediator = null;
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