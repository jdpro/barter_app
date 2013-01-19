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
	public class Etape2 extends AbstractEtape {
		private var nbEssais : int;
		
		public function Etape2(panneau : PanneauTexte, alerte:Alerte) {
			titre = "Situation 2 : Non-réciprocité des besoins, sans monnaie (troc)";
			texte = "Les participants pratiquent le troc. Ils cherchent à se procurer le produit dont ils ont besoin. Dans cette situation, l’échange est-il possible? ";
			messageFinal="Il n'y a pas de solution : les besoins des participants ne coïncident pas. Le troc ne suffit plus à réaliser les échanges. Passez à l'étape suivante...";
			nbEssais=0;
			super(panneau, alerte);
		}

		override protected function creerPersonnages() : void {
			creerPersonnagesSansReciprocite();
		}

		override protected function gererEchec() : void {
			nbEssais++;
			if (nbEssais >= 3) alerte.afficher(messageFinal, Alerte.MESSAGE_ERREUR);
		}
		override public function reinitialiser() : void {
			super.reinitialiser();
			nbEssais=0;
		}
	}
}
