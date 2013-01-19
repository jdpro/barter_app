package troc.objets {
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import troc.personnages.IPersonnage;
	import troc.synchro.SynchronisationEvent;





	/**
	 * @author Joachim
	 */
	public class ObjetDeplacable extends Sprite implements IObjetDeplacable {
		private static const DUREE_TRANSITION : Number = 18;
		public var objet : MovieClip;
		private var _nom : String;
		private static const HAUTEUR_OBJETS : Number = 50;
		private var _positionAbsolue : Point;
		private var tweenX : Tween;
		private var tweenY : Tween;
		private var _verrou : Boolean;
		private var _proprietaire : IPersonnage;

		public function ObjetDeplacable() {
			buttonMode = true;
			dimensionner();
			creerTweens();
		}

		private function creerTweens() : void {
			tweenX = new Tween(this, 'x', Strong.easeOut, 0, 0, DUREE_TRANSITION);
			tweenX.stop();
			tweenY = new Tween(this, 'y', Strong.easeOut, 0, 0, DUREE_TRANSITION);
			tweenY.stop();
			tweenX.addEventListener(TweenEvent.MOTION_FINISH, gererFinRetour);
		}

		private function gererFinRetour(event : TweenEvent) : void {
			_verrou = false;
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.RETOUR_OBJET_TERMINE));
		}

		private function dimensionner() : void {
			height = HAUTEUR_OBJETS;
			scaleX = scaleY;
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function get nom() : String {
			return _nom;
		}

		public function set nom(nom : String) : void {
			_nom = nom;
		}

		public function enregistrerPositionAbsolue(position : Point) : void {
			_positionAbsolue = position;
		}

		public function get positionAbsolue() : Point {
			return _positionAbsolue;
		}

		public function retourOrigine() : void {
			_verrou = true;
			tweenX.begin = x;
			tweenY.begin = y;
			tweenX.finish = positionAbsolue.x;
			tweenY.finish = positionAbsolue.y;
			tweenX.start();
			tweenY.start();
		}

		public function get verrou() : Boolean {
			return _verrou;
		}

		public function assignerProprietaire(personnage : IPersonnage) : void {
			_proprietaire = personnage;
		}

		public function get proprietaire() : IPersonnage {
			return _proprietaire;
		}
	}
}
