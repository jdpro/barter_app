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
 package troc.synchro {
	import flash.events.Event;

	/**
	 * @author Joachim
	 */
	public class SynchronisationEvent extends Event {
		public static const RETOUR_OBJET_TERMINE : String = "RETOUR_OBJET_TERMINE";
		public function SynchronisationEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
