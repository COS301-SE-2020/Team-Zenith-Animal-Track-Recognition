import { Component, OnInit, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
	selector: 'app-animals',
	templateUrl: './animals.component.html',
	styleUrls: ['./animals.component.css']
})
export class AnimalsComponent implements OnInit {


	@ViewChild('sidenav') sidenav: any;
	animals: any;
	sortByCommonName: boolean = true;
	searchText: string;
	currentAlphabet: any;
	surnames: boolean = true;
	levels: boolean = false;
	test: boolean =  false;

	constructor(private http: HttpClient) { }

	ngOnInit(): void {
		if (document.getElementById("animals-route-link") == null) {
			this.test = true;
			return;
		}
		document.getElementById("animals-route-link").classList.add("activeRoute");
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animals(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){classification,animalID,commonName,groupID{groupName},heightM,heightF,weightM,weightF,habitats{habitatID},dietType,' +
			'lifeSpan,gestationPeriod,typicalBehaviourM{behaviour,threatLevel},typicalBehaviourF{behaviour,threatLevel},animalOverview,animalDescription,pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animals = temp[0];
				this.animals.forEach(animal => {
					const cont: boolean = ('' + animal.animalDescription).includes('.');
					if (cont) {
						animal.animalOverview = ('' + animal.animalDescription).substring(0, ('' + animal.animalDescription).indexOf(' ', ('' + animal.animalDescription).length < 110 ? 0 : 110) + 1) + ' ...';
					} else {
						animal.animalOverview = "No description provided. Please update this animal in the edit animal screen.";
					}
				});
				this.sort(true);
			});

	}

	openSidenav() {
		if (document.getElementById("sidenav-open-btn-container") == null) {
			this.test = true;
			return;
		}
		this.sidenav.open();
		document.getElementById("sidenav-open-btn-container").style.transitionDuration = "0.2s";
		document.getElementById("sidenav-open-btn-container").style.left = "-10%";
	}
	closeSidenav() {
		if (document.getElementById("sidenav-open-btn-container") == null) {
			this.test = true;
			return;
		}
		this.sidenav.close();
		document.getElementById("sidenav-open-btn-container").style.transitionDuration = "0.8s";
		document.getElementById("sidenav-open-btn-container").style.left = "0%";
	}

	updateSearchText(event) {
		this.searchText = event;
	}

	refresh(updateOp: string) {
		if(updateOp == 'te57ca53t0t3s7a11ex7r3me71e5'){
			this.test = true;			
			return;
		}
		if(updateOp == 'te57ca53t0t3s7a11ex7r3me71e5ft'){
			this.test = false;			
			return;
		}
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animals(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){classification,animalID,commonName,groupID{groupName},heightM,heightF,weightM,weightF,habitats{habitatID},dietType,' +
			'lifeSpan,gestationPeriod,animalOverview,typicalBehaviourM{behaviour,threatLevel},typicalBehaviourF{behaviour,threatLevel},animalDescription,pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				var newAnimalList = temp[0];
				this.animals = newAnimalList;
				/*switch (updateOp) {
					case "update":
						this.animals = null;
						break;
					case "add":
						newAnimalList.forEach(x => this.addIfNewAnimal(x));
						break;
				}*/
				this.sort(true);
			});
	}

	updateAnimalList(updatedList) {
		this.test = true;
		this.refresh(updatedList);
	}

	// addIfNewAnimal(x: any) {
	// 	let isNotNew = false;
	// 	for (let i = 0; i < this.animals.length; i++)
	// 		if (x.token == this.animals[i].token)
	// 			isNotNew = true;

	// 	if (!isNotNew)
	// 		this.animals.push(x);
	// }

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
		let temp: string;
		if (bool) {
			for (let i = 0; i < this.animals.length - 1; i++) {
				for (let j = i + 1; j < this.animals.length; j++) {
					if (this.animals[i].commonName.toUpperCase() > this.animals[j].commonName.toUpperCase()) {
						let temp = this.animals[i];
						this.animals[i] = this.animals[j];
						this.animals[j] = temp;
					}
				}
			}
			temp = "Sorted common name";
		} else {
			for (let i = 0; i < this.animals.length - 1; i++) {
				for (let j = i + 1; j < this.animals.length; j++) {
					if (this.animals[i].groupID[0].groupName > this.animals[j].groupID[0].groupName) {
						let temp = this.animals[i];
						this.animals[i] = this.animals[j];
						this.animals[j] = temp;
					}
				}
			}
			temp = "Sorted group name";
		}
		return temp;
	}
}
