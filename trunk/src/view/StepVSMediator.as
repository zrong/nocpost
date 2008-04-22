package view
{
	import model.type.ErrorType;
	import model.type.StepType;
	
	import mx.core.UIComponent;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepTeacherPay;
	import view.component.StepText;
	import view.component.StepVS;
	import view.interfaces.IStep;

	public class StepVSMediator extends Mediator
	{
		public static const NAME:String = 'StepVSMediator';
		
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
		private function getStep($step:UIComponent):IStep
		{
			var __step:IStep;
			switch($step.name)
			{
				case StepType.STEP_BASIC:
					__step = facade.retrieveMediator(StepBasicMediator.NAME) as IStep;
					break;
			}
			return __step;
		}
		
		private function toNextStep():void
		{
			//try
			//{
				getStep(vs.selectedChild).buildVariable();
				vs.selectedIndex ++;
				if(vs.selectedIndex > (vs.numChildren -2))
				{
					sendNotification(ApplicationFacade.NAV_END);
				}
			//}
			//catch(err:Error)
			//{
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
		
		/**
		 * 建立第一步和第二步表单之后的表单
		 * */
		 
		private function _buildTeacherVS():void
		{
			/*
			_removeVS();
			
			var __tStep3:StepText = new StepText();
			__tStep3.width = vs.width;
			__tStep3.height = vs.height;
			__tStep3.name = 'tStep3';
			__tStep3.varName = 'pdt_introduce';
			__tStep3.label = "<font size='14' color='#ff0000'><b>第三步：作品概要</b></font>";
			__tStep3.info = info;		
			
			var __tStep4:StepText = new StepText();
			__tStep4.width = vs.width;
			__tStep4.height = vs.height;
			__tStep4.name = 'tStep4';
			__tStep4.varName = 'pdt_remark';
			__tStep4.isRequired = false;
			__tStep4.label = "<font size='14' color='#ff0000'><b>第四步：备注</b><br>若作品联系人不是作者本人，可在此注明联系人的通讯方式</font>";
			__tStep4.info = info;
			
			var __tStep5:StepTeacherPay = new StepTeacherPay();
			__tStep4.width = vs.width;
			__tStep4.height = vs.height;
			__tStep4.name = 'tStep5';
			
			stepUpload.label = "<font size='14' color='#ff0000'><b>第五步:上传文件（完成）</b>";
			
			vs.addChildAt(__tStep3, vs.getChildIndex(stepUpload));
			vs.addChildAt(__tStep4, vs.getChildIndex(stepUpload));
			vs.addChildAt(__tStep5, vs.getChildIndex(stepUpload));
			
			__tStep3.update();
			__tStep4.update();
			*/
		}
		
		private function _buildStudentVS():void
		{
			/*
			_removeVS();
			
			var __sStep3:StepText = new StepText();
			__sStep3.width = vs.width;
			__sStep3.height = vs.height;
			__sStep3.name = 'sStep3';
			__sStep3.varName = 'pdt_idea';
			__sStep3.label = "<font size='14' color='#ff0000'><b>第三步：创作思想</b></font><br>解释作品创作的背景、目的和意义列、列明哪些部分属自己原创";
			__sStep3.info = info;
			
			
			var __sStep4:StepText = new StepText();
			__sStep4.width = vs.width;
			__sStep4.height = vs.height;
			__sStep4.name = 'sStep4';
			__sStep4.varName = 'pdt_process';
			__sStep4.label = "<font size='14' color='#ff0000'><b>第四步：创作过程</b></font><br>解释运用了哪些技术或技巧完成主题创作";
			__sStep4.info = info;
			
			var __sStep5:StepText = new StepText();
			__sStep5.width = vs.width;
			__sStep5.height = vs.height;
			__sStep5.name = 'sStep5';
			__sStep5.varName = 'pdt_literature';
			__sStep5.label = "<font size='14' color='#ff0000'><b>第五步：参考资源</b></font><br>详细列明参考或引用他人资源的出处";
			__sStep5.info = info;
			
			stepUpload.label = "<font size='14' color='#ff0000'><b>第六步:上传文件（完成）</b>";
			
			vs.addChildAt(__sStep3, vs.getChildIndex(stepUpload));			
			vs.addChildAt(__sStep4, vs.getChildIndex(stepUpload));
			vs.addChildAt(__sStep5, vs.getChildIndex(stepUpload));
			
			__sStep3.update();
			__sStep4.update();
			__sStep5.update();
			*/
		}

		
		/**
		 * 在根据用户类型建立VS之前，必须先将VS还原成初始状态
		 * */
		private function _removeVS():void{
			/*
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
			Logger.info('removeVS运行，删除后的vs子数量：{0}', vs.numChildren);
			*/
		}
	}
}