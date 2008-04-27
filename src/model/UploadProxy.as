package model
{
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import model.type.ErrorType;
	import model.vo.SetPBVO;
	import model.vo.UploadResourceVO;
	
	import mx.controls.ProgressBarMode;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class UploadProxy extends Proxy
	{
		public static const NAME:String = 'UploadProxy'
		
		private var _photo:Array;	//第三步详细的参与者信息中的参与者照片（仅教师有）
		private var _file:Array;	//最后一步要上传的所有文件
		private var _allUpload:Array;	//包含photo和file的数组
		
		private var _setInfoProxy:SetInfoProxy;
		private var _uploadResult:XML;
		
		public function UploadProxy(data:Object=null)
		{
			super(NAME, new Array());
			_setInfoProxy = facade.retrieveProxy(SetInfoProxy.NAME) as SetInfoProxy;
		}
		
		public function set uploadPhoto($photoArr:Array):void
		{
			_photo = $photoArr;
			_getUploadList();	//在每次更新上传照片的信息后，都要重建上传列表
		}
		
		public function set uploadFile($fileArr:Array):void
		{
			_file = $fileArr;
			_getUploadList();	//同上
		}
		
		public function upload():void
		{
			if(_allUpload.length <= 0)
			{
				_close();
				return;					
			}
			var __vo:UploadResourceVO = _allUpload.shift() as UploadResourceVO;
			var __file:FileReference = __vo.file;
			var __request:URLRequest = new URLRequest(ConfigProxy.URL);
			__request.method = URLRequestMethod.POST;
			__request.data = __vo.submitVar;
			//__request.
			
			__file.addEventListener(ProgressEvent.PROGRESS, _progressHandler);
			__file.addEventListener(Event.COMPLETE, _completeHandler);
			__file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _completeDataHandler);
			__file.upload(__request, 'upload_data');
			
			//更新进度条，在顶端显示上传的文件名和文件大小
			var __vo:SetPBVO = new SetPBVO(	false, 
											'正在上传文件：'+__file.name+'，' + '文件大小：'+ ConfigProxy.toByteName(__file.size), 
											'已上传 %3％', 
											ProgressBarMode.EVENT, 
											__file);
			sendNotification(ApplicationFacade.SET_PROGRESS_BAR, __vo);
		}
		
		private function _progressHandler(evt:ProgressEvent):void
		{
			trace(evt.bytesLoaded, evt.bytesTotal);				
		}
		
		private function _completeHandler(evt:Event):void
		{
			Logger.debug('上传'+(evt.target as FileReference).name+'成功');
		}
			
		/**
		 * 上传成功并返回数据后，再次上传队列中的下一个文件
		 * */
		private function _completeDataHandler(evt:DataEvent):void
		{				
			try
			{
				Logger.debug('上传'+(evt.target as FileReference).name+'返回数据,evt.data：\n{0}', evt.data);
				_uploadResult = new XML(evt.data);
				Logger.debug('上传'+(evt.target as FileReference).name+'返回数据,_uploadResult：\n{0}', _uploadResult);
				upload();
			}
			catch(err:Error)				
			{
				Logger.debug(err.getStackTrace());
				sendNotification(ApplicationFacade.ERROR, err.message, ErrorType.ALERT);
			}
		}
		
		/**
		 * 获取上传文件的时候需要附带的变量
		 * */
		private function _getUploadVariable():URLVariables
		{
			var __setInfoData:XML = _setInfoProxy.getData() as XML;
			var __var:URLVariables = new URLVariables();
			__var[StepType.STEP_NAME] = StepType.STEP_UPLOAD;
			__var[ModeType.MODE_NAME] = ConfigProxy.MOD_TYPE;
			__var.upload_attribute_id = uploadItem.@id;
			__var.pdt_id = _uploadResult.pdt_id;
			__var.game_code = _uploadResult.game_code;
			__var.pdt_kind_code = _uploadResult.pdt_kind_code;
			__var.pdt_group = _uploadResult.pdt_group;
			__var.pdt_area = _uploadResult.pdt_area;
			/** 如果这个项目需要详细的合作者信息，并且uploadItem.index有值，就设置author_other_info_id的值
			 * uploaditem.index在默认的情况下不会有值，因为如果是从PHP获取的XML，根本就没有这个节点。
			 * 只有是在CopartnerComplex类中设置的XML才添加了这个index节点
			 * author_other_info_id这个变量，仅当当前上传的图片是合作者的照片的时候，才需要设定
			 * 它的值，来自于step_set_info时返回的值
			 * uploadItem.index的值是基于0的序号，正好可以用来获取SetInfoProxy.pdt_author_other_info_id.item这个XMLList的值
			 * */
			 Logger.info("Config.IS_NEED_COPARTNER_INFO:{0}", ConfigProxy.IS_NEED_COPARTNER_INFO);
			 Logger.info(" uploadItem.index:{0}",  uploadItem.index);
			if(ConfigProxy.IS_NEED_COPARTNER_INFO && (uploadItem.index != null))				
			{
				__var.author_other_info_id = __setInfoData.pdt_author_other_info_id.item[uploadItem.index].@id;
			}
			Logger.info('__var:\n{0}', __var);
		}
		
		private function _getUploadList():void
		{
			_allUpload = _photo.concat(_file);
		}
		
		/**
		 * 所有文件上传成功后，倒计时三秒钟关闭页面
		 * */
		private function _close():void
		{
			var __timerHandler:Function = function(evt:TimerEventr):void
			{
				var __countdown:int = (evt.target as Timer).repeatCount - (evt.target as Timer).currentCount;
				setPB(true, '所有项目提交成功！', __countdown.toString()+'秒后自动关闭窗口');
			}
			
			var __timerCompleteHandler:Function = function(evt:TimerEvent):void
			{
				sendNotification(ApplicationFacade.ERROR, ErrorType.CLOSE);
			}
			var __timer:Timer = new Timer(1000, 6);
			__timer.addEventListener(TimerEvent.TIMER, __timerHandler);
			__timer.addEventListener(TimerEvent.TIMER_COMPLETE, __timerCompleteHandler);
			__timer.start();
		}		
	}
}