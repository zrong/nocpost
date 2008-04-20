package view
{
	import flash.events.Event;
	
	import model.ConfigProxy;
	import model.GetInfoProxy;
	import model.type.*;
	import model.vo.StepBasicVO;
	
	import mx.utils.StringUtil;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepBasic;
	import view.interfaces.IStep;

	public class StepBasicMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepBasicMediators';
		
		[Bindable] private var _data:XML;
		private var _getInfoProxy:GetInfoProxy;
		
		public function StepBasicMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_getInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			_data = _getInfoProxy.getData() as XML;
			
			stepBasic.addEventListener(StepBasic.DEBUG_FILL, _debugFill);
		}
		
		private function get stepBasic():StepBasic
		{
			return viewComponent as StepBasic;
		}
		
		//=================================================
		private function _debugFill(evt:Event):void
		{
			stepBasic.nameTI.text = '用户'+Math.floor(Math.random()*1000).toString();
			stepBasic.nationCB.selectedIndex = 0;
			stepBasic.maleRB.selected = true;
			stepBasic.ageNS.value = 10;
			stepBasic.areaCB.selectedIndex = 0;
			stepBasic.emailTI.text = 'zrongzrong@gmail.com';
			stepBasic.zoneTI.text = Math.floor(Math.random()*10000).toString();
			stepBasic.phoneTI.text = Math.floor(Math.random()*100000000).toString();
			stepBasic.mobileTI.text = Math.floor(Math.random()*1000000000000).toString();
			stepBasic.zipTI.text = Math.floor(Math.random()*1000000).toString();
			stepBasic.schoolTI.text = 'abcdefghijklmnopqrstuvwxyz';
			stepBasic.addressTI.text = 'abcdefghijklmnopqrstuvwxyz';
		}
		/*
		private function debugDelFlash():void
		{
			var __var:Array = stepBasic.delFlashTI.text.split(',');
			ExternalInterface.call(__var[0], __var[1]);
		}
		*/			
		//==========================
		
		public function buildVariable():void
		{
			Logger.info('StepBasicMediator.buildVariable执行');	
			stepBasic.validate();
			_sendVO();					
		}
		
		public function update():void
		{
			if(ConfigProxy.IS_MODIFY)
			{
				_fillForHasValue(!ConfigProxy.IS_USER)				
			}
			else
			{
				if(ConfigProxy.IS_USER)
				{
					_fillForHasValue(false);
				}
				else
				{
					//gameCodeLabel.text
					//nameTI.text
					stepBasic.nationCB.dataProvider = _data.nation.item;
					//nationCB.selectedIndex
					//maleRB.selected
					//femaleRB.selected
					//sexRBG.enabled
					stepBasic.areaCB.dataProvider = _data.province.item;
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
			var __modify:XML = _data.mod_content[0] as XML;
			stepBasic.gameCodeLabel.text = __modify.game_code;
			stepBasic.nameTI.text = __modify.pdt_author;
			stepBasic.nameTI.enabled = $isAdmin;
			stepBasic.nationCB.dataProvider = _data.nation.item.(@id==__modify.pdt_author_nation);
			stepBasic.nationCB.enabled = false;
			stepBasic.nationCB.selectedIndex = 0;
			stepBasic.sexRBG.selectedValue = __modify.pdt_author_sex;
			stepBasic.sexRBG.enabled = $isAdmin;
			stepBasic.areaCB.dataProvider = _data.province.item.(@id==__modify.pdt_area);
			stepBasic.areaCB.selectedIndex = 0;
			stepBasic.areaCB.enabled = false;		
			stepBasic.ageNS.value = __modify.pdt_author_age;
			stepBasic.emailTI.text = __modify.pdt_author_email;
			stepBasic.emailTI.enabled = $isAdmin;
			stepBasic.zipTI.text = __modify.pdt_author_zip;
			stepBasic.zoneTI.text = __modify.pdt_author_phone.split('-')[0];
			stepBasic.zoneTI.enabled = $isAdmin;
			stepBasic.phoneTI.text = __modify.pdt_author_phone.split('-')[1];
			stepBasic.phoneTI.enabled = $isAdmin;
			stepBasic.mobileTI.text = __modify.pdt_author_mobphone;
			stepBasic.mobileTI.enabled = $isAdmin;
			stepBasic.schoolTI.text = __modify.pdt_school;
			stepBasic.schoolTI.enabled = $isAdmin;
			stepBasic.addressTI.text = __modify.pdt_author_address;
		}
		
		private function _sendVO():void
		{
			var __basicVO:StepBasicVO = new StepBasicVO();
			__basicVO.pdt_author = StringUtil.trim(stepBasic.nameTI.text);
			__basicVO.pdt_author_nation = stepBasic.nationCB.selectedItem.@id;
			__basicVO.pdt_author_sex = stepBasic.sexRBG.selectedValue.toString();
			__basicVO.pdt_author_age = stepBasic.ageNS.value;
			__basicVO.pdt_area = stepBasic.areaCB.selectedItem.@id;
			__basicVO.pdt_author_email = stepBasic.emailTI.text; 
			__basicVO.pdt_author_phone = stepBasic.zoneTI.text + '-' + stepBasic.phoneTI.text;
			__basicVO.pdt_author_mobphone = stepBasic.mobileTI.text;
			__basicVO.pdt_author_zip = stepBasic.zipTI.text;
			__basicVO.pdt_school = stepBasic.schoolTI.text;
			__basicVO.pdt_author_address = stepBasic.addressTI.text;
			
			sendNotification(ApplicationFacade.VAR_UPDATE, __basicVO);
		}
	}
}