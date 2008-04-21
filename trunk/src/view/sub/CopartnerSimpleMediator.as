package view.sub
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.interfaces.ICopartner;
	import view.sub.component.CopartnerSimple;

	public class CopartnerSimpleMediator extends Mediator implements ICopartner
	{
		public static const NAME:String = 'CopartnerSimpleMediator';
		
		public function CopartnerSimpleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get copartner():CopartnerSimple
		{
			return viewComponent as CopartnerSimple;
		}
		
		public function set index($index:int):void{}
		public function getVariable():String
		{
			return copartner.nameTI.text;
		}
			
		public function setVariable($name:XML):void
		{
			copartner.nameTI.text = $name.name;
		}
	
	}
}