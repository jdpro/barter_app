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
package troc.objets {
	import flash.errors.IllegalOperationError;

	/**
	 * @author Joachim
	 */
	public class ObjetsFactory {
		public static function donnerObjet(nomObjet : String) : IObjetDeplacable {
			var objet : IObjetDeplacable;
			switch(nomObjet) {
				case EnumObjets.FROMAGE:
					objet = new Fromage();
					break;
				case EnumObjets.PAIN:
					objet = new Pain();
					break;
				case EnumObjets.LAPIN:
					objet = new Lapin();
					break;
				case EnumObjets.HACHE:
					objet = new Hache();
					break;
				case EnumObjets.COQUILLAGE:
					objet = new Coquillage();
					break;
				case EnumObjets.PIOCHE:
					objet = new Pioche();
					break;
				case EnumObjets.POISSON:
					objet = new Poisson();
					break;
				default:
					throw new IllegalOperationError("objet inconnu");
			}
			objet.nom = nomObjet;
			return objet;
		}

		public static function rendre(objet : IObjetDeplacable) : void {
			if (objet.sprite.parent) objet.sprite.parent.removeChild(objet.sprite);
			// TODO remettre dans le pool
		}
	}
}
