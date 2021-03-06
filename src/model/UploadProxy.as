package model
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import model.type.ErrorType;
	import model.type.ModeType;
	import model.type.StepType;
	import model.type.TextVarNameType;
	import model.vo.SetPBVO;
	import model.vo.UploadResourceVO;
	
	import mx.controls.ProgressBarMode;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class UploadProxy extends Proxy
	{
		public static const NAME:String = 'UploadProxy'
		
		private var _photo:Array = [];	//第三步详细的参与者信息中的参与者照片（仅教师有）
		private var _file:Array = [];	//最后一步要上传的所有文件
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
			__request.data = _getUploadVariable(__vo.id, __vo.index);
			
			__file.addEventListener(ProgressEvent.PROGRESS, _progressHandler);
			__file.addEventListener(Event.COMPLETE, _completeHandler);
			__file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _completeDataHandler);
			__file.upload(__request, TextVarNameType.UPLOAD_DATA);
			
			//更新进度条，在顶端显示上传的文件名和文件大小
			var __pbvo:SetPBVO = new SetPBVO(	false, 
											'正在上传文件：'+__file.name+'，' + '文件大小：'+ ConfigProxy.toByteName(__file.size), 
											'已上传 %3％', 
											ProgressBarMode.EVENT, 
											__file);
			sendNotification(ApplicationFacade.SET_PROGRESS_BAR, __pbvo);
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
		private function _getUploadVariable($id:String, $index:String):URLVariables
		{
			var __setInfoData:XML = _setInfoProxy.getData() as XML;
			Logger.debug('__setInfoData:{0}', __setInfoData.toString());
			var __var:URLVariables = new URLVariables();
			__var[StepType.RPC_STEP_NAME] = StepType.RPC_STEP_UPLOAD;
			__var[ModeType.MODE_NAME] = ConfigProxy.MOD_TYPE;
			__var.pdt_id = __setInfoData.pdt_id;
			__var.game_code = __setInfoData.game_code;
			__var.pdt_kind_code = __setInfoData.pdt_kind_code;
			__var.pdt_group = __setInfoData.pdt_group;
			__var.pdt_area = __setInfoData.pdt_area;
			
			__var.upload_attribute_id = $id;
			/** 如果这个项目需要详细的合作者信息，并且$index有值，就设置author_other_info_id的值
			 * $index在默认的情况下不会有值，因为如果是从PHP获取的XML，根本就没有这个节点。
			 * 只有是在CopartnerComplex类中设置的_uploadItem才添加了这个index节点
			 * author_other_info_id这个变量，仅当当前上传的图片是合作者的照片的时候，才需要设定它的值，
			 * 它的值来自于step_set_info时返回的值
			 * CopartnerComplex中的$index的值是基于0的序号，正好可以用来获取SetInfoProxy.pdt_author_other_info_id.item这个XMLList的值
			 * */
			 Logger.info("Config.IS_NEED_COPARTNER_INFO:{0}", ConfigProxy.IS_NEED_COPARTNER_INFO);
			 Logger.info(" $index:{0}",  $index);
			if(ConfigProxy.IS_NEED_COPARTNER_INFO && ($index != null))				
			{
				__var.author_other_info_id = __setInfoData.pdt_author_other_info_id.item[$index].@id;
			}
			Logger.info('__var:\n{0}', __var);
			return __var;
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
			var __timerHandler:Function = function(evt:TimerEvent):void
			{
				var __countdown:int = (evt.target as Timer).repeatCount - (evt.target as Timer).currentCount;
				var __vo:SetPBVO = new SetPBVO(true, '所有项目提交成功！', __countdown.toString()+'秒后自动关闭窗口');
				sendNotification(ApplicationFacade.SET_PROGRESS_BAR, __vo);
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