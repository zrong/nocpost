package view
{
	import model.type.StepType;
	import model.vo.UploadResourceVO;
	
	import mx.core.UIComponent;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepUpload;
	import view.interfaces.IStep;
	import view.sub.UploadResourceMediator;
	import view.sub.component.UploadResource;

	public class StepUploadMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepUploadMediator';
		
		private var _uploadMediatorNameList:Array = [];
		
		public function StepUploadMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get stepUpload():StepUpload
		{
			return viewComponent as StepUpload;
		}
		
		override public function listNotificationInterests():Array
		{
			return [	ApplicationFacade.PROJECT_CHANGE	];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.PROJECT_CHANGE:
					var __project:XML = notification.getBody() as XML;
					_update(__project);
					break;
			}
		}
		
		/**
		 * 检测是否所以要上传的内容都选择了
		 * */
		public function buildVariable():void
		{
			//stepUpload.validate();
			var _uploadList:Array = _getAllUpload();
			//将要上传的文件填充到UploadProxy中，并指名是上传步骤中填充的
			sendNotification(ApplicationFacade.UPLOAD_FILE_FILLED, _uploadList, StepType.RPC_STEP_UPLOAD);
		}
		
		/**
		 * 根据项目建立upload界面
		 * */
		private function _update($project:XML):void
		{
			_removeUpload();
			_buildUpload($project);			
		}
		
		private function _removeUpload():void
		{
			Logger.info('StepUploadMediator._removeUpload执行');
			//要移除的子显示对象列表
			var __toRemovedArr:Array = new Array();
			//建立界面前先清空除了Text、uploadPhoto、uploadPicture之外的子显示对象
			for(var i:int=0; i<stepUpload.numChildren; i++)
			{
				var __child:UIComponent = stepUpload.getChildAt(i) as UIComponent;
				if(__child is UploadResource)
				{
					__toRemovedArr.push(__child);
				}
			}
			for each(var k:UIComponent in __toRemovedArr)
			{
				stepUpload.removeChild(k);
			}
			while(_uploadMediatorNameList.length > 0)
			{
				facade.removeMediator(_uploadMediatorNameList.shift().toString());
			}
		}
		
		private function _buildUpload($project:XML):void
		{
			//获取待上传的信息列表
			var __uploadList:XMLList = $project.upload_attribute.item;
			//根据获取的待上传的项目信息列表，重建上传显示对象
			for each(var j:XML in __uploadList)
			{
				var __upload:UploadResource = new UploadResource();
				__upload.percentWidth = 100;				
				stepUpload.addChild(__upload);
				var __mediator:UploadResourceMediator = new UploadResourceMediator(j, __upload);
				facade.registerMediator(__mediator);
				_uploadMediatorNameList.push(__mediator.getMediatorName());
			}
		}
		
		private function _getAllUpload():Array
		{	
			var __uploadArr:Array = new Array();	
			for each(var i:String in _uploadMediatorNameList)
			{
				var __mediator:UploadResourceMediator = facade.retrieveMediator(i) as UploadResourceMediator;
				/** 只有当上传模块被改变了，才被允许加入上传列表
				 * 这是为了处理修改已有作品的问题
				 * 如果当前的状态是修改已有作品，并且不检测当前上传的项目是否重新选择过了
				 * 这是没有选择的upload也会被加入队列，造成上传失败
				 * */
				var __uploadVO:UploadResourceVO = __mediator.getUpload();
				if(__mediator.isModify)
				{
					__uploadArr.push(__uploadVO);
				}
			}
			return __uploadArr;
		}
	}
}