package view
{
	import flash.events.Event;
	
	import model.ConfigProxy;
	import model.GetInfoProxy;
	import model.vo.StepWorksVO;
	
	import mx.containers.Tile;
	import mx.containers.VBox;
	
	import net.zengrong.logging.Logger;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.component.StepWorks;
	import view.interfaces.ICopartner;
	import view.interfaces.IStep;
	import view.sub.CopartnerComplexMediator;
	import view.sub.CopartnerSimpleMediator;
	import view.sub.HelppingTeacherMediator;
	import view.sub.component.CopartnerComplex;
	import view.sub.component.CopartnerSimple;
	import view.sub.component.HelppingTeacher;
	import view.sub.component.UploadResource;

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
		
		private var _copartnerArray:Array;
		private var _helppingTeacherArray:Array;
		private var _copartnerTile:Tile;
		private var _helppingTeacherTile:Tile;
		
		public function StepWorksMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_getInfoProxy = facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy;
			
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
				_fillCopartnerAndHelppingTeacher();			
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
		//	_fillCopartnerAndHelppingTeacher()	供update()方法调用
		//===========================================
		/**
		 * 修改状态下填写参赛者和辅导教师的值
		 * */
		private function _fillCopartnerAndHelppingTeacher():void
		{
			Logger.info('_fillCopartnerAndHelppingTeacher执行！');
			//是否需要合作者的详细信息。合作者的详细信息尽在项目列表为“网络教育团队”的时候才需要
			var __isNeedInfo:Boolean = (_data.project.item.(@id==_data.mod_content.pdt_kind)[0] as XML).author_need_info == '1';
			//如果需要合作者的详细信息，就使用_data.mod_content.pdt_author_other_info，否则使用pdt_author_other
			var __copartners:XMLList = (__isNeedInfo ? _data.mod_content.pdt_author_other_info.item : _data.mod_content.pdt_author_other.item);
			//在修改状态下 还需要为参赛者和辅导教师填充信息				
			for (var i:int=0; i<_copartnerArray.length; i++)
			{
				var __copartnerMediator:ICopartner = facade.retrieveMediator(_copartnerArray[i]);
				__copartnerMediator.setVariable(__copartners[i]);
			}
			if(_isTeacher) return;
			//如果用户是学生，那么为辅导教师填充信息
			var __teacherNum:int = _data.mod_content.pdt_teacher.item.length();				
			Logger.info('__teacherNum <= 0:{0}', __teacherNum <= 0);
			//如果修改的时候，没有提交过辅导教师信息，就不处理
			if(__teacherNum <= 0) return;
			Logger.info('_helppingTeacherArray.length:{0}', _helppingTeacherArray.length);
			for (var j:int=0; j<_helppingTeacherArray.length; j++)
			{
				var __xml:XML = _data.mod_content.pdt_teacher.item[j] as XML;
				//Logger.info('__xml:{0}', __xml);
				//如果先前用户没有辅导教师信息，就不更新辅导教师信息
				if(__xml == null) continue;
				var __helppingTeacherMediator:ICopartner = facade.retrieveMediator(_helppingTeacherArray[j]);
				__helppingTeacherMediator.setVariable(__xml);
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
				__vo.pdt_author_other_info = _buildCopartnerStringForSubmit();
			}
			else
			//如果只需要合作者姓名，就采用pdt_author_other这个变量提交
			{
				__vo.pdt_author_other = _buildCopartnerStringForSubmit();
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
				__vo.pdt_teacher = _buildHelppingTeacherStrinForSubmit();
			}
			
			sendNotification(ApplicationFacade.VAR_UPDATE, __vo);				
		}
		
		//===========================================
		//	_buildCopartnerStringForSubmit()	供buildVariable()方法调用
		//===========================================		
		/**
		 * 返回合作者的数组（字符串形式）
		 * */
		private function _buildCopartnerStringForSubmit():String
		{
			Logger.info('_buildCopartnerStrinForSubmit调用,_copartnerArray.length:{0}', _copartnerArray.length);

			var __arr:Array = new Array();
			var __photoArr:Array = new Array();
			//调试用====================================
			//var __temp:String =_copartnerArray[0].getVariable();
			//var __tmp:ValidationResultEvent = (_copartnerArray[0] as CopartnerInfo).nameV.validate() as ValidationResultEvent;
			//return '';
			//=========================================
			for(var i:int = 0; i<_copartnerArray.length; i++)
			{
				var __mediator:ICopartner = facade.retrieveMediator(_copartnerArray[i]);
				__arr.push(__mediator.getVariable());
				//如果当前的项目需要合作者详细信息，就更新Config中的需要上传的合作者照片的组件
				if(ConfigProxy.IS_NEED_COPARTNER_INFO)
				{
					__photoArr.push((__mediator as CopartnerComplexMediator).photoUW as UploadResource);
				}
			}
			if(ConfigProxy.IS_NEED_COPARTNER_INFO)
			{
				sendNotification(ApplicationFacade.SET_CONFIG_UPLOAD_COPARTNER_PHOTO, __photoArr);
			}
			return __arr.join(ConfigProxy.SEPARATOR);
		}
		
		//===========================================
		//	_buildHelppingTeacherStrinForSubmit()	供buildVariable()方法调用
		//===========================================
		/**
		 * 返回辅导教师数组（字符串形式）
		 * */
		private function _buildHelppingTeacherStrinForSubmit():String
		{
			Logger.info('_buildHelppingTeacherStrinForSubmit调用');
			var __arr:Array = new Array();
			for(var i:int = 0; i<_helppingTeacherArray.length; i++)
			{
				__arr.push((_helppingTeacherArray[i]as HelppingTeacher).getVariable());
			}
			return __arr.join(ConfigProxy.SEPARATOR);
		}
		
		//======================================================================================
		//
		//	实例方法 侦听器类	_projectChangeHandler()、_groupChangeHandler()以及被他们调用的方法
		//
		//======================================================================================
		
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
			
			_removeTile();
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
		
		//===========================================
		//	_removeTile()	被_projectChangeHandler()调用
		//===========================================
		/**
		 * 清空辅导教师容器和参赛者容器中的显示对象
		 * */
		private function _removeTile():void
		{
			//每次改变项目，先要清空这两个数组，因为如果管理员先选择学生，后来又改成教师的项目，
			//这时_helppingTeacherArray就有值了。而针对教师应该是没有值的，因此进行清空
			while(_copartnerArray.length>0)
			//如果建立过辅导教师，就取消mediator的注册
			{
				facade.removeMediator(_copartnerArray.shift());
			}
			while(_helppingTeacherArray.length>0)
			//如果建立过辅导教师，就取消mediator的注册
			{
				facade.removeMediator(_helppingTeacherArray.shift());
			}			
			if(_copartnerTile != null)
			{
				if(stepWorks.contains(_copartnerTile))
				{
					stepWorks.removeChild(_copartnerTile);
				}
			}
			if(_helppingTeacherTile != null)
			{
				if(stepWorks.contains(_helppingTeacherTile))
				{
					stepWorks.removeChild(_helppingTeacherTile);
				}
			}				
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
			buildCopartner(__cnum, __isNeedCopartnerInfo);
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
			buildCopartner(__cnum, ConfigProxy.IS_NEED_COPARTNER_INFO);
			buildHelppingTeacher(__tnum);
			//当项目发生改变的时候 更新IS_NEED_COPARTNER_INFO的值
			sendNotification(ApplicationFacade.SET_CONFIG_IS_NEED_COPARTNER_INFO, __isNeedCopartnerInfo);
			sendNotification(ApplicationFacade.BUILD_STUDENT, $projectID);
		}
		

		
		//===========================================
		//	buildCopartner()	被buildStudent()、buildTeacher()调用
		//===========================================
		/**
		 * 根据数量建立参赛者输入框
		 * @$cnum 参赛者的数量
		 * @$needInfo 参赛者是否需要详细信息
		 * */
		public function buildCopartner($cnum:int, $needInfo:Boolean):void
		{
			Logger.info('buildCopartner执行 ');
			_copartnerArray = new Array();
			if(_copartnerTile == null)
			{
				_copartnerTile = new Tile();
			}
			_copartnerTile.width = 580;
			_copartnerTile.height = ($needInfo ? 500 : 80);	//如果要显示详细信息 那么高度要更多些
			_copartnerTile.tileWidth = ($needInfo ? 600 : 165);
			Logger.info('_copartnerTile.height:{1},titleWidth:{2}', _copartnerTile.height, _copartnerTile.tileWidth);
			if(!stepWorks.contains(_copartnerTile))
			{
				stepWorks.addChild(_copartnerTile);
			}
			_copartnerTile.removeAllChildren();
			if($cnum > 0)
			{			
				for(var i:int=0; i< $cnum; i++)
				{
					//是否显示详细信息，生成的填写合作者信息的表单是不同的
					var __copartner:VBox;
					var __copartnerMediator:ICopartner;
					var __mediatorName:String;
					if($needInfo)
					//如果需要详细信息，同时要提供一个民族的列表
					{
						__mediatorName = CopartnerComplexMediator.NAME + i.toString();
						__copartner = new CopartnerComplex();
						__copartnerMediator = new CopartnerComplexMediator(__mediatorName, __copartner);
						__copartnerMediator.index = i;
					}
					else
					{
						__mediatorName = CopartnerSimple.NAME + i.toString();
						__copartner = new CopartnerSimple();
						__copartnerMediator = new CopartnerSimpleMediator(__mediatorName, __copartner);
					}						
					__copartner.label = '合作者'+(i+1);
					_copartnerTile.addChild(__copartner);
					facade.registerMediator(__copartnerMediator);
					_copartnerArray.push(__mediatorName);
				}
			}
		}
		
		//===========================================
		//	buildHelppingTeacher()	被buildStudent()调用
		//===========================================
		/**
		 * 为学生参赛者建立辅导教师栏目
		 * @$tnum	要建立的辅导教师的数量
		 * */
		public function buildHelppingTeacher($tnum:int):void
		{
			Logger.info('buildHelppingTeacher执行 ');
			_helppingTeacherArray = new Array();	//清空原来的辅导教师数组
			if(_helppingTeacherTile == null)
			//如果没有建立辅导教师容器就建立
			{
				_helppingTeacherTile = new Tile();
				_helppingTeacherTile.width = 580;
				_helppingTeacherTile.height = 180;
				_helppingTeacherTile.tileWidth = 580;
			}
			if(!stepWorks.contains(_helppingTeacherTile))
			//如果建立了辅导教师容器，但容器不在显示列表中，就显示它
			{
				stepWorks.addChild(_helppingTeacherTile);
			}
			_helppingTeacherTile.removeAllChildren();	//移除当前辅导教师容器中的所有辅导教师
			if($tnum > 0)
			//如果数量大于0，就按照数量在容器中建立辅导教师
			{
				for(var j:int=0; j< $tnum; j++)
				{
					var __id:String = (j+1).toString();
					var __mediatorName:String = HelppingTeacherMediator.NAME + __id;
					var __helppingTeacher:HelppingTeacher = new HelppingTeacher();
					__helppingTeacher.label = '辅导教师'+__id;
					_helppingTeacherTile.addChild(__helppingTeacher);	//把建立的辅导教师加入显示列表
					facade.registerMediator(new HelppingTeacherMediator(__mediatorName, __helppingTeacher));	//注册辅导教师的Mediator
					_helppingTeacherArray.push(__mediatorName);		//把建立的辅导教师的Mediator名称加入数组，以便于移除辅导教师的时候解除注册
				}
			}	
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