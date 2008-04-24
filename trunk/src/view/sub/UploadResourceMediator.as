package view.sub
{
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.navigateToURL;
	
	import model.ConfigProxy;
	import model.SetInfoProxy;
	import model.type.*;
	import model.vo.UploadResourceVO;
	
	import mx.controls.Button;
	import mx.events.PropertyChangeEvent;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.sub.component.UploadResource;
		
	public class UploadResourceMediator extends Mediator
	{
		public static const NAME:String = 'UploadResourceMediator';
		
		public var uploadItem:XML;
		private var _uploadFR:FileReference;
		
		private var _downBlankWordBTN:Button;
		private var _setInfoProxy:SetInfoProxy;
		//只有这个值为真，才会允许将这个上传模块加入上传列表中
		public var isModify:Boolean;	
		
		public function UploadResourceMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			_setInfoProxy = facade.retrieveProxy(SetInfoProxy.NAME) as SetInfoProxy;
			init();
		}
		
		private function get uploadResource():UploadResource
		{
			return viewComponent as UploadResource;
		}
			
		private function init():void
		{			
			uploadResource.uploadItem = uploadItem;
			uploadResource.addEventListener(UploadResource.UPLOAD_CLICK, _selectBTNClickHandler);
			_uploadFR = new FileReference();
			_uploadFR.addEventListener(Event.SELECT, selectHandler);
			_buildDownBlankWordBTN();
		}
		
		private function _selectBTNClickHandler(evt:Event):void
		{
			var __typeFilter:FileFilter = new FileFilter(uploadItem.@name+'('+uploadItem.upload_attribute_postfix+')', uploadItem.upload_attribute_postfix);
			_uploadFR.browse([__typeFilter]);
		}
		
		/**
		 * uploadItem变动的时候执行
		 * */
		private function uploadItemChange(evt:PropertyChangeEvent):void
		{
			Logger.info('uploadItemChange执行,oldValue:{0}\nnewValue:{1}', evt.oldValue, evt.newValue);
			Logger.info('uploadItemChange执行,kind:{0}\nproperty:{1}', evt.kind, evt.property);
			var blankWordURL:String = (evt.newValue as XML).upload_blank_word.toString();
			if(blankWordURL.length > 0)
			//如果提供了空白word电子表格下载地址，就建立一个按钮下载空白电子表格
			{
				//build_downBlankWordBTN(blankWordURL);
			}
		}
		
		/**
		 * 建立下载登记表的按钮，该函数必须在本组件create完成后才能执行，因此放在init中了
		 * */
		private function _buildDownBlankWordBTN():void
		{
			var blankWordURL:String = uploadItem.upload_blank_word.toString();
			Logger.info('build_downBlankWordBTN执行,blankWordURL：{0},length:{1}', blankWordURL, blankWordURL.length);
			if(blankWordURL.length > 0)
			//如果提供了空白word电子表格下载地址，就建立一个按钮下载空白电子表格
			{
				var clickHandler:Function = function():void
				{
					flash.net.navigateToURL(new URLRequest(blankWordURL), '_blank');
				}
				if(_downBlankWordBTN == null)
				{
					_downBlankWordBTN = new Button();
					_downBlankWordBTN.label = '下载空白表格';
					_downBlankWordBTN.toolTip = '点击下载空白Word格式电子表格，填写后上传。';	
					_downBlankWordBTN.addEventListener(MouseEvent.CLICK, clickHandler);
					uploadResource.selectBox.addChildAt(_downBlankWordBTN, uploadResource.selectBox.getChildIndex(uploadResource.selectBTN)+1);
				}
			}
			
		}
		
		/**
		 * 当前选择文件的类型是否在允许的范围内
		 * */
		private function validateType($type:String):Boolean
		{
			var __type:String = uploadItem.upload_attribute_postfix.toString().toLowerCase();
			return __type.lastIndexOf($type.toLowerCase()) != -1;
		}
		
		private function selectHandler(evt:Event):void
		{
			//选择文件的时候，先将isModify置为未改变，放置选择的文件不符合规定
			isModify = false;
			Logger.debug(' uploadItem:{0}',  uploadItem);				
			var __file:FileReference = evt.target as FileReference;
			var __size:Number = _toByteNum(Number(uploadItem.upload_attribute_size_limit));
			if(__file.size > __size)
			{
				sendNotification(ApplicationFacade.ERROR, '选择的文件过大！', ErrorType.ALERT);
				uploadResource.uploadSizeLabel.text = '';
				uploadResource.uploadNameLabel.text = '';
				return;
			}
			if(!validateType(__file.type))
			{
				sendNotification(ApplicationFacade.ERROR, '选择的文件类型不对！', ErrorType.ALERT);
				uploadResource.uploadSizeLabel.text = '';
				uploadResource.uploadNameLabel.text = '';
				return;
			}
			isModify = true;
			uploadResource.uploadSizeLabel.text = _toByteName(__file.size);
			uploadResource.uploadNameLabel.text = __file.name;
		}
		
		public function getUpload():UploadResourceVO
		{
			uploadResource.validate();
			var __setInfoData:XML = _setInfoProxy.getData() as XML;
			var __var:URLVariables = new URLVariables();
			__var[StepType.STEP_NAME] = StepType.STEP_UPLOAD;
			__var[ModeType.MODE_NAME] = ConfigProxy.MOD_TYPE;
			__var.upload_attribute_id = uploadItem.@id;
			__var.pdt_id = __setInfoData.pdt_id;
			__var.game_code = __setInfoData.game_code;
			__var.pdt_kind_code = __setInfoData.pdt_kind_code;
			__var.pdt_group = __setInfoData.pdt_group;
			__var.pdt_area = __setInfoData.pdt_area;
			/** 如果这个项目需要详细的合作者信息，并且uploadItem.index有值，就设置author_other_info_id的值
			 * uploaditem.index在默认的情况下不会有值，因为如果是从PHP获取的XML，根本就没有这个节点。
			 * 只有是在CopartnerInfo类中设置的XML才添加了这个index节点
			 * author_other_info_id这个变量，仅当当前上传的图片是合作者的照片的时候，才需要设定
			 * 它的值，来自于step_set_info时返回的值
			 * uploadItem.index的值是基于0的序号，正好可以用来获取Config.RESULT_DATA.pdt_author_other_info_id.item这个XMLList的值
			 * */
			 Logger.info("Config.IS_NEED_COPARTNER_INFO:{0}", ConfigProxy.IS_NEED_COPARTNER_INFO);
			 Logger.info(" uploadItem.index:{0}",  uploadItem.index);
			if(ConfigProxy.IS_NEED_COPARTNER_INFO && (uploadItem.index != null))				
			{
				__var.author_other_info_id = __setInfoData.pdt_author_other_info_id.item[uploadItem.index].@id;
			}
			Logger.info('__var:\n{0}', __var);
			
			return new UploadResourceVO(_uploadFR, __var);
		}
		
		/**
		 * 自动把传来的字节转成MB或者KB
		 * */
		private function _toByteName($byte:int):String
		{
			Logger.debug('toByName执行,$byte:{1}',$byte);
			var __name:String;
			var __num:Number;
			if($byte < 1048576)
			{
				__name = 'KB';
				__num = $byte/1024;
			}
			else
			{
				__name = 'MB';
				__num = $byte/1048576;
			}
			return Math.floor(__num*10)/10+__name;
		}
		
		private function _toByteNum($mb:Number):int
		{
			return $mb*1048576;
		}
	}
}