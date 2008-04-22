package view.sub
{
	import model.GetInfoProxy;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.sub.component.CopartnerAndTeacher;
	
	import view.interfaces.ICopartner;

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
			//_copartnerTile.height = ($needInfo ? 500 : 80);	//如果要显示详细信息 那么高度要更多些
			//_copartnerTile.tileWidth = ($needInfo ? 600 : 165);
			Logger.info('copartnerTile.height:{0},titleWidth:{1}', cat.copartnerTile.height, cat.copartnerTile.tileWidth);
			cat.copartnerTile.removeAllChildren();
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
		public function buildHelppingTeacher($tnum:int):void
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
		public function removeCAT():void
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