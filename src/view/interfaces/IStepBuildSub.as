package view.interfaces
{
	public interface IStepBuildSub extends IStep
	{
		//参与者和参考教师依靠这个函数生成子界面和mediator
		function buildSub($num:int):void;
		//移除子界面和mediator
		function removeSub():void;
	}
}