import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
	selector: 'app-animal-search-sidenav',
	templateUrl: './animal-search-sidenav.component.html',
	styleUrls: ['./animal-search-sidenav.component.css']
})
export class AnimalSearchSidenavComponent implements OnInit {
	@Input() animals;
	@Input() searchText: string;
	@Input() sortByCommonName: boolean;
	currentAlphabet;
	@Output() animalsOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() searchTextOnChange: EventEmitter<string> = new EventEmitter();

	constructor() { }

	ngOnInit(): void { 
		this.sortByCommonName = true;
	}

	checkIfNew(title: string) {
		if (this.currentAlphabet === ("" + title).charAt(0).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).charAt(0).toLowerCase();			
			return true;
		}
	}

	checkIfNewGroup(title: string) {
		if (this.currentAlphabet === ("" + title).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).toLowerCase();			
			return true;
		}
	}

	updateSearchText(event) {
		this.searchTextOnChange.emit(event);
	}

	checkSpecies(title: string) {
		if (this.currentAlphabet === ("" + title).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).toLowerCase();
			return true;
		}
	}

	toggle(bool: boolean) {
		this.sortByCommonName = bool;
		this.sort(bool);
	}

	sort(bool: boolean) {
		if (bool) {
			for (let i = 0; i < this.animals.length - 1; i++) {
				for (let j = i + 1; j < this.animals.length; j++) {
					if (this.animals[i].Common_Name.toUpperCase() > this.animals[j].Common_Name.toUpperCase()) {
						let temp = this.animals[i];
						this.animals[i] = this.animals[j];
						this.animals[j] = temp;
					}
				}
			}
		} else {
			for (let i = 0; i < this.animals.length - 1; i++) {
				for (let j = i + 1; j < this.animals.length; j++) {
					if (this.animals[i].Group_ID[0].Group_Name > this.animals[j].Group_ID[0].Group_Name) {
						let temp = this.animals[i];
						this.animals[i] = this.animals[j];
						this.animals[j] = temp;
					}
				}
			}
		}
	}

}
