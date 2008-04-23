package view
{
	import model.txt.Message;
	import model.type.StepType;
	import model.type.TextVarNameType;
	
	import mx.core.UIComponent;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepText;
	import view.component.StepVS;
	import view.interfaces.IStep;

	public class StepVSMediator extends Mediator
	{
		public static const NAME:String = 'StepVSMediator';
		private var _stepTextMediatorList:Array = [];	//保存动态注册的Mediator的名称
		
		public function StepVSMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get vs():StepVS
		{
			return viewComponent as StepVS;
		}
		
		override public function listNotificationInterests():Array
		{
			return [	ApplicationFacade.RPC_STEP_GET_INFO_DONE,
						ApplicationFacade.NAV_ACCEPT,
						ApplicationFacade.NAV_NEXT,
						ApplicationFacade.NAV_PREV,
						ApplicationFacade.BUILD_TEACHER,
						ApplicationFacade.BUILD_STUDENT	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RPC_STEP_GET_INFO_DONE:
					
					break;
				case ApplicationFacade.NAV_ACCEPT:
					vs.selectedIndex ++;
					break;
				case ApplicationFacade.NAV_NEXT:
					toNextStep();
					break;
				case ApplicationFacade.NAV_START:
					toPrevStep();
					break;
				case ApplicationFacade.BUILD_TEACHER:
					_buildTeacherVS();
					break;
				case ApplicationFacade.BUILD_STUDENT:
					_buildStudentVS();
					break;
			}
		}
		
		/**
		 * 根据当前的VS子部件获取该子部件的Mediator，并返回
		 * */
		private function _getStep($step:UIComponent):IStep
		{
			return facade.retrieveMediator($step.name) as IStep;
		}
		
		private function toNextStep():void
		{
			//try
			//{
				_getStep(vs.selectedChild).buildVariable();
				vs.selectedIndex ++;
				if(vs.selectedIndex > (vs.numChildren -2))
				{
					sendNotification(ApplicationFacade.NAV_END);
				}
			//}
			//catch(err:Error)
			//{
				//Logger.debug(err.getStackTrace());
				//sendNotification(ApplicationFacade.ERROR, err.message, ErrorType.ALERT);
			//}
			
		}
		
		private function toPrevStep():void
		{
			vs.selectedIndex--;
			if(vs.selectedIndex <= 0)
			{
				sendNotification(ApplicationFacade.NAV_START);
			}
			else if(vs.selectedIndex == (vs.numChildren-2))
			{
				sendNotification(ApplicationFacade.NAV_BEFORE_END);
			}
		}
		
		private function toSubmit():void
		{
			try
			{
				_getStep(vs.selectedChild).buildVariable();
				sendNotification(ApplicationFacade.VAR_SUBMIT);
			}
			catch(err:Error)
			{
				Logger.debug(err.getStackTrace());
				sendNotification(ApplicationFacade.ERROR, err.message, ErrorType.ALERT);
			}
		}
		
		/**
		 * 建立第一步和第二步表单之后的表单
		 * */
		 
		private function _buildTeacherVS():void
		{
			_removeVS();
			
			var __tStep3:StepText = new StepText();
			__tStep3.percentWidth = 100;
			__tStep3.percentHeight = 100;
			__tStep3.name = TextVarNameType.INTRODUCE;
			__tStep3.label = Message.LABEL_STEP_INTRODUCE;
			
			var __tStep4:StepText = new StepText();
			__tStep4.percentWidth = 100;
			__tStep4.percentWidth = 100;
			__tStep4.name = TextVarNameType.REMARK;
			__tStep4.isRequired = false;
			__tStep4.label = Message.LABEL_STEP_REMARK;
			
			var __tStep5:StepTeacherPay = new StepTeacherPay();
			__tStep5.percentWidth = 100;
			__tStep5.percentWidth = 100;
			__tStep5.name = StepType.STEP_TEACHER_PAY;
			
			stepUpload.label = Message.LABEL_STEP_UPLOAD_TEACHER;
			
			_buildMediator(__tStep3, __tStep4, __tStep5);
		}
		
		private function _buildStudentVS():void
		{
			_removeVS();
			
			var __sStep3:StepText = new StepText();
			__sStep3.percentWidth = 100;
			__sStep3.percentWidth = 100;
			__sStep3.name = TextVarNameType.IDEA;
			__sStep3.label = Message.LABEL_STEP_IDEA;
			
			var __sStep4:StepText = new StepText();
			__sStep4.percentWidth = 100;
			__sStep4.percentWidth = 100;
			__sStep4.name = TextVarNameType.PROCESS;
			__sStep4.label = Message.LABEL_STEP_PROCESS;
			
			var __sStep5:StepText = new StepText();
			__sStep5.percentWidth = 100;
			__sStep5.percentWidth = 100;
			__sStep5.name = TextVarNameType.LITERATURE;
			__sStep5.label = Message.LABEL_STEP_LITERATURE;
			
			stepUpload.label = Message.LABEL_STEP_UPLOAD_STUDENT;

			_buildMediator(__sStep3, __sStep4, __sStep5);
		}
		
		/**
		 * 建立并注册StepText的Mediator
		 * */
		private function _buildMediator(...$step):void
		{
			for each(var i:StepText in $step)
			{
				vs.addChildAt(i, vs.getChildIndex(stepUpload));
				var __stepTextMediator:StepTextMediator = new StepTextMediator(i.name, i);
				facade.registerMediator(__stepTextMediator);
				_stepTextMediatorList.push(i.name);
			}
		}
		
		/**
		 * 在根据用户类型建立VS之前，必须先将VS还原成初始状态
		 * */
		private function _removeVS():void{
			Logger.info('removeVS运行，删除前的vs子数量：{0}', vs.numChildren);
			var __toRemovedArr:Array = new Array();
			for(var i:int=0; i < vs.numChildren; i++)
			{
				var __step:UIComponent = vs.getChildAt(i) as UIComponent;
				var __isInitStep:Boolean = __step == vs.copyright || __step == vs.stepBasic || __step == vs.stepWorks || __step == vs.stepUpload;
				//Logger.info('当前的step name:{1}，是否保留:{2},当前序号{3}', __step.name, __isInitStep,i);
				if(	!__isInitStep)
				{
					__toRemovedArr.push(__step);
				}
			}
			for each(var k:UIComponent in __toRemovedArr)
			{
				vs.removeChild(k);
			}
			_removeMediator();
			Logger.info('removeVS运行，删除后的vs子数量：{0}', vs.numChildren);
		}
		
		private function _removeMediator():void
		{
			while(_stepTextMediatorList.length>0)
			{
				facade.removeMediator(_stepTextMediatorList.shift().toString());
			}
		}
	}
}