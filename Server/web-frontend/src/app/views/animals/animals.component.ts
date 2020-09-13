import { Component, OnInit, ViewChild, IterableDiffers } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { runInNewContext } from 'vm';

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
	selection: string;
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
			'lifeSpan,gestationPeriod,Offspring,typicalBehaviourM{behaviour,threatLevel},typicalBehaviourF{behaviour,threatLevel},animalOverview,animalDescription,pictures{URL}}}')
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
				this.sort('byAbc');
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
			'lifeSpan,gestationPeriod,Offspring,typicalBehaviourM{behaviour,threatLevel},typicalBehaviourF{behaviour,threatLevel},animalOverview,animalDescription,pictures{URL}}}')
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
				this.sort('byAbc');				
			});
	}

	updateAnimalList(updatedList) {
		this.test = true;
		this.refresh(updatedList);
	}

	/*
	addIfNewAnimal(x: any) {
	 	let isNotNew = false;
		for (let i = 0; i < this.animals.length; i++)
	 		if (x.token == this.animals[i].token)
	 			isNotNew = true;

	 	if (!isNotNew)
			this.animals.push(x);
	}*/

	//Sorting and Filtering
	checkIfNew(title: string, pos: number) {
		console.log('checking new');
		if (this.currentAlphabet === ("" + title).charAt(pos).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).charAt(pos).toLowerCase();
			return true;
		}
	}
	
	
	//Sort functions
	sort(selection: string) {
		switch (selection) {
			case "byAbc":
				this.sortAlphabetical();
				break;
			case "byGroup":
				this.sortGroups();
				break;
			case "byHeight":
				this.sortHeight();
				break;
			case "byWeight":
				this.sortWeight();
				break;
		}
		this.selection = selection;
		console.log(this.selection);
	}

	private sortAlphabetical() {
		for (let i = 0; i < this.animals.length - 1; i++) {
			for (let j = i + 1; j < this.animals.length; j++) {
				if (this.animals[i].commonName.toUpperCase() > this.animals[j].commonName.toUpperCase()) {
					let temp = this.animals[i];
					this.animals[i] = this.animals[j];
					this.animals[j] = temp;
				}
			}
		}
	}
	
	private sortGroups() {
		for (let i = 0; i < this.animals.length - 1; i++) {
			for (let j = i + 1; j < this.animals.length; j++) {
				if (this.animals[i].groupID[0].groupName > this.animals[j].groupID[0].groupName) {
					let temp = this.animals[i];
					this.animals[i] = this.animals[j];
					this.animals[j] = temp;
				}
			}
		}
	}

	private sortHeight() {
		for (let i = 0; i < this.animals.length - 1; i++) {


			for (let j = i + 1; j < this.animals.length; j++) {
				
				var heightForI = this.animals[i].heightM.indexOf('-');
				var upperBoundHeightValue = this.animals[i].heightM.substring(heightForI+1);
				var upperBoundAsANumber = Number(upperBoundHeightValue);
	
				var heightForJ = this.animals[j].heightM.indexOf('-');
				var upperBoundHeightValue2 = this.animals[j].heightM.substring(heightForJ+1);
				var valueAsANumber = Number(upperBoundHeightValue2);

				if (upperBoundAsANumber < valueAsANumber) {
					let temp = this.animals[i];
					this.animals[i] = this.animals[j];
					this.animals[j] = temp;

				}

			}
		}
	}
	private sortWeight() {
		for (let i = 0; i < this.animals.length - 1; i++) {


			for (let j = i + 1; j < this.animals.length; j++) {
				
				var weightForI = this.animals[i].weightM.indexOf('-');
				var upperBoundWeightValue = this.animals[i].weightM.substring(weightForI+1);
				var upperBoundAsANumber = Number(upperBoundWeightValue);
	
				var weightForJ = this.animals[j].weightM.indexOf('-');
				var upperBoundWeightValue2 = this.animals[j].weightM.substring(weightForJ+1);
				var valueAsANumber = Number(upperBoundWeightValue2);

				if (upperBoundAsANumber < valueAsANumber) {
					let temp = this.animals[i];
					this.animals[i] = this.animals[j];
					this.animals[j] = temp;
				}

			}
		}
		for(let i = 0; i < this.animals.length ; i++){
			var weightForI = this.animals[i].weightM.indexOf('-');
			var upperBoundWeightValue = this.animals[i].weightM.substring(weightForI+1);
			var upperBoundAsANumber = Number(upperBoundWeightValue);
			console.log(upperBoundAsANumber+" "+this.animals[i].commonName)
		}
	}
}
