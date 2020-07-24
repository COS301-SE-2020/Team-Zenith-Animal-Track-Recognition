import { Component, OnInit, Input } from '@angular/core';
import { Ranger } from './../../../models/ranger';
import { RANGERS } from './../../../models/mock-rangers';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-animal-search-sidenav',
  templateUrl: './animal-search-sidenav.component.html',
  styleUrls: ['./animal-search-sidenav.component.css']
})
export class AnimalSearchSidenavComponent implements OnInit {

//USING MOCK RANGER DATA. @Zach please replace this with an API call that fetches the users. We only need ID, Name, Username and ranger level

	animals;
	currentAlphabet;
	surnames: boolean = true;
	levels: boolean = false;
	
		@Input() searchText: string;
		
  constructor(private http: HttpClient) { }

  ngOnInit(): void {
	  document.getElementById("animals-route").classList.add("activeRoute");
  }
  printOut(temp: any) {
		this.animals = temp[0];
		this.sort(true);
	}

	checkIfNew(title: string, pos: number) {
		if (this.currentAlphabet === ("" + title).charAt(pos).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).charAt(pos).toLowerCase();
			return true;
		}
	}

	toggle(bool: boolean) {
		this.surnames = bool;
		this.levels = !bool;
		this.sort(bool);
	}

	sort(bool: boolean) {
		if (bool) {
			for (let i = 0; i < this.animals.length - 1; i++) {
				for (let j = i + 1; j < this.animals.length; j++) {
					if (this.animals[i].lastName.toUpperCase() > this.animals[j].lastName.toUpperCase()) {
						let temp = this.animals[i];
						this.animals[i] = this.animals[j];
						this.animals[j] = temp;
					}
				}
			}
		} else {
			for (let i = 0; i < this.animals.length - 1; i++) {
				for (let j = i + 1; j < this.animals.length; j++) {
					if (this.animals[i].Access_Level > this.animals[j].Access_Level) {
						let temp = this.animals[i];
						this.animals[i] = this.animals[j];
						this.animals[j] = temp;
					}
				}
			}
		}
	}

}
