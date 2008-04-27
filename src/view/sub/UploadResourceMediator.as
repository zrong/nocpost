package view.sub
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.ConfigProxy;
	import model.SetInfoProxy;
	import model.type.*;
	import model.vo.UploadResourceVO;
	
	import mx.controls.Button;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.sub.component.UploadResource;
		
	public class UploadResourceMediator extends Mediator
	{
		public static const NAME:String = 'UploadResourceMediator';
		
		private var _uploadItem:XML;
		private var _uploadFR:FileReference;
		
		private var _downBlankWordBTN:Button;
		private var _setInfoProxy:SetInfoProxy;
		//只有这个值为真，才会允许将这个上传模块加入上传列表中
		public var isModify:Boolean;	
		
		//$prefix是一个前缀，UploadResource被CopartnerComplex使用的时候可能会用到这个前缀
		public function UploadResourceMediator($uploadItem:XML=null, viewComponent:Object=null, $prefix:String='')
		{
			super($prefix + NAME + $uploadItem.@id, viewComponent);
			_uploadItem = $uploadItem;
			_setInfoProxy = facade.retrieveProxy(SetInfoProxy.NAME) as SetInfoProxy;
			init();
		}
		
		private function get _view():UploadResource
		{
			return viewComponent as UploadResource;
		}
			
		private function init():void
		{			
			_view.itemNameLabel.text = _uploadItem.@name;
			_view.uploadSizeLabel.text = _uploadItem.upload_file_size;
			_view.uploadNameLabel.text = _uploadItem.upload_file_name;
			_view.limitLabel.text = _uploadItem.upload_attribute_introduce+'  允许的文件格式：'+
									_uploadItem.upload_attribute_postfix+'  文件大小限制：'+
									_uploadItem.upload_attribute_size_limit+'MB';			
			_view.addEventListener(UploadResource.UPLOAD_CLICK, _selectBTNClickHandler);
			
			_uploadFR = new FileReference();
			_uploadFR.addEventListener(Event.SELECT, selectHandler);
			_buildDownBlankWordBTN();
		}
		
		private function _selectBTNClickHandler(evt:Event):void
		{
			var __typeFilter:FileFilter = new FileFilter(_uploadItem.@name+'('+_uploadItem.upload_attribute_postfix+')', _uploadItem.upload_attribute_postfix);
			_uploadFR.browse([__typeFilter]);
		}
		
		/**
		 * 建立下载登记表的按钮，该函数必须在本组件create完成后才能执行，因此放在init中了
		 * */
		private function _buildDownBlankWordBTN():void
		{
			var blankWordURL:String = _uploadItem.upload_blank_word.toString();
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
					_view.selectBox.addChildAt(_downBlankWordBTN, _view.selectBox.getChildIndex(_view.selectBTN)+1);
				}
			}
			
		}
		
		private function selectHandler(evt:Event):void
		{
			//选择文件的时候，先将isModify置为未改变，放置选择的文件不符合规定
			isModify = false;
			Logger.debug('_uploadItem:{0}',  _uploadItem);				
			var __file:FileReference = evt.target as FileReference;
			var __size:Number = ConfigProxy.toByteNum(Number(_uploadItem.upload_attribute_size_limit));
			if(__file.size > __size)
			{
				sendNotification(ApplicationFacade.ERROR, '选择的文件过大！', ErrorType.ALERT);
				_view.uploadSizeLabel.text = '';
				_view.uploadNameLabel.text = '';
				return;
			}
			if(!_validateType(__file.type))
			{
				sendNotification(ApplicationFacade.ERROR, '选择的文件类型不对！', ErrorType.ALERT);
				_view.uploadSizeLabel.text = '';
				_view.uploadNameLabel.text = '';
				return;
			}
			isModify = true;
			_view.uploadSizeLabel.text = ConfigProxy.toByteName(__file.size);
			_view.uploadNameLabel.text = __file.name;
		}
		
		public function getUpload():UploadResourceVO
		{
			_view.validate();
			return new UploadResourceVO(_uploadFR, _uploadItem.@id, _uploadItem.index);
		}
		
		/**
		 * 当前选择文件的类型是否在允许的范围内
		 * */
		private function _validateType($type:String):Boolean
		{
			var __type:String = _uploadItem.upload_attribute_postfix.toString().toLowerCase();
			return __type.lastIndexOf($type.toLowerCase()) != -1;
		}
	}
}