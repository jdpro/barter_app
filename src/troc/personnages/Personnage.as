 /**
 * Copyright (c) 2012 Joachim DORNBUSCH (code) Wahid MENDIL (graphism)
 * Troc is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * at your option) any later version.
 * Troc is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Troc.  If not, see <http://www.gnu.org/licenses/>.
 **/
 package troc.personnages {
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import troc.Couleurs;
	import troc.objets.EnumObjets;
	import troc.objets.IObjetDeplacable;


	/**
	 * @author Joachim
	 */
	public class Personnage extends Sprite implements IPersonnage {
		private static const LARGEUR_PERSONNAGES : Number = 75;
		private static var filtre : GlowFilter = new GlowFilter();
		private var _objets : Vector.<IObjetDeplacable> ;
		private var nomObjetSouhaite : String;
		private var zoneTexte : TextField;
		[Embed(source="../../../assets/fonts/Burbin Casual NC.ttf", fontFamily="Burbin Casual NC", embedAsCFF=false)]
		private var Burbin : Class;
		private static var police : Font;
		public var content : Sprite;
		public var pasContent : Sprite;
		private var _iconeVisible : Sprite;
		private var texteInitial : String;
		private var texteAAfficher : String;
		private var texteDeBase : String;
		private static const TEXTE_FINAL : String = "J'ai obtenu ce que je voulais";
		private var _satisfait : Boolean;
		private var couleurTexte : uint;
		private var _objetSouhaiteDetermine : Boolean;

		public function Personnage() {
			redimensionner();
			_objets = new Vector.<IObjetDeplacable>();
			_objetSouhaiteDetermine=false;
			police = new Burbin();
			actualiserHumeur();
			cacheAsBitmap = true;
		}

		private function redimensionner() : void {
			content.scaleX = LARGEUR_PERSONNAGES / content.width;
			pasContent.scaleX = LARGEUR_PERSONNAGES / pasContent.width;
			content.scaleY = content.scaleX;
			pasContent.scaleY = pasContent.scaleX;
		}

		public function ajouterObjet(objet : IObjetDeplacable) : void {
			if (objet.proprietaire) {
				objet.proprietaire.retirerObjet(objet);
			}
			_objets.push(objet);
			addChildAt(objet.sprite, numChildren);
			objet.assignerProprietaire(this);
			actualiserPositions();
			actualiserHumeur();
		}

		private function actualiserHumeur() : void {
			var satisfaction : Boolean = detientObjetSouhaite();
			content.visible = satisfaction;
			pasContent.visible = !satisfaction;
			_iconeVisible = satisfaction ? content : pasContent;
			_iconeVisible.filters = [];
		}

		private function detientObjetSouhaite() : Boolean {
			for each (var objet : IObjetDeplacable in objets) {
				if (objet.nom == nomObjetSouhaite) return true;
			}
			return false;
		}

		private function actualiserPositions() : void {
			var curseur : Number = getChildAt(0).height;
			for (var i : int = 0; i < _objets.length; i++) {
				curseur -= _objets[i].sprite.height;
				_objets[i].sprite.y = curseur;
				_objets[i].sprite.x = LARGEUR_PERSONNAGES - 15;
			}
		}

		public function fixerObjetSouhaite(nomObjet : String) : void {
			_objetSouhaiteDetermine=true;
			this.nomObjetSouhaite = nomObjet;
			texteInitial = "J'ai besoin " + nomObjetSouhaite;
			texteDeBase = texteInitial;
			remettreTexteDeBase(true);
		}

		private function afficherTexte(string : String, immediatement : Boolean = false) : void {
			if (!zoneTexte) creerZoneTexte();
			removeEventListener(Event.ENTER_FRAME, afficherLettre);
			var format : TextFormat = zoneTexte.getTextFormat();
			format.color = couleurTexte;
			zoneTexte.defaultTextFormat=format;
			if (immediatement) zoneTexte.text = string;
			else {
				zoneTexte.text = "";
				texteAAfficher = string + ".";
				addEventListener(Event.ENTER_FRAME, afficherLettre);
			}
			
		}

		private function afficherLettre(event : Event) : void {
			if (texteAAfficher.length > 0) {
				zoneTexte.appendText(texteAAfficher.charAt(0));
				texteAAfficher = texteAAfficher.substring(1);
			} else removeEventListener(Event.ENTER_FRAME, afficherLettre);
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.selectable = false;
			zoneTexte.embedFonts = true;
			zoneTexte.multiline = true;
			zoneTexte.wordWrap = true;
			zoneTexte.background = false;
			zoneTexte.backgroundColor=Couleurs.TEXTE_FOND;
			zoneTexte.width = LARGEUR_PERSONNAGES*2;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.defaultTextFormat = new TextFormat(police.fontName, 18, 0x000000);
			addChildAt(zoneTexte,1);
			zoneTexte.y = height;
		}

		public function emphaser(boolean : Boolean) : void {
			_iconeVisible.filters = boolean ? [filtre] : [];
		}

		public function contact(objetEnDeplacement : IObjetDeplacable) : Boolean {
			return _iconeVisible.hitTestObject(objetEnDeplacement.sprite);
		}

		public function accepte(objet : IObjetDeplacable) : Boolean {
			return objet.nom == nomObjetSouhaite || objet.nom == EnumObjets.COQUILLAGE ;
		}

		public function reprendre(objet : IObjetDeplacable) : void {
			addChild(objet.sprite);
			actualiserPositions();
		}

		public function get objets() : Vector.<IObjetDeplacable> {
			return _objets;
		}

		public function retirerObjet(objet : IObjetDeplacable) : void {
			var index : int = objets.indexOf(objet);
			if (index == -1)
				throw new IllegalOperationError("je ne peux pas donner un objet que je n'ai pas : " + objet.nom);
			objets.splice(index, 1);
			actualiserPositions();
			actualiserHumeur();
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function get iconeVisible() : Sprite {
			return _iconeVisible;
		}

		public function exprimerRefus(objetEnDeplacement : IObjetDeplacable) : void {
			couleurTexte = Couleurs.TEXTE_REFUS;
			afficherTexte(texteInitial + " pas " + objetEnDeplacement.nom);
		}

		public function mettreEnEtatSatisfait() : void {
			_satisfait = true;
			texteDeBase = TEXTE_FINAL;
			remettreTexteDeBase(false);
		}

		public function remettreTexteDeBase(immediatement : Boolean) : void {
			couleurTexte = _satisfait ? Couleurs.TEXTE_SATISFAIT : Couleurs.TEXTE_PAS_SATISFAIT;
			afficherTexte(texteDeBase, immediatement);
		}

		public function reinitialiser() : void {
			_satisfait = false;
		}

		public function get satisfait() : Boolean {
			return _satisfait;
		}
	}
}
