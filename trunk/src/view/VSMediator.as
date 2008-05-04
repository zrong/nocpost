package view
{
	import model.GetInfoProxy;
	import model.txt.Message;
	import model.type.ErrorType;
	import model.type.StepType;
	import model.type.TextVarNameType;
	
	import mx.core.UIComponent;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.*;
	import view.interfaces.IStep;
	import view.interfaces.IStepBuildSub;

	public class VSMediator extends Mediator
	{
		public static const NAME:String = 'StepVSMediator';
		private var _data:XML;
		private var _project:XML;
		private var _dynamicStepMediatorList:Array = [];	//保存动态注册的Mediator的名称
		
		public function VSMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_data = (facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy).getData() as XML;
		}
		
		public function get vs():VS
		{
			return viewComponent as VS;
		}
		
		override public function listNotificationInterests():Array
		{
			return [	ApplicationFacade.PROJECT_CHANGE,
						ApplicationFacade.NAV_ACCEPT,
						ApplicationFacade.NAV_NEXT,
						ApplicationFacade.NAV_PREV,
						ApplicationFacade.NAV_SUBMIT	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.PROJECT_CHANGE:
					_project = notification.getBody() as XML;
					_buildVS(_project);
					break;
				case ApplicationFacade.NAV_ACCEPT:
					vs.selectedIndex ++;
					break;
				case ApplicationFacade.NAV_NEXT:
					toNextStep();
					break;
				case ApplicationFacade.NAV_PREV:
					toPrevStep();
					break;
				case ApplicationFacade.NAV_SUBMIT:
					toSubmit();
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
			try
			{
				_getStep(vs.selectedChild).buildVariable();
				vs.selectedIndex ++;
				if(vs.selectedIndex > (vs.numChildren -2))
				{
					sendNotification(ApplicationFacade.NAV_END);
				}
			}
			catch(err:Error)
			{
				Logger.debug(err.getStackTrace());
				sendNotification(ApplicationFacade.ERROR, err.message, ErrorType.ALERT);
			}
			
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
		
		private function _buildVS($project:XML):void
		{
			_removeVS();
			var __isTeacher:Boolean = _getIsTeacher($project);
			var __isComplexCopartner:Boolean = _getIsCopartnerComplex($project);
			var __cnum:int = int($project.cnum);
			var __tnum:int = int($project.tnum);
			Logger.debug('VSMediator._buildVS执行，$project:{0}',$project);	
			if(__isTeacher)
			{
				_buildTeacherUserVS(__cnum, __isComplexCopartner)
			}
			else
			{
				_buildStudentUserVS(__cnum, __tnum);
			}
		}
		
		/**
		 * 在根据用户类型建立VS之前，必须先将VS还原成初始状态
		 * */
		private function _removeVS():void
		{
			//Logger.info('removeVS运行，删除前的vs子数量：{0}', vs.numChildren);
			_removeMediator();
			var __toRemovedArr:Array = new Array();
			for(var i:int=0; i < vs.numChildren; i++)
			{
				var __step:UIComponent = vs.getChildAt(i) as UIComponent;
				var __isInitStep:Boolean =	(__step is StepCopyright)	||
											(__step is StepBasic) 		|| 
											(__step is StepWorks)		||
											(__step is StepUpload);
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
			//Logger.info('removeVS运行，删除后的vs子数量：{0}', vs.numChildren);
		}
		
		/**
		 * 建立第一步和第二步表单之后的表单
		 * */
		private function _buildTeacherUserVS($cnum:int, $isComplex:Boolean):void
		{
			_removeVS();
			if($isComplex)
			{
				_buildStepCopartnerComplex($cnum);
			}
			else
			{				
				_buildStepCopartnerSimple($cnum);
			}
			var __stepIntroduce:StepText = new StepText();
			__stepIntroduce.percentWidth = 100;
			__stepIntroduce.percentHeight = 100;
			__stepIntroduce.name = TextVarNameType.INTRODUCE;
			__stepIntroduce.label = Message.LABEL_STEP_INTRODUCE;
			
			var __stepRemark:StepText = new StepText();
			__stepRemark.percentWidth = 100;
			__stepRemark.percentWidth = 100;
			__stepRemark.name = TextVarNameType.REMARK;
			__stepRemark.isRequired = false;
			__stepRemark.label = Message.LABEL_STEP_REMARK;
			
			var __stepTeacherPay:StepTeacherPay = new StepTeacherPay();
			__stepTeacherPay.percentWidth = 100;
			__stepTeacherPay.percentWidth = 100;
			__stepTeacherPay.name = StepType.STEP_TEACHER_PAY;
			
			vs.stepUpload.label = Message.LABEL_STEP_UPLOAD_TEACHER;
			
			_buildStepTextMediator(__stepIntroduce, __stepRemark, __stepTeacherPay);
		}
		
		private function _buildStudentUserVS($cnum:int, $tnum:int):void
		{
			_removeVS();
			_buildStepCopartnerSimple($cnum);
			_buildStepHelppingTeacher($tnum);
			
			var __stepIdea:StepText = new StepText();
			__stepIdea.percentWidth = 100;
			__stepIdea.percentWidth = 100;
			__stepIdea.name = TextVarNameType.IDEA;
			__stepIdea.label = Message.LABEL_STEP_IDEA;
			
			var __stepProgress:StepText = new StepText();
			__stepProgress.percentWidth = 100;
			__stepProgress.percentWidth = 100;
			__stepProgress.name = TextVarNameType.PROCESS;
			__stepProgress.label = Message.LABEL_STEP_PROCESS;
			
			var __stepLiterature:StepText = new StepText();
			__stepLiterature.percentWidth = 100;
			__stepLiterature.percentWidth = 100;
			__stepLiterature.name = TextVarNameType.LITERATURE;
			__stepLiterature.label = Message.LABEL_STEP_LITERATURE;
			
			vs.stepUpload.label = Message.LABEL_STEP_UPLOAD_STUDENT;

			_buildStepTextMediator(__stepIdea, __stepProgress, __stepLiterature);
		}
		
		/**
		 * 建立简单的参与者界面
		 * */
		private function _buildStepCopartnerSimple($num:int):void
		{
			var __stepCopartner:StepCopartnerSimple = new StepCopartnerSimple();
			__stepCopartner.percentWidth = 100;
			__stepCopartner.percentHeight = 100;
			__stepCopartner.label = Message.LABEL_STEP_COPARTNER;
			Logger.debug('__stepCopartner.label:{0}',__stepCopartner.label);
			__stepCopartner.name = StepCopartnerSimpleMediator.NAME;
			vs.addChildAt(__stepCopartner, vs.getChildIndex(vs.stepUpload));
			var __mediator:StepCopartnerSimpleMediator = new StepCopartnerSimpleMediator(__stepCopartner);
			__mediator.buildSub($num);
			facade.registerMediator(__mediator);
			_dynamicStepMediatorList.push(StepCopartnerSimpleMediator.NAME);
		}
		
		/**
		 * 建立复杂的参与者界面
		 * */
		private function _buildStepCopartnerComplex($num:int):void
		{
			var __stepCopartner:StepCopartnerComplex = new StepCopartnerComplex();
			__stepCopartner.percentWidth = 100;
			__stepCopartner.percentHeight = 100;
			__stepCopartner.label = Message.LABEL_STEP_COPARTNER;
			__stepCopartner.name = StepCopartnerComplexMediator.NAME;
			vs.addChildAt(__stepCopartner, vs.getChildIndex(vs.stepUpload));
			var __mediator:StepCopartnerComplexMediator = new StepCopartnerComplexMediator(__stepCopartner);
			__mediator.buildSub($num);
			facade.registerMediator(__mediator);
			_dynamicStepMediatorList.push(StepCopartnerComplexMediator.NAME);
		}
		
		/**
		 * 建立指导教师界面
		 * */
		private function _buildStepHelppingTeacher($num:int):void
		{
			var __stepHelppingTeacher:StepHelppingTeacher = new StepHelppingTeacher();
			__stepHelppingTeacher.percentWidth = 100;
			__stepHelppingTeacher.percentHeight = 100;
			__stepHelppingTeacher.label = Message.LABEL_STEP_HELPPINGTEACHER;
			__stepHelppingTeacher.name = StepHelppingTeacherMediator.NAME;
			vs.addChildAt(__stepHelppingTeacher, vs.getChildIndex(vs.stepUpload));
			var __mediator:StepHelppingTeacherMediator = new StepHelppingTeacherMediator(__stepHelppingTeacher);
			__mediator.buildSub($num);
			facade.registerMediator(__mediator);
			_dynamicStepMediatorList.push(StepHelppingTeacherMediator.NAME);
		}
		
		/**
		 * 建立并注册StepText的Mediator
		 * */
		private function _buildStepTextMediator(...$step):void
		{
			for each(var i:UIComponent in $step)
			{
				vs.addChildAt(i, vs.getChildIndex(vs.stepUpload));
				var __stepMediator:IMediator;
				if(i is StepTeacherPay)
				{
					__stepMediator = new StepTeacherPayMediator(i.name, i);
				}	
				else
				{
					__stepMediator = new StepTextMediator(i.name, i);
				}
				facade.registerMediator(__stepMediator);
				_dynamicStepMediatorList.push(i.name);
			}
		}
		
		private function _removeMediator():void
		{
			while(_dynamicStepMediatorList.length>0)
			{
				var __mediatorName:String = _dynamicStepMediatorList.shift().toString();
				var __mediator:IMediator= facade.retrieveMediator(__mediatorName) as IMediator;
				//如果这个Mediator拥有建立子界面的能力，则要在移除它的时候先移除它的子界面的Mediator
				if(__mediator is IStepBuildSub)
				{
					(__mediator as IStepBuildSub).removeSub();
				}
				facade.removeMediator(__mediatorName);				
			}
		}
		
		private function _getIsCopartnerComplex($project:XML):Boolean
		{
			var __bool:Boolean = $project.author_need_info == '1';
			sendNotification(ApplicationFacade.SET_CONFIG_IS_COPARTNER_COMPLEX, __bool);
			return __bool;
		}
		
		private function _getIsTeacher($xml:XML):Boolean
		{
			var __isTeacher:Boolean = $xml.is_teacher == '1';
			sendNotification(ApplicationFacade.SET_CONFIG_IS_TEACHER, __isTeacher);	
			return __isTeacher;
		}
	}
}