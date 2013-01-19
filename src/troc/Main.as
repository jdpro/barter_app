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
package troc {
	import widgets.boutons.Back;
	import decors.Bandeau;

	import troc.alertes.Alerte;
	import troc.etapes.Etape1;
	import troc.etapes.Etape2;
	import troc.etapes.Etape3;
	import troc.etapes.IEtape;
	import troc.etapes.PanneauTexte;

	import widgets.boutons.Loop;
	import widgets.boutons.Play;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;


	/**
	 * @author Joachim
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="950", height="600")]
	public class Main extends MovieClip {
		private static const MARGE_LATERALE_BOUTONS_BORD : Number = 20;
		private static const MARGE_INF_BOUTONS_BORD : Number = 25;
		private static const LARGEUR_BOUTONS : Number = 50;
		private static const MARGE_Y_PANNEAU_TEXTE : Number = 10;
		private static const MARGE_X_PANNEAU_TEXTE : Number = 20;
		private var etapes : Vector.<IEtape> ;
		private var etapeCourante : IEtape;
		private var bandeau : Bandeau;
		private var boutonPlay : Play;
		private var boutonBack : Back;
		private var numeroEtape : int;
		private var numeroEtapePrecedente : int;
		private var boutonLoop : Loop;
		private var panneauTexte : PanneauTexte;
		private var alerte : Alerte;
		public static const LARGEUR : uint = 950;
		public static const HAUTEUR : uint = 600;

		public function Main() {
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			mettreBandeau();
			mettrePanneauTexte();
			mettreBoutons();
			creerAlerte();
			numeroEtape = -1;
			etapes = new Vector.<IEtape>(3);
			fixerEtape(0);

			root.addEventListener(MouseEvent.MOUSE_DOWN, gererMouseEvent);
			root.addEventListener(MouseEvent.MOUSE_MOVE, gererMouseEvent);
			root.addEventListener(MouseEvent.MOUSE_UP, gererMouseEvent);
		}

		private function creerAlerte() : void {
			alerte = new Alerte();
			addChild(alerte);
		}

		private function fixerEtape(i : int) : void {
			numeroEtapePrecedente = numeroEtape;
			numeroEtape = i;
			actualiserEtape();
		}

		private function mettreBoutons() : void {
			var margeEntreBoutons : Number = (panneauTexte.width - 3 * LARGEUR_BOUTONS - 2 * MARGE_LATERALE_BOUTONS_BORD) / 2;
			boutonPlay = new Play();
			boutonBack = new Back();
			boutonLoop = new Loop();
			addChild(boutonPlay);
			addChild(boutonBack);
			addChild(boutonLoop);
			boutonPlay.width = boutonLoop.width = boutonBack.width = LARGEUR_BOUTONS;
			boutonLoop.scaleX = boutonPlay.scaleX = boutonPlay.scaleX;
			boutonLoop.scaleY = boutonBack.scaleY = boutonPlay.scaleY = boutonPlay.scaleX;
			boutonBack.x = MARGE_X_PANNEAU_TEXTE + MARGE_LATERALE_BOUTONS_BORD + LARGEUR_BOUTONS / 2;
			boutonLoop.x = boutonBack.getBounds(this).right + margeEntreBoutons + LARGEUR_BOUTONS / 2;
			boutonPlay.x = boutonLoop.getBounds(this).right + margeEntreBoutons + LARGEUR_BOUTONS / 2;
			boutonLoop.y = boutonPlay.y = boutonBack.y = Main.HAUTEUR - boutonPlay.height - MARGE_INF_BOUTONS_BORD;
		}

		private function mettreBandeau() : void {
			bandeau = new BandeauAnimationTroc();
			addChild(bandeau);
		}

		private function gererMouseEvent(event : MouseEvent) : void {
			if (traitementDirect(event)) return;
			etapeCourante.gererMouseEvent(event);
		}

		private function traitementDirect(event : MouseEvent) : Boolean {
			if (event.type == MouseEvent.MOUSE_DOWN && event.target is SimpleButton) {
				if (event.target == boutonPlay && boutonPlay.enabled) {
					fixerEtape(numeroEtape + 1);
				} else if (event.target == boutonBack && boutonBack.enabled) {
					fixerEtape(numeroEtape - 1);
				} else if (event.target == boutonLoop) {
					etapeCourante.reinitialiser();
				}
				return true;
			} else if (event.type == MouseEvent.MOUSE_DOWN && event.target == alerte) {
				alerte.masquer();
				return true;
			}
			return false;
		}

		private function actualiserEtape() : void {
			if (!etapes[numeroEtape]) creerEtape(numeroEtape);
			if (etapeCourante && contains(etapeCourante.sprite)) {
				etapeCourante.sortir(numeroEtape > numeroEtapePrecedente);
			}
			etapeCourante = etapes[numeroEtape];
			addChildAt(etapeCourante.sprite, 0);
			etapeCourante.entrer(numeroEtape < numeroEtapePrecedente);
			boutonBack.enabled = numeroEtape != 0;
			boutonPlay.enabled = numeroEtape != 2;
			boutonBack.alpha = boutonBack.enabled ? 1 : 0.5;
			boutonPlay.alpha = boutonPlay.enabled ? 1 : 0.5;
			alerte.masquer();
		}

		private function creerEtape(numero : int) : void {
			var nouvelleEtape : IEtape;
			switch(numero) {
				case 0:
					nouvelleEtape = new Etape1(panneauTexte, alerte);
					break;
				case 1:
					nouvelleEtape = new Etape2(panneauTexte, alerte);
					break;
				case 2:
					nouvelleEtape = new Etape3(panneauTexte, alerte);
					break;
			}
			etapes[numero] = nouvelleEtape;
			nouvelleEtape.sprite.y = bandeau.getBounds(this).bottom;
		}

		private function mettrePanneauTexte() : void {
			panneauTexte = new PanneauTexte();
			addChild(panneauTexte);
			panneauTexte.x = MARGE_X_PANNEAU_TEXTE;
			panneauTexte.y = MARGE_Y_PANNEAU_TEXTE + bandeau.getBounds(this).bottom;
		}
	}
}
