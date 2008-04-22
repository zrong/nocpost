package view
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepUpload;
	import view.interfaces.IStep;

	public class StepUploadMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepUploadMediator';
		
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
			return [	ApplicationFacade.BUILD_STUDENT,
						ApplicationFacade.BUILD_TEACHER	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.BUILD_STUDENT:
					_update(notification.getBody() as XML);
					break;
				case ApplicationFacade.BUILD_TEACHER:
					_update(notification.getBody() as XML);
					break;
			}
		}
		
		/**
		 * 根据项目建立upload界面
		 * */
		private function _update($project:XML):void
		{
			stepUpload.buildUpload($project);
		}
		
		/**
		 * 检测是否所以要上传的内容都选择了
		 * */
		public function buildVariable():void
		{
			stepUpload.validate();
			sendNotification(ApplicationFacade.UPLOAD_FILE_FILLED, stepUpload.uploadFiles);
		}
		
	}
}