package view
{
	import flash.events.Event;
	
	import model.ConfigProxy;
	import model.GetInfoProxy;
	import model.type.*;
	import model.vo.StepBasicVO;
	
	import mx.utils.StringUtil;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepBasic;
	import view.interfaces.IStep;

	public class StepBasicMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepBasicMediator';
		
		private var _data:XML;
		private var _getInfoProxy:GetInfoProxy;
		
		public function StepBasicMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_getInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;			
			_view.addEventListener(StepBasic.DEBUG_FILL, _debugFill);
		}
		
		private function get _view():StepBasic
		{
			return viewComponent as StepBasic;
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
					_update();
					break;
			}
		}
		
		public function buildVariable():void
		{
			Logger.info('StepBasicMediator.buildVariable执行');	
			_view.validate();
			_sendVO();					
		}
		
		private function _update():void
		{
			Logger.debug('StepBasicMediator.update执行！');
			_data = _getInfoProxy.getData() as XML;
			//Logger.debug('ConfigProxy.IS_MODIFY:{0}', ConfigProxy.IS_MODIFY);
			if(ConfigProxy.IS_MODIFY)
			{
				Logger.info('执行修改');
				_fillForHasValue(!ConfigProxy.IS_USER)				
			}
			else
			{
				if(ConfigProxy.IS_USER)
				{
					Logger.info('执行用户提交');
					_fillForHasValue(false);
				}
				else
				{
					Logger.info('执行管理员提交');
					//gameCodeLabel.text
					//nameTI.text
					_view.nationCB.dataProvider = _data.nation.item;
					//nationCB.selectedIndex
					//maleRB.selected
					//femaleRB.selected
					//sexRBG.enabled
					_view.areaCB.dataProvider = _data.province.item;
					//ageNS.value
					//emailTI.text
					//zipTI.text
					//zoneTI
					//phoneTI
					//mobileTI
					//schoolTI
					//addressTI
				}
			}
		}
		
		/**
		 * 提供界面数据
		 * $isAdmin 是普通用户还是管理员
		 * */
		private function _fillForHasValue($isAdmin:Boolean):void
		{
			Logger.debug('StepBasicMediator._fillForHasValue执行');
			var __modify:XML = _data.mod_content[0] as XML;
			Logger.debug('modify:{0}', __modify);
			_view.gameCodeLabel.text = __modify.game_code;
			_view.nameTI.text = __modify.pdt_author;
			_view.nameTI.enabled = $isAdmin;
			_view.nationCB.dataProvider = _data.nation.item.(@id==__modify.pdt_author_nation);
			_view.nationCB.enabled = false;
			_view.nationCB.selectedIndex = 0;
			_view.sexRBG.selectedValue = __modify.pdt_author_sex;
			_view.sexRBG.enabled = $isAdmin;
			_view.areaCB.dataProvider = _data.province.item.(@id==__modify.pdt_area);
			_view.areaCB.selectedIndex = 0;
			_view.areaCB.enabled = false;		
			_view.ageNS.value = __modify.pdt_author_age;
			_view.emailTI.text = __modify.pdt_author_email;
			_view.emailTI.enabled = $isAdmin;
			_view.zipTI.text = __modify.pdt_author_zip;
			_view.zoneTI.text = __modify.pdt_author_phone.split('-')[0];
			_view.zoneTI.enabled = $isAdmin;
			_view.phoneTI.text = __modify.pdt_author_phone.split('-')[1];
			_view.phoneTI.enabled = $isAdmin;
			_view.mobileTI.text = __modify.pdt_author_mobphone;
			_view.mobileTI.enabled = $isAdmin;
			_view.schoolTI.text = __modify.pdt_school;
			_view.schoolTI.enabled = $isAdmin;
			_view.addressTI.text = __modify.pdt_author_address;
		}
		
		private function _sendVO():void
		{
			var __basicVO:StepBasicVO = new StepBasicVO();
			__basicVO.pdt_author = StringUtil.trim(_view.nameTI.text);
			__basicVO.pdt_author_nation = _view.nationCB.selectedItem.@id;
			__basicVO.pdt_author_sex = _view.sexRBG.selectedValue.toString();
			__basicVO.pdt_author_age = _view.ageNS.value;
			__basicVO.pdt_area = _view.areaCB.selectedItem.@id;
			__basicVO.pdt_author_email = _view.emailTI.text; 
			__basicVO.pdt_author_phone = _view.zoneTI.text + '-' + _view.phoneTI.text;
			__basicVO.pdt_author_mobphone = _view.mobileTI.text;
			__basicVO.pdt_author_zip = _view.zipTI.text;
			__basicVO.pdt_school = _view.schoolTI.text;
			__basicVO.pdt_author_address = _view.addressTI.text;
			
			sendNotification(ApplicationFacade.VAR_UPDATE, __basicVO);
		}
		
		//=================================================
		private function _debugFill(evt:Event):void
		{
			_view.nameTI.text = '用户'+Math.floor(Math.random()*1000).toString();
			_view.nationCB.selectedIndex = 0;
			_view.maleRB.selected = true;
			_view.ageNS.value = 10;
			_view.areaCB.selectedIndex = 0;
			_view.emailTI.text = 'zrongzrong@gmail.com';
			_view.zoneTI.text = Math.floor(Math.random()*10000).toString();
			_view.phoneTI.text = Math.floor(Math.random()*100000000).toString();
			_view.mobileTI.text = Math.floor(Math.random()*1000000000000).toString();
			_view.zipTI.text = Math.floor(Math.random()*1000000).toString();
			_view.schoolTI.text = 'abcdefghijklmnopqrstuvwxyz';
			_view.addressTI.text = 'abcdefghijklmnopqrstuvwxyz';
		}
		/*
		private function debugDelFlash():void
		{
			var __var:Array = _view.delFlashTI.text.split(',');
			ExternalInterface.call(__var[0], __var[1]);
		}
		*/			
		//==========================
	}
}