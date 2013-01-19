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

	/**
	 * @author Joachim
	 */
	public class Etape1 extends AbstractEtape {

		public function Etape1(panneau : PanneauTexte, alerte : Alerte) {
			titre = "Situation 1 : Réciprocité des besoins, sans monnaie (troc)";
			texte = "Les participants pratiquent le troc. Ils cherchent à se procurer le produit dont ils ont besoin. Dans cette situation, l’échange est-il possible? ";
			messageFinal = "Dans cette situation simple, où les besoins des participants coïncident, le troc a permis de réaliser les échanges. Utilisez le bouton pour passer à l'étape suivante.";
			super(panneau, alerte);
		}

		override protected function creerPersonnages() : void {
			creerPersonnagesAvecReciprocite();
		}

		override protected function gererSucces() : void {
			if(tousPersonnagesSatisfaits()) {
				alerte.afficher(messageFinal, Alerte.MESSAGE_FINAL);
			}
		}

		


	}
}
