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
	import troc.alertes.Alerte;
	import troc.objets.EnumObjets;
	import troc.objets.ObjetsFactory;

	/**
	 * @author Joachim
	 */
	public class Etape3 extends AbstractEtape {
		public function Etape3(panneau : PanneauTexte, alerte:Alerte) {
			titre = "Situation 3 : Non-réciprocité des besoins, avec monnaie";
			texte = "Les participants ont convenu d'utiliser un coquillage comme intermédiaire dans les échanges. Dans cette situation, l’échange est-il possible? ";
			messageFinal = "En utilisant un objet comme intermédiaire, les participants sont parvenus à réaliser des échanges qui n'auraient pas pu l'être par simple troc. La monnaie apparaît ici comme moyen de circulation.";
			super(panneau, alerte);
		}

		override protected function creerPersonnages() : void {
			creerPersonnagesSansReciprocite(true);
			var numPersonnageAuHasard : uint = uint(Math.random() * personnages.length);
			personnages[numPersonnageAuHasard].ajouterObjet(ObjetsFactory.donnerObjet(EnumObjets.COQUILLAGE));
		}
		override protected function gererSucces() : void {
			if(tousPersonnagesSatisfaits()) {
				alerte.afficher(messageFinal, Alerte.MESSAGE_FINAL);
			}
		}
	}
}
