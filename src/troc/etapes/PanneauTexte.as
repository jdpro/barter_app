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
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormatAlign;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Joachim
	 */
	public class PanneauTexte extends Sprite {
		private static const LARGEUR_TITRE : Number = 200;
		private static const HAUTEUR : Number = 470;
		private static const RAYON : Number = 20;
		private static const PADDING_ZONE_TITRE : Number = 20;
		private static const MARGE_SUP_ZONE_TEXTE : Number = 10;
		private static const MARGE_INF_ZONE_CONSIGNE : Number = 80;
		private var zoneTitre : TextField;
		[Embed(source="../../../assets/fonts/AlteHaasGroteskRegular.ttf", fontFamily="AlteHaasGroteskRegular", embedAsCFF=false)]
		private var AlteHaasGroteskRegular : Class;
		private static var police : Font;
		private var zoneTexte : TextField;
		private var zoneConsigne : TextField;

		public function PanneauTexte() {
			police = new AlteHaasGroteskRegular();

			creerZoneTitre();
			creerZoneTexte();
			creerZoneConsigne();
			dessinerFond();
			filters = [new DropShadowFilter()];
		}

		private function dessinerFond() : void {
			graphics.beginFill(0xcccccc);
			graphics.lineStyle(0, 0x000000, 0, true);
			graphics.drawRoundRect(0, 0, LARGEUR_TITRE + 2 * PADDING_ZONE_TITRE, HAUTEUR, RAYON);
		}

		private function creerZoneTitre() : void {
			zoneTitre = new TextField();
			zoneTitre.selectable = false;
			zoneTitre.embedFonts = true;
			zoneTitre.multiline = true;
			zoneTitre.wordWrap = true;
			zoneTitre.width = LARGEUR_TITRE;
			zoneTitre.autoSize = TextFieldAutoSize.LEFT;
			zoneTitre.defaultTextFormat = new TextFormat(police.fontName, 22, 0x000000, true);
			addChild(zoneTitre);
			zoneTitre.y = PADDING_ZONE_TITRE;
			zoneTitre.x = PADDING_ZONE_TITRE;
		}

		private function creerZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.selectable = false;
			zoneTexte.embedFonts = true;
			zoneTexte.multiline = true;
			zoneTexte.wordWrap = true;
			zoneTexte.width = LARGEUR_TITRE;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.defaultTextFormat = new TextFormat(police.fontName, 18, 0x333333);
			addChild(zoneTexte);

			zoneTexte.x = PADDING_ZONE_TITRE;
		}

		private function creerZoneConsigne() : void {
			zoneConsigne = new TextField();
			zoneConsigne.selectable = false;
			zoneConsigne.embedFonts = true;
			zoneConsigne.multiline = true;
			zoneConsigne.wordWrap = true;
			zoneConsigne.border = true;
			zoneConsigne.borderColor = 0xFFFFFF;
			zoneConsigne.width = LARGEUR_TITRE;
			zoneConsigne.autoSize = TextFieldAutoSize.LEFT;
			zoneConsigne.defaultTextFormat = new TextFormat(police.fontName, 16, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER);
			addChild(zoneConsigne);

			zoneConsigne.x = PADDING_ZONE_TITRE;

			zoneConsigne.text = "Déplacez les produits pour satisfaire les besoins exprimés par les personnages.";
			zoneConsigne.y = HAUTEUR - MARGE_INF_ZONE_CONSIGNE - zoneConsigne.textHeight;
		}

		public function afficherTitre(titre : String) : void {
			zoneTitre.text = titre;
			zoneTexte.y = zoneTitre.getBounds(this).bottom + MARGE_SUP_ZONE_TEXTE;
		}

		public function afficherTexte(texte : String) : void {
			zoneTexte.text = texte;
		}
	}
}
