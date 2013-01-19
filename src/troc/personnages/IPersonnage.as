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
	import troc.objets.IObjetDeplacable;
	import utils.ISprite;


	/**
	 * @author Joachim
	 */
	public interface IPersonnage extends ISprite {
		function ajouterObjet(objet : IObjetDeplacable) : void;

		function retirerObjet(objet : IObjetDeplacable) : void;

		function fixerObjetSouhaite(nomObjet : String) : void;

		function emphaser(boolean : Boolean) : void;

		function contact(objetEnDeplacement : IObjetDeplacable) : Boolean;

		function accepte(objetEnDeplacement : IObjetDeplacable) : Boolean;

		function reprendre(objet : IObjetDeplacable) : void;

		function get objets() : Vector.<IObjetDeplacable>;

		function get iconeVisible() : Sprite;

		function exprimerRefus(objetEnDeplacement : IObjetDeplacable) : void;

		function mettreEnEtatSatisfait() : void;

		function remettreTexteDeBase(immediatement : Boolean) : void;
		
		function reinitialiser() : void ;
		
		function get satisfait() : Boolean;
	}
}
