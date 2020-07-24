import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
	selector: 'app-animals',
	templateUrl: './animals.component.html',
	styleUrls: ['./animals.component.css']
})
export class AnimalsComponent implements OnInit {


	@ViewChild('sidenav') sidenav;

	animals;
	searchText: string;
	currentAlphabet;
	surnames: boolean = true;
	levels: boolean = false;
	test: boolean;

	constructor(private http: HttpClient) { }

	ngOnInit(): void {
		this.test = true;
		document.getElementById("animals-route").classList.add("activeRoute");
	}

	printOut(temp: any) {
		this.animals = temp;
		console.log(this.animals);
	}

	openSidenav() {
		this.sidenav.open();
		document.getElementById("sidenav-open-btn-container").style.transitionDuration = "0.2s";
		document.getElementById("sidenav-open-btn-container").style.left = "-10%";
	}
	closeSidenav() {
		this.sidenav.close();
		document.getElementById("sidenav-open-btn-container").style.transitionDuration = "0.8s";
		document.getElementById("sidenav-open-btn-container").style.left = "0%";
	}


	//Sorting and Filtering
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
					if (this.animals[i].rangerLevel > this.animals[j].rangerLevel) {
						let temp = this.animals[i];
						this.animals[i] = this.animals[j];
						this.animals[j] = temp;
					}
				}
			}
		}
	}

}
