package view
{
	import flash.events.Event;
	
	import model.ConfigProxy;
	import model.GetInfoProxy;
	import model.vo.StepWorksVO;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepWorks;

	import view.interfaces.IStep;
	import view.sub.CopartnerAndTeacherMediator;

	public class StepWorksMediator extends Mediator implements IStep
	{
		public static const NAME:String = 'StepWorksMediator';
		
		//===========================================
		//
		//	实例属性
		//
		//===========================================
		
		private var _getInfoProxy:GetInfoProxy;
		private var _data:XML;
		[Bindable]
		private var _groupDP:XMLList;
		[Bindable]
		private var _gradeDP:XMLList;
		
		private var _isTeacher:Boolean;	//当前选中的项目是不是教师项目
		private var _hasModule:Boolean;	//是否有教学模式属性
		
		private var _catMediator:CopartnerAndTeacherMediator;
		
		public function StepWorksMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_initMVC();
			_initEvent();	
		}
		
		private function _initMVC():void
		{
			_getInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			_catMediator = new CopartnerAndTeacherMediator(stepWorks.cat);
			facade.registerMediator(_catMediator);
		}
		
		private function _initEvent():void
		{
			stepWorks.addEventListener(StepWorks.DEBUG_FILL, debugFill);
			stepWorks.addEventListener(StepWorks.PROJECT_CHANGE, _projectChangeHandler);
			stepWorks.addEventListener(StepWorks.GROUP_CHANGE, _groupChangeHandler);
		}
		
		private function get stepWorks():StepWorks
		{
			return viewComponent as StepWorks;
		}
		
		override public function listNotificationInterests():Array
		{
			return [	ApplicationFacade.RPC_STEP_GET_INFO_DONE	];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RPC_STEP_GET_INFO_DONE:
					_data = _getInfoProxy.getData() as XML;
					stepWorks.info = _data;
					_buildFrameFromModeTypeAndUserType();
					_update();
					break;
			}
		}		
		
		//======================================================================================
		//
		//	实例方法 buildVariable()、update()以及他们调用的方法
		//
		//======================================================================================
		
		private function _buildFrameFromModeTypeAndUserType():void
		{
			var __project:XML;
			var __projectID:String;
			if(ConfigProxy.IS_MODIFY)
			{
				__project = _data.project.item.(@id==_data.mod_content.pdt_kind)[0] as XML;
				_buildFrame(__project);				
			}
			else
			{
				if(ConfigProxy.IS_USER)
				{
					__project = _data.project.item.(@id==_data.mod_content.pdt_kind)[0] as XML;
					_buildFrame(__project);					
				}
				else
				{
					stepWorks.removeTeacher();
				}
			}
		}
		
		private function _buildFrame($project:XML):void
		{
			var __projectID:String = $project.@id;
			//var __isTeacher:Boolean = $project.is_teacher == '1';
			Logger.info('_buildFrame执行，__project：\n{0}', $project);
			_isTeacher = ConfigProxy.IS_TEACHER;
			_hasModule = _getHasModule($project);
			if(_isTeacher)
			//如果是教师项目，就增加教师独有的信息，同时根据教师参加的项目的参与者数量添加参与者字段
			{
				_buildTeacher(__projectID);
			}
			else
			//如果是学生项目，就移除教师独有的表单，同时根据学生参加的项目添加参与者与辅导教师相关的字段
			{
				_buildStudent(__projectID);
			}
		}
		//===========================================
		//	update()	被Application._buildFrameFromModeTypeAndUserType()和buildVS()和调用
		//===========================================
		/**
		 * 更新界面，填写表单元素的初始值
		 * */
		private function _update():void
		{
			
			if(ConfigProxy.IS_MODIFY)
			{
				_fillForHasValue(!ConfigProxy.IS_USER, true);	
				_catMediator.fillCopartnerAndHelppingTeacher();			
			}
			else
			{
				if(ConfigProxy.IS_USER)
				{
					_fillForHasValue(false, false);
				}
				else
				{
					//nameTI.text 
					stepWorks.projectCB.dataProvider = _data.project.item;
					//projectCB.selectedIndex = 0;
					//groupCB.dataProvider = _groupDP;
					//groupCB.selectedIndex = 0;
					//gradeCB.dataProvider = _gradeDP;
					//gradeCB.selectedIndex = 0;
					stepWorks.subjectCB.dataProvider = _data.subject.item;
					//subjectCB.selectedIndex = 0;
					//bookTI.text = __modify.pdt_book_edition;
					stepWorks.moduleCB.dataProvider = _data.module_type.item;
					//moduleCB.selectedIndex = 0;
				}
			}
		}
		
		//===========================================
		//	_fillForHasValue()	供update()方法调用
		//===========================================
		/**
		 * 提供界面数据
		 * $isAdmin 是普通用户还是管理员
		 * $isModify 是不是修改状态
		 * */
		private function _fillForHasValue($isAdmin:Boolean, $isModify:Boolean):void
		{
			var __modify:XML = XML(_data.mod_content[0]);
			stepWorks.nameTI.text = __modify.pdt_name;
			stepWorks.projectCB.dataProvider = _data.project.item.(@id==__modify.pdt_kind);
			stepWorks.projectCB.selectedIndex = 0;
			stepWorks.projectCB.enabled = false;
			stepWorks.groupCB.dataProvider = _data.group.item.(@id==__modify.pdt_group);
			stepWorks.groupCB.selectedIndex = 0;
			stepWorks.groupCB.enabled = false;
			stepWorks.gradeCB.dataProvider = _data.grade.item.(@id==__modify.pdt_author_grade);
			stepWorks.gradeCB.selectedIndex = 0;
			stepWorks.gradeCB.enabled = false;
			stepWorks.bookTI.text = __modify.pdt_book_edition;
			if($isModify)
			//修改状态，就使用选定的值
			{
				stepWorks.subjectCB.dataProvider = _data.subject.item.(@id==__modify.pdt_subject);
				stepWorks.moduleCB.dataProvider = _data.module_type.item.(@id==__modify.pdt_module_type);
				stepWorks.subjectCB.selectedIndex = 0;
				stepWorks.moduleCB.selectedIndex = 0;
				stepWorks.subjectCB.editable = $isAdmin;				
				stepWorks.moduleCB.enabled = $isAdmin;
			}
			//插入状态，就使用全部的值
			else
			{
				stepWorks.subjectCB.dataProvider = _data.subject.item;
				stepWorks.moduleCB.dataProvider = _data.module_type.item;
			}			
		}
		

		
		//===========================================
		//	buildVariable()	被NavButton.nextClickHandler()调用
		//===========================================
		/**
		 * 在要提交的变量中添加本步骤的值
		 * */
		public function buildVariable():void
		{
			Logger.info('StepWorksMediator.buildVariable执行');	
			stepWorks.validate(_isTeacher, _hasModule);
			_sendVO();
			
		}
		
		private function _sendVO():void
		{
			var __vo:StepWorksVO = new StepWorksVO();
			__vo.pdt_name = stepWorks.nameTI.text;
			__vo.pdt_kind = stepWorks.projectCB.selectedItem.@id;
			__vo.pdt_group = stepWorks.groupCB.selectedItem.@id;					
			__vo.pdt_author_grade = stepWorks.gradeCB.selectedItem.@id;
			if(ConfigProxy.IS_NEED_COPARTNER_INFO)
			//如果需要合作者的详细信息，就采用pdt_author_other_info这个变量提交
			{
				__vo.pdt_author_other_info = _catMediator.buildCopartnerStringForSubmit();
			}
			else
			//如果只需要合作者姓名，就采用pdt_author_other这个变量提交
			{
				__vo.pdt_author_other = _catMediator.buildCopartnerStringForSubmit();
			}
			if(_isTeacher)
			//只有教师才有科目、教材版本、教学模式信息
			{
				__vo.pdt_subject = stepWorks.subjectCB.selectedItem.@id;
				__vo.pdt_book_edition = stepWorks.bookTI.text; 
				if(_hasModule)
				//只有当教师的这个项目有模式的时候才需要调用模式信息
				{
					__vo.pdt_module_type = stepWorks.moduleCB.selectedItem.@id;
				}										
			}
			else
			//只有学生才有辅导教师信息
			{
				__vo.pdt_teacher = _catMediator.buildHelppingTeacherStrinForSubmit();
			}
			
			sendNotification(ApplicationFacade.VAR_UPDATE, __vo);				
		}
		
		
		//======================================================================================
		//
		//	实例方法 侦听器类	_projectChangeHandler()、_groupChangeHandler()以及被他们调用的方法
		//
		//======================================================================================
		
		//===========================================
		//	_projectChangeHandler()
		//===========================================		
		/**
		 * 当项目列表（projectCB）改变选择的时候进行
		 * */
		private function _projectChangeHandler(evt:Event):void
		{
			var __xml:XML = stepWorks.projectCB.selectedItem as XML;
			_isTeacher = _getIsTeacher(__xml);
			_hasModule = _getHasModule(__xml);	//教学实践评优的id是14，只有它有“模式”这个字段
			var __projectID:String = __xml.@id;
			Logger.info('projectChangeHandler执行，__projectID:{1}', __projectID);
			//Logger.info('projectChangeHandler执行，__xml:{1}', _data.project);
			/*
			Logger.info('_isTeacher:{1}', _isTeacher);
			Logger.info('_hasModule:{1}', _hasModule);
			Logger.info('__cnum:{1}', __cnum);
			Logger.info('__tnum:{1}', __tnum);*/
			
			_catMediator.removeCAT();
			if(_isTeacher)
			{
				_buildTeacher(__projectID);
				_groupDP = _getGroupOfUser(true);
			}
			else
			{
				_buildStudent(__projectID);
				_groupDP = _getGroupOfUser(false);
			}
			stepWorks.groupCB.dataProvider = _groupDP;
			stepWorks.groupCB.selectedIndex = -1;
			stepWorks.groupCB.enabled = true;	
		}
		
		//===========================================
		//	_groupChangeHandler()
		//===========================================
		/**
		 * 当组别列表（groupCB）改变选择的时候进行
		 * */
		private function _groupChangeHandler(evt:Event):void
		{
			var __xml:XML = stepWorks.groupCB.selectedItem as XML;
			if(_isTeacher)
			{
				_gradeDP = _getGradeOfGroup(__xml.@teacher_group);
			}
			else
			{
				_gradeDP = _getGradeOfGroup(__xml.@student_group);	
			}
			stepWorks.gradeCB.dataProvider = _gradeDP;
			stepWorks.gradeCB.selectedIndex = -1;
			stepWorks.gradeCB.enabled = true;
		}
		
		//===========================================
		//	_getGroupOfUser()	被projectChangeHandler()方法调用
		//===========================================
		/**
		 * 根据xml中的用户类型，返回相应的用户对应的组别级属性
		 * */
		private function _getGroupOfUser($isTeacher:Boolean):XMLList
		{
			//Logger.info('_getGroupOfUser执行');
			var __xmlList:XMLList;
			if($isTeacher)
			{
				__xmlList = _data.group.item.(@teacher_group.toString().length!=0);
				//Logger.info('用户是教师：\n{1}', __xmlList);	
				return __xmlList;
			}
			__xmlList = _data.group.item.(@student_group.toString().length!=0);
			//Logger.info('用户是学生：\n{1}', __xmlList);	
			return __xmlList;
		}
		
		//===========================================
		//	_getGradeOfGroup()	被groupChangeHandler()方法调用
		//===========================================
		/**
		 * 根据给定的group中包含的教师或者学生年级id，返回这个组别中的年级
		 * */
		private function _getGradeOfGroup($str:String):XMLList
		{
			//Logger.info('_getGradeOfGroup执行');
			var __strArr:Array = $str.split(',');	//将grade的相关id值转成数组
			/**
			 * 对数组进行操作的函数，把数组中的每个元素前面加上^，后面加上$
			 * */
			var __fun:Function = function($item:*, $index:int, $arr:Array):void
			{
				$arr[$index] = '^'+$item+'$';
			}
			__strArr.forEach(__fun);
			//生成待处理的正则表达式，根据group中指定的id值对xml进行筛选
			var __reg:RegExp = new RegExp(__strArr.join('|'));
			/*
			Logger.info('正则表达式：{1}', __strArr.join('|'));
			Logger.info('查询到的当前年级：\n{1}', _data.grade.item.(__reg.test(@id)));
			*/	
			return _data.grade.item.(__reg.test(@id));
		}
		
		//======================================================================================
		//
		//	实例方法 公用类	buildTeacher()、buildStudent()以及他们调用的方法
		//
		//======================================================================================
		
		//===========================================
		//	buildTeacher()	被_projectChangeHandler()和Application._buildFrame()调用
		//===========================================
		/**
		 * 建立教师的步骤，仅当当前用户为学生的时候才进行
		 * */
		private function _buildTeacher($projectID:String):void
		{
			//根据传来的项目id获取当前的项目
			var __project:XML = _data.project.item.(@id==$projectID)[0] as XML;
			var __cnum:int = int(__project.cnum);
			var __isNeedCopartnerInfo:Boolean = (__project.author_need_info == '1');
			//Logger.info('buildTeacher执行，__project：\n{1}', _data.project.item.(@id=$projectID));
			Logger.info('buildTeacher执行，$projectID:{0}',$projectID);			
			stepWorks.moduleFI.visible = _hasModule;
			_catMediator.buildCopartner(__cnum, __isNeedCopartnerInfo);
			stepWorks.teacherBox.visible = true;
			//当项目发生改变的时候 更新IS_NEED_COPARTNER_INFO的值
			sendNotification(ApplicationFacade.SET_CONFIG_IS_NEED_COPARTNER_INFO, __isNeedCopartnerInfo);
			sendNotification(ApplicationFacade.BUILD_TEACHER, $projectID);
		}
		
		//===========================================
		//	buildStudent()	被_projectChangeHandler()和Application._buildFrame()调用
		//===========================================
		/**
		 * 建立学生的步骤，仅当当前用户为学生的时候执行
		 * */
		private function _buildStudent($projectID:String):void
		{
			//根据传来的项目id获取当前的项目
			var __project:XML = _data.project.item.(@id==$projectID)[0] as XML;
			var __cnum:int = int(__project.cnum);
			var __tnum:int = int(__project.tnum);
			var __isNeedCopartnerInfo:Boolean = (__project.author_need_info == '1')
			Logger.info('buildStudent执行，$projectID:{0}',$projectID);
			stepWorks.removeTeacher();
			_catMediator.buildCopartner(__cnum, ConfigProxy.IS_NEED_COPARTNER_INFO);
			_catMediator.buildHelppingTeacher(__tnum);
			//当项目发生改变的时候 更新IS_NEED_COPARTNER_INFO的值
			sendNotification(ApplicationFacade.SET_CONFIG_IS_NEED_COPARTNER_INFO, __isNeedCopartnerInfo);
			sendNotification(ApplicationFacade.BUILD_STUDENT, $projectID);
		}		

		
		private function _getIsTeacher($xml:XML):Boolean
		{
			var __isTeacher:Boolean = $xml.is_teacher == '1';
			sendNotification(ApplicationFacade.SET_CONFIG_IS_TEACHER, __isTeacher);	
			return __isTeacher;
		}
		
		private function _getHasModule($xml:XML):Boolean
		{
			return $xml.@id == '14'
		}
		 
		
		//==========================
		private function debugFill():void
		{
			stepWorks.nameTI.text = '测试作品名称'+Math.random().toString();
			stepWorks.projectCB.selectedIndex = 0;
			stepWorks.groupCB.selectedIndex = 0;
			stepWorks.gradeCB.selectedIndex = 0;
			stepWorks.subjectCB.selectedIndex = 0;
			stepWorks.bookTI.text = '《测试教材名称》'+Math.random().toString();
			stepWorks.moduleCB.selectedIndex = 0;
		}			
		//==========================
	}
}