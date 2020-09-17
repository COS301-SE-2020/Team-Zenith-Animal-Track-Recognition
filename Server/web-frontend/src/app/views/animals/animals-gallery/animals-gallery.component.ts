import { Component, OnInit, ViewChild, Input } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
  selector: 'app-animals-gallery',
  templateUrl: './animals-gallery.component.html',
  styleUrls: ['./animals-gallery.component.css']
})

export class AnimalsGalleryComponent implements OnInit {

	@ViewChild('sidenav') sidenav: any;
	animals: any;
	sortByCommonName: boolean = true;
	searchText: string;
	currentAlphabet: any;
	surnames: boolean = true;
	levels: boolean = false;
	test: boolean;
	selection: string;
	
	constructor(private http: HttpClient) { }	

	ngOnInit(): void {
		this.test = true;
		document.getElementById("animals-route-link").classList.add("activeRoute");
		document.getElementById("animals-gallery-route").classList.add("activeRoute");
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animals(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){classification,animalID,commonName,groupID{groupName},heightM,heightF,weightM,weightF,habitats{habitatID},dietType,' +
			'lifeSpan,gestationPeriod,animalOverview,animalDescription,pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animals = temp[0];
				this.sort('byAbc');
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

	refresh(updateOp: string) {
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animals(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){classification,animalID,commonName,groupID{groupName},heightM,heightF,weightM,weightF,habitats{habitatID},dietType,' +
			'lifeSpan,gestationPeriod,animalOverview,animalDescription,pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animals = temp[0];
				this.sort('byAbc');
			});
	}

	updateAnimalList(updatedList) {
		this.refresh(updatedList);
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
		this.sort('byAbc');
	}
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
	
	//Loader
	startLoader() {
		document.getElementById("loader-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("loader-container").style.visibility = "hidden";
	}
}
