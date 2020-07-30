import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

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
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animals(Token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){Classification,Animal_ID,Common_Name,Group_ID{Group_Name},HeightM,HeightF,WeightM,WeightF,Habitats{Habitat_ID},Diet_Type,Life_Span,Gestation_Period,Typical_Behaviour,' +
			'Overview_of_the_animal,Description_of_animal,Pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animals = temp[0];
			});
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

	updateSearchText(event) {
		this.searchText = event;
	}

	refresh() {
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animals(Token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){Classification,Animal_ID,Common_Name,Group_ID{Group_Name},HeightM,HeightF,WeightM,WeightF,Habitats{Habitat_ID},Diet_Type,Life_Span,Gestation_Period,Typical_Behaviour,' +
			'Overview_of_the_animal,Description_of_animal,Pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animals = null;
				this.animals = temp[0];
			});
	}
	
	updateAnimalList(updatedList) {
		if (updatedList == 'update') {
			this.refresh();
		}
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
