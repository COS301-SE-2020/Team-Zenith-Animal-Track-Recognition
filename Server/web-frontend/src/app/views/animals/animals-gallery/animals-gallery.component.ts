import { Component, OnInit, ViewChild } from '@angular/core';
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
				this.sort(true);
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
				this.sort(true);
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
		this.sort(bool);
	}
	sort(bool: boolean) {
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
