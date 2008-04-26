package view.sub
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.interfaces.ICopartner;
	import view.sub.component.CopartnerSimple;

	public class CopartnerSimpleMediator extends Mediator implements ICopartner
	{
		public static const NAME:String = 'CopartnerSimpleMediator';
		
		public function CopartnerSimpleMediator($mediatorName:String, viewComponent:Object=null)
		{
			super($mediatorName, viewComponent);
		}
		
		private function get _step():CopartnerSimple
		{
			return viewComponent as CopartnerSimple;
		}
		
		public function set index($index:int):void{}
		
		public function getVariable():String
		{
			return _step.nameTI.text;
		}
			
		public function setVariable($name:XML):void
		{
			_step.nameTI.text = $name.name;
		}
	
	}
}