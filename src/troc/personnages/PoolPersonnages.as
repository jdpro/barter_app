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
	import flash.errors.IllegalOperationError;

	/**
	 * @author Joachim
	 */
	public class PoolPersonnages {
		private static var pool : Array = new Array();
		private static const NB_TYPES_PERSONNAGES : uint = 3;

		public static function donnerPersonnage() : IPersonnage {
			if (pool.length == 0) return creerNouveauPersonnage();
			else
				return pool.pop();
		}

		private static function creerNouveauPersonnage() : IPersonnage {
			var i : uint = Math.random() * NB_TYPES_PERSONNAGES;
			var nouveauPersonnage : IPersonnage;
			switch(i) {
				case 0:
					return new Personnage1();
					break;
				case 1:
					return new Personnage2();
					break;
				case 2:
					return new Personnage3();
					break;
				default:
					throw new IllegalOperationError("Le personnage demandé n'existe pas");
			}
			return nouveauPersonnage;
		}

		public static function rendrePersonnage(personnage : IPersonnage) : void {
			if (personnage.sprite.parent) personnage.sprite.parent.removeChild(personnage.sprite);
			personnage.reinitialiser();
			pool.push(personnage);
		}
	}
}
