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
 package troc.etapes {
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import troc.Main;
	import troc.alertes.Alerte;
	import troc.objets.EnumObjets;
	import troc.objets.IObjetDeplacable;
	import troc.objets.ObjetsFactory;
	import troc.personnages.IPersonnage;
	import troc.personnages.PoolPersonnages;
	import troc.synchro.SynchronisationEvent;
	import utils.melanger;




	/**
	 * @author Joachim
	 */
	public class AbstractEtape extends Sprite implements IEtape {
		private static const RAYON_H : Number = 250;
		private static const RAYON_V : Number = 125;
		private static const DUREE_TRANSITION : Number = 48;
		private static const NB_MAX_PERSO_SANS_RECIPOCITE : uint = 7;
		private static const NB_MIN_PAIRES_AVEC_RECIPOCITE : uint = 2;		private static const NB_MAX_PAIRES_AVEC_RECIPOCITE : uint = 4;
		private static const NB_MIN_PERSO_SANS_RECIPOCITE : uint = 3;
		private static const MARGE_H_CADRE : Number = 10;
		private static const MARGE_V_CADRE : Number = 10;
		protected var personnages : Vector.<IPersonnage>;
		private var tweenX : Tween;
		private var objetEnDeplacement : IObjetDeplacable;
		private var personnageVise : IPersonnage;
		private var destinataireContrepartie : IPersonnage;
		protected var titre : String;
		protected var texte : String;		protected var messageFinal : String;
		private var panneauTexte : PanneauTexte;
		protected var alerte : Alerte;

		public function AbstractEtape(panneauTexte : PanneauTexte, alerte : Alerte) {
			this.alerte = alerte;
			this.panneauTexte = panneauTexte;
			addEventListener(Event.ADDED_TO_STAGE, construire);
		}

		private function construire(event : Event) : void {
			personnages = new Vector.<IPersonnage>();
			creerPersonnages();
			disposerPersonnages();
			creerTweenX();
			dessinerFond();
		}

		private function dessinerFond() : void {
			graphics.lineStyle(5, 0xDDDDDD, 1, true);
			var posPanneau : Number = panneauTexte.getBounds(this.parent).right;
			graphics.drawRoundRect(posPanneau + MARGE_H_CADRE, MARGE_V_CADRE, Main.LARGEUR - posPanneau - 2 * MARGE_H_CADRE, Main.HAUTEUR - y - 2 * MARGE_V_CADRE, 20);
		}



		private function creerTweenX() : void {
			tweenX = new Tween(this, 'x', Strong.easeOut, 0, 0, DUREE_TRANSITION);
			tweenX.stop();
		}

		private function disposerPersonnages() : void {
			var angle : Number = Math.PI * 2 / personnages.length;
			var centre : Point = new Point(Main.LARGEUR * 2 / 3 - 20, (Main.HAUTEUR - y) / 2);
			var position : Point;
			var direction : Number;
			var posX : Number;
			var posY : Number;
			for (var i : int = 0; i < personnages.length; i++) {
				direction = -Math.PI + angle * i;
				posX = Math.cos(direction) * RAYON_H;
				posY = Math.sin(direction) * RAYON_V;
				position = new Point(posX, posY);
				position.offset(centre.x, centre.y);
				personnages[i].sprite.x = position.x - personnages[i].sprite.width / 2;
				personnages[i].sprite.y = position.y - personnages[i].sprite.height / 2;
				addChildAt(personnages[i].sprite,0);
			}
		}

		protected function creerPersonnages() : void {
			throw new IllegalOperationError("classe abstraite");
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function gererMouseEvent(event : MouseEvent) : void {
			if (event.type == MouseEvent. MOUSE_DOWN) {
				if (event.target is IObjetDeplacable) {
					objetEnDeplacement = event.target as IObjetDeplacable;
					if (objetEnDeplacement.verrou) return;
					objetEnDeplacement.sprite.startDrag();
					objetEnDeplacement.enregistrerPositionAbsolue(objetEnDeplacement.sprite.getBounds(this).topLeft);
					addChildAt(objetEnDeplacement.sprite, numChildren);
					objetEnDeplacement.sprite.x = objetEnDeplacement.positionAbsolue.x;
					objetEnDeplacement.sprite.y = objetEnDeplacement.positionAbsolue.y;
					remettreTextesDeBase();
				}
			} else if (event.type == MouseEvent. MOUSE_MOVE) {
				if (objetEnDeplacement) {
					controlerSurvol();
				}
			} else if (event.type == MouseEvent. MOUSE_UP) {
				if (objetEnDeplacement) {
					controlerDepot();
				}
			}
		}

		private function remettreTextesDeBase() : void {
			for each (var personnage : IPersonnage in personnages) {
				personnage.remettreTexteDeBase(true);
			}
		}

		private function controlerDepot() : void {
			if (personnageVise) personnageVise.emphaser(false);
			var contrepartie : IObjetDeplacable = contrepartiePossible();
			if (objetEnDeplacement && personnageVise && objetAccepte() && contrepartie) {
				var proprietaire : IPersonnage = objetEnDeplacement.proprietaire;
				var positionContrepartie : Point = contrepartie.sprite.getBounds(this).topLeft;
				contrepartie.enregistrerPositionAbsolue(objetEnDeplacement.positionAbsolue);
				addChildAt(contrepartie.sprite, numChildren);

				contrepartie.sprite.x = positionContrepartie.x;
				contrepartie.sprite.y = positionContrepartie.y;
				contrepartie.sprite.addEventListener(SynchronisationEvent.RETOUR_OBJET_TERMINE, gererArriveeContrepartie);
				destinataireContrepartie = proprietaire;
				contrepartie.retourOrigine();
				objetEnDeplacement.sprite.stopDrag();
				personnageVise.ajouterObjet(objetEnDeplacement);
				if (objetEnDeplacement.nom != EnumObjets.COQUILLAGE) personnageVise.mettreEnEtatSatisfait();
				if (contrepartie.nom != EnumObjets.COQUILLAGE) proprietaire.mettreEnEtatSatisfait();
				gererSucces();
			} else {
				objetEnDeplacement.retourOrigine();
				objetEnDeplacement.sprite.stopDrag();
				objetEnDeplacement.sprite.addEventListener(SynchronisationEvent.RETOUR_OBJET_TERMINE, gererFinRetourObjetInvendu);
				if (objetEnDeplacement && personnageVise && !objetAccepte()) {
					personnageVise.exprimerRefus(objetEnDeplacement);
				}
				if (objetEnDeplacement && personnageVise && !contrepartie && personnageVise.objets.length > 0) {
					objetEnDeplacement.proprietaire.exprimerRefus(personnageVise.objets[0]);
				}
				gererEchec();
			}
			objetEnDeplacement = null;
		}

		protected function gererEchec() : void {
		}

		protected function gererSucces() : void {
		}

		private function gererArriveeContrepartie(event : SynchronisationEvent) : void {
			var objet : IObjetDeplacable = event.target as IObjetDeplacable;
			objet.sprite.removeEventListener(SynchronisationEvent.RETOUR_OBJET_TERMINE, gererArriveeContrepartie);
			destinataireContrepartie.ajouterObjet(objet);
			destinataireContrepartie = null;
		}

		private function objetAccepte() : Boolean {
			return personnageVise.accepte(objetEnDeplacement);
		}

		private function contrepartiePossible() : IObjetDeplacable {
			if (!objetEnDeplacement || !personnageVise) return null;
			for each (var objet : IObjetDeplacable in personnageVise.objets) {
				if (objetEnDeplacement.proprietaire.accepte(objet)) return objet;
			}
			return null;
		}

		private function gererFinRetourObjetInvendu(event : SynchronisationEvent) : void {
			var objet : IObjetDeplacable = event.target as IObjetDeplacable;
			objet.proprietaire.reprendre(objet);
			objet.sprite.removeEventListener(SynchronisationEvent.RETOUR_OBJET_TERMINE, gererFinRetourObjetInvendu);
		}

		private function controlerSurvol() : void {
			personnageVise = null;
			for each (var personnage : IPersonnage in personnages) {
				if (personnage.contact(objetEnDeplacement))
					cibler(personnage);
				else personnage.emphaser(false);
			}
		}

		private function cibler(personnage : IPersonnage) : void {
			personnageVise = personnage;
			personnageVise.emphaser(true);
		}

		public	function sortir(versLaGauche : Boolean) : void {
			tweenX.begin = 0;
			tweenX.finish = Main.LARGEUR * ( versLaGauche ? -1 : 1);
			tweenX.start();
		}

		public	function entrer(depuisLaDroite : Boolean) : void {
			tweenX.begin = Main.LARGEUR * ( depuisLaDroite ? -1 : 1);
			tweenX.finish = 0;
			tweenX.start();
			panneauTexte.afficherTitre(titre);
			panneauTexte.afficherTexte(texte);
		}

		public function reinitialiser() : void {
			rendreRessources();
			creerPersonnages();
			disposerPersonnages();
		}

		private function rendreRessources() : void {
			for each (var personnage : IPersonnage in personnages) {
				while (personnage.objets.length > 0) {
					ObjetsFactory.rendre(personnage.objets.pop());
				}
			}
			while (personnages.length > 0)
				PoolPersonnages.rendrePersonnage(personnages.pop());
		}

		protected function creerPersonnagesAvecReciprocite() : void {
			var nbPersonnages : uint = Math.random() * (NB_MAX_PAIRES_AVEC_RECIPOCITE - NB_MIN_PAIRES_AVEC_RECIPOCITE ) + NB_MIN_PAIRES_AVEC_RECIPOCITE;
			nbPersonnages *= 2;
			for (var i : int = 0; i < nbPersonnages; i++) {
				personnages[i] = PoolPersonnages.donnerPersonnage();
			}
			var perso1 : IPersonnage;
			var perso2 : IPersonnage;
			var objet1 : IObjetDeplacable;
			var objet2 : IObjetDeplacable;
			var numObjets : Array = new Array();
			for ( i = 0; i < nbPersonnages; i++) {
				numObjets.push(i % EnumObjets.OBJETS.length);
			}
			for ( i = 0; i < 20; i++) {
				melanger(numObjets);
			}
			for ( i = 0; i < nbPersonnages ; i += 2) {
				perso1 = personnages[i];
				perso2 = personnages[i + 1];
				objet1 = ObjetsFactory.donnerObjet(EnumObjets.OBJETS[numObjets.pop()]);
				objet2 = ObjetsFactory.donnerObjet(EnumObjets.OBJETS[numObjets.pop()]);
				perso1.ajouterObjet(objet1);
				perso2.ajouterObjet(objet2);
				perso2.fixerObjetSouhaite(objet1.nom);
				perso1.fixerObjetSouhaite(objet2.nom);
			}
			for ( i = 0; i < 20; i++) {
				melanger(personnages);
			}
		}

		protected function creerPersonnagesSansReciprocite(grapheDoitEtreConnexe : Boolean = false) : void {
			var nbPersonnages : uint = Math.random() * (NB_MAX_PERSO_SANS_RECIPOCITE - NB_MIN_PERSO_SANS_RECIPOCITE) + NB_MIN_PERSO_SANS_RECIPOCITE;
			for (var i : int = 0; i < nbPersonnages; i++) {
				personnages[i] = PoolPersonnages.donnerPersonnage();
			}
			var perso : IPersonnage;
			var objet : IObjetDeplacable;
			var numObjets : Array = new Array();
			var numObjetsSouhaites : Array = new Array();
			for ( i = 0; i < nbPersonnages; i++) {
				numObjets.push(i % EnumObjets.OBJETS.length);
			}
			for ( i = 0; i < 20; i++) {
				melanger(numObjets);
			}

			for ( i = 0; i < nbPersonnages ; i += 1) {
				perso = personnages[i];
				objet = ObjetsFactory.donnerObjet(EnumObjets.OBJETS[numObjets.pop()]);
				perso.ajouterObjet(objet);
			}
			do {
				for ( i = 0; i < nbPersonnages; i++) {
					numObjetsSouhaites.push(i % EnumObjets.OBJETS.length);
				}
				for ( i = 0; i < 20; i++) {
					melanger(numObjetsSouhaites);
				}
				for ( i = 0; i < nbPersonnages ; i += 1) {
					objet = ObjetsFactory.donnerObjet(EnumObjets.OBJETS[numObjetsSouhaites.pop()]);
					personnages[i].fixerObjetSouhaite(objet.nom);
				}
			} while (existeReciprocites() || (grapheDoitEtreConnexe && !grapheConnexe()));
			for ( i = 0; i < 20; i++) {
				melanger(personnages);
			}
		}

		private function grapheConnexe() : Boolean {
			var graphe : Array = new Array();
			var nbPersonnages : uint = personnages.length;
			graphe.push(personnages[0]);
			var objet : IObjetDeplacable;
			var client : IPersonnage;
			var continuer : Boolean;
			do {
				continuer = false;
				objet = (graphe[graphe.length - 1] as IPersonnage).objets[0];
				client = null;
				for ( var i : int = 0; i < nbPersonnages; i++) {
					if ((personnages[i] as IPersonnage).accepte(objet)) {
						client = personnages[i] as IPersonnage;
						break;
					}
				}
				if (client && graphe.indexOf(client) == -1) {
					graphe.push(client);
					continuer = true;
				}
			} while (continuer);

			return graphe.length == nbPersonnages;
		}

		private function existeReciprocites() : Boolean {
			for each (var personnage1 : IPersonnage in personnages) {
				for each (var personnage2 : IPersonnage in personnages) {
					if (personnage1.accepte(personnage2.objets[0]) && personnage2.accepte(personnage1.objets[0])) return true;
				}
			}
			return false;
		}

		protected function tousPersonnagesSatisfaits() : Boolean {
			for each (var personnage : IPersonnage in personnages) {
				if (!personnage.satisfait) return false;
			}
			return true;
		}
	}
}
