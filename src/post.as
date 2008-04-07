import common.StepText;
import common.SubmitPanel;

import flash.net.URLVariables;

import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import net.zengrong.utils.Logger;

import utils.Config;
import utils.Output;
import utils.type.*;

[Bindable]
private var info:XML;
private var _urlVar:URLVariables = new URLVariables();
private var _submit:SubmitPanel;

private function init():void
{
	var __param:Object = Application.application.parameters; 
	Config.URL = __param.config;
	Config.USER_TYPE = __param.user_type;
	Config.PDT_ID = __param.pdt_id;
	Config.MOD_TYPE = __param.mod_type;
	
	Config.IS_MODIFY = Config.MOD_TYPE == ModeType.MODIFY;
	Config.IS_USER = Config.USER_TYPE == UserType.USER;
	//====================调试信息
	Config.IS_MODIFY = false;
	Config.URL = '../assets/get_info.xml';
	//Config.URL = 'http://10.2.1.3/noc/zpsc/zp_upload_deal_all.php?mod_step=step_get_info';
	//Config.URL = 'http://10.2.1.3/noc/zpsc/zp_upload_deal_all.php?mod_step=step_get_info&pdt_id=2&mod_type=mod';
	Config.USER_TYPE = '99';
	Config.PDT_ID = '2';
	//=====================
	configRequest.url = Config.URL;	
	var __var:URLVariables = new URLVariables();
	__var[StepType.STEP_NAME] = StepType.STEP_GET_INFO;
	__var.pdt_id = Config.PDT_ID;
	__var.mod_type = Config.MOD_TYPE;
	send(__var);
}

public function send($var:URLVariables):void
{
	Logger.info('提交的var：\n{1}', $var);
	try{
		configRequest.send($var);
	}
	catch(err:Error)
	{
		Output.alert(err.toString());
		Logger.debug(err.toString());
	}
}

public function submit():void
{
	_submit = PopUpManager.createPopUp(this, SubmitPanel, true) as SubmitPanel;
	_submit.url = Config.URL;
	PopUpManager.centerPopUp(_submit);
	_submit.send();
}

private function configResultHandler(evt:ResultEvent):void
{
	Logger.info('HTTP提交返回成功');
	Config.CONFIG_DATA = evt.result as XML;
	info = evt.result as XML;
	Logger.info(info);
	_buildFrameFromModeTypeAndUserType(Config.IS_MODIFY, Config.IS_USER);
	navBTN.acceptBTN.enabled = true;
}

private function configFaultHandler(evt:FaultEvent):void
{
	Logger.info('HTTP提交返回失败：\n{1}\n{2}{3}',evt.fault.getStackTrace(), evt.messageId, evt.message);
	Output.alert(evt.fault.message+"\n"+evt.message.toString());
}

/**
 * 根据当前的用户类型（管理员或参赛者）和修改类型（添加或修改）建立第一步和第二步表单。
 * 表单的第一步（基本信息）和第二步（作品信息）是所有用户都有的
 * @$modType	修改类型
 * @userType	用户类型
 * @isTeacher	是否是教师
 * @cNum		参与者数量
 * @tNum		辅导教师数量（仅当参与者为学生时）
 * */
private function _buildFrameFromModeTypeAndUserType($isModify:Boolean, $isUser:Boolean):void
{
	Logger.info('_buildFrameFromModeTypeAndUserType运行，$isModify:{1}', $isModify);
	var __project:XML;
	if($isModify)
	//如果是修改模式，那就不必检测用户类型了。因为修改功能只有管理员才有	
	{
		__project = info.project.item.(@id==info.mod_content.pdt_kind)[0] as XML;
		//根据修改信息中提供的项目id值获取当前用户选择的项目值
		 Config.IS_NEED_COPARTNER_INFO = (__project.author_need_info == '1');
		_buildFrame(__project);
	}
	else
	//如果是增加模式，就要先检查用户类型
	{		
		if($isUser)
		//如果是参赛用户，就根据教师或者学生 更改第一步和第二步表单
		{
			__project = info.project.item.(@id==info.mod_content.pdt_kind)[0] as XML;
			//根据修改信息中提供的项目id值获取当前用户选择的项目值
			 Config.IS_NEED_COPARTNER_INFO = (__project.author_need_info == '1');
			//根据修改信息中提供的项目id值获取当前用户选择的项目值
			_buildFrame(__project);
		}
		else
		//如果是其他类型（管理员、组委会），先移除教师独有的项目，此类用户的表单由组委会选择的项目决定
		{
			step2.removeTeacher();
		}
	}
	//将配置信息更新，更新必须在step1和step2建立后进行
	step1.update();
	step2.update();
}

private function _buildFrame($project:XML):void
{
	var __projectID:String = $project.@id;
	var __isTeacher:Boolean = $project.is_teacher == '1';
	Logger.info('_buildFrame执行，__project：\n{1}', $project);
	if(__isTeacher)
	//如果是教师项目，就增加教师独有的信息，同时根据教师参加的项目的参与者数量添加参与者字段
	{
		step2.buildTeacher(__projectID);
	}
	else
	//如果是学生项目，就移除教师独有的表单，同时根据学生参加的项目添加参与者与辅导教师相关的字段
	{
		step2.buildStudent(__projectID);
	}
}

/**
 * 建立第一步和第二步表单之后的表单
 * */
public function buildVS($isTeacher:Boolean, $projectID:String):void
{
	Logger.info('buildVS运行');
	removeVS();
	//根据传来的值建立上传列表
	stepUpload.buildUpload($projectID);
	if($isTeacher)
	{
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
		
		stepUpload.label = "<font size='14' color='#ff0000'><b>第五步:上传文件（完成）</b>";
		
		vs.addChildAt(__tStep3, vs.getChildIndex(stepUpload));
		vs.addChildAt(__tStep4, vs.getChildIndex(stepUpload));
		
		__tStep3.update();
		__tStep4.update();
		stepUpload.update();
	}
	else
	{
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
		stepUpload.update();
	}
	Logger.info('建立表单之后的vs子数量：{1}', vs.numChildren);
}

/**
 * 在根据用户类型建立VS之前，必须先将VS还原成初始状态
 * */
private function removeVS():void{
	Logger.info('removeVS运行，删除前的vs子数量：{1}', vs.numChildren);
	var __toRemovedArr:Array = new Array();
	for(var i:int=0; i < vs.numChildren; i++)
	{
		var __step:UIComponent = vs.getChildAt(i) as UIComponent;
		var __isInitStep:Boolean = __step == copyright || __step == step1 || __step == step2 || __step == stepUpload;
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
	Logger.info('removeVS运行，删除后的vs子数量：{1}', vs.numChildren);
}