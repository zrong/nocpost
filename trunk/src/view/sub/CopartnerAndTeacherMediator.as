package view.sub
{
	import model.GetInfoProxy;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.interfaces.ICopartner;
	import view.sub.component.CopartnerAndTeacher;
	import view.sub.component.CopartnerSimple;

	public class CopartnerAndTeacherMediator extends Mediator
	{
		public static const NAME:String = 'CopartnerAndTeacherMediator';
		
		private var _copartnerArray:Array;
		private var _helppingTeacherArray:Array;
		
		private var _data:XML;
		
		public function CopartnerAndTeacherMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_data = (facade.retrieveProxy(GetInfoProxy.NAME) as GetInfoProxy).getData() as XML;
		}
		
		private function get cat():CopartnerAndTeacher
		{
			return viewComponent as CopartnerAndTeacher;
		}
		
		//===========================================
		//	_fillCopartnerAndHelppingTeacher()	供update()方法调用
		//===========================================
		/**
		 * 修改状态下填写参赛者和辅导教师的值
		 * */
		public function fillCopartnerAndHelppingTeacher():void
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
		//	buildTeacher()	被_projectChangeHandler()和Application._buildFrame()调用
		//===========================================
		/**
		 * 建立教师的步骤，仅当当前用户为学生的时候才进行
		 * */
		public function buildTeacher($project:XML):void
		{
			_removeCAT();
			//根据传来的项目id获取当前的项目
			var __isNeedCopartnerInfo:Boolean = _getIsNeedCopartnerInfo($project);
			var __cnum:int = int($project.cnum);			
			//Logger.info('buildTeacher执行，__project：\n{1}', _data.project.item.(@id=$projectID));
			Logger.info('buildTeacher执行，$project:{0}',$project);			
			if(__isNeedCopartnerInfo)
			{
				_buildCopartnerComplex(__cnum)
			}
			else
			{
				_buildCopartnerSimple(__cnum);
			}
			//当项目发生改变的时候 更新IS_NEED_COPARTNER_INFO的值			
			sendNotification(ApplicationFacade.BUILD_TEACHER, $project);
		}
		
		//===========================================
		//	buildStudent()	被_projectChangeHandler()和Application._buildFrame()调用
		//===========================================
		/**
		 * 建立学生的步骤，仅当当前用户为学生的时候执行
		 * */
		public function buildStudent($project:XML):void
		{
			_removeCAT();
			//根据传来的项目id获取当前的项目
			var __isNeedCopartnerInfo:Boolean = _getIsNeedCopartnerInfo($project);
			var __cnum:int = int($project.cnum);
			var __tnum:int = int($project.tnum);
			Logger.info('buildStudent执行，$project:{0}',$project);
			_buildCopartnerSimple(__cnum);
			_buildHelppingTeacher(__tnum);
			//当项目发生改变的时候 更新IS_NEED_COPARTNER_INFO的值
			sendNotification(ApplicationFacade.BUILD_STUDENT, $project);
		}	
		
		//===========================================
		//	buildCopartner()	被buildStudent()、buildTeacher()调用
		//===========================================
		/**
		 * 根据数量建立简单的合作参赛者输入框
		 * @$cnum 参赛者的数量
		 * */
		private function _buildCopartnerSimple($cnum:int):void
		{
			Logger.info('_buildCopartnerSimple执行 ');
			_copartnerArray = new Array();
			//_copartnerTile.height = ($needInfo ? 500 : 80);	//如果要显示详细信息 那么高度要更多些
			//_copartnerTile.tileWidth = ($needInfo ? 600 : 165);
			Logger.info('copartnerTile.height:{0},titleWidth:{1}', cat.copartnerTile.height, cat.copartnerTile.tileWidth);
			cat.copartnerTile.removeAllChildren();
			if($cnum > 0)
			{			
				for(var i:int=0; i< $cnum; i++)
				{
					//是否显示详细信息，生成的填写合作者信息的表单是不同的
					var __mediatorName:String = CopartnerSimple.NAME + i.toString();
					var __copartner:CopartnerSimple = new CopartnerSimple();;
					var __copartnerMediator:CopartnerSimpleMediator = new CopartnerSimpleMediator(__mediatorName, __copartner);;
					__copartner.label = '合作者'+(i+1);
					copartnerTile.addChild(__copartner);
					facade.registerMediator(__copartnerMediator);
					_copartnerArray.push(__mediatorName);
				}
			}
		}
		
		/**
		 * 根据数量建立复杂的合作参赛者输入框
		 * @$cnum 参赛者的数量
		 * */
		private function _buildCopartnerComplex($cnum:int):void
		{
			Logger.info('_buildCopartnerComplex执行 ');
			_copartnerArray = new Array();
			Logger.info('copartnerTile.height:{0},titleWidth:{1}', cat.copartnerTile.height, cat.copartnerTile.tileWidth);
			cat.copartnerTile.removeAllChildren();
			if($cnum > 0)
			{			
				for(var i:int=0; i< $cnum; i++)
				{
					//是否显示详细信息，生成的填写合作者信息的表单是不同的
					var __copartner:CopartnerComplex = new CopartnerComplex();
					var __mediatorName:String = CopartnerComplexMediator.NAME + i.toString();
					var __copartnerMediator:CopartnerComplexMediator = new CopartnerComplexMediator(__mediatorName, __copartner);
					__copartnerMediator.index = i;
					__copartner.label = '合作者'+(i+1);
					copartnerTile.addChild(__copartner);
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
		private function _buildHelppingTeacher($tnum:int):void
		{
			Logger.info('buildHelppingTeacher执行 ');
			_helppingTeacherArray = new Array();	//清空原来的辅导教师数组
			cat.helppingTeacherTile.percentHeight = 100;
			cat.helppingTeacherTile.tileWidth = 580;
			cat.helppingTeacherTile.removeAllChildren();	//移除当前辅导教师容器中的所有辅导教师
			if($tnum > 0)
			//如果数量大于0，就按照数量在容器中建立辅导教师
			{
				for(var j:int=0; j< $tnum; j++)
				{
					var __id:String = (j+1).toString();
					var __mediatorName:String = HelppingTeacherMediator.NAME + __id;
					var __helppingTeacher:HelppingTeacher = new HelppingTeacher();
					__helppingTeacher.label = '辅导教师'+__id;
					cat.helppingTeacherTile.addChild(__helppingTeacher);	//把建立的辅导教师加入显示列表
					facade.registerMediator(new HelppingTeacherMediator(__mediatorName, __helppingTeacher));	//注册辅导教师的Mediator
					_helppingTeacherArray.push(__mediatorName);		//把建立的辅导教师的Mediator名称加入数组，以便于移除辅导教师的时候解除注册
				}
			}	
		}
		
		//===========================================
		//	_removeTile()	被_projectChangeHandler()调用
		//===========================================
		/**
		 * 清空辅导教师容器和参赛者容器中的显示对象
		 * CAT = CopartnerAndTeacher
		 * */
		private function _removeCAT():void
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
			cat.copartnerTile.removeAllChildren();
			cat.helppingTeacherTile.removeAllChildren();
		}
		
		//===========================================
		//	buildCopartnerStringForSubmit()	供buildVariable()方法调用
		//===========================================		
		/**
		 * 返回合作者的数组（字符串形式）
		 * */
		public function buildCopartnerStringForSubmit():String
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
		
		private function _getProject($projectID:String):XML
		{
			return _data.project.item.(@id==$projectID)[0] as XML;
		}
		
		private function _getIsNeedCopartnerInfo($project:XML):Boolean
		{
			var __bool:Boolean = $project.author_need_info == '1';
			sendNotification(ApplicationFacade.SET_CONFIG_IS_NEED_COPARTNER_INFO, __bool);
			return __bool;
		}
		
		//===========================================
		//	_buildHelppingTeacherStrinForSubmit()	供buildVariable()方法调用
		//===========================================
		/**
		 * 返回辅导教师数组（字符串形式）
		 * */
		public function buildHelppingTeacherStrinForSubmit():String
		{
			Logger.info('_buildHelppingTeacherStrinForSubmit调用');
			var __arr:Array = new Array();
			for(var i:int = 0; i<_helppingTeacherArray.length; i++)
			{
				__arr.push((_helppingTeacherArray[i]as HelppingTeacher).getVariable());
			}
			return __arr.join(ConfigProxy.SEPARATOR);
		}
		
	}
}