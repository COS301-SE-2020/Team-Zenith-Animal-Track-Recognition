import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Component({
	selector: 'app-animal-search-sidenav',
	templateUrl: './animal-search-sidenav.component.html',
	styleUrls: ['./animal-search-sidenav.component.css']
})
export class AnimalSearchSidenavComponent implements OnInit {
	@Input() animals: any;
	@Input() searchText: string;
	@Input() sortBy: any = [];

	@Output() animalsOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() searchTextOnChange: EventEmitter<string> = new EventEmitter();

	currentAlphabet: any;

	constructor(private http: HttpClient, private router: Router) { }

	ngOnInit(): void {
		const url = new URLSearchParams(window.location.search);
		const sortstyle = url.get('sort') == null ? 1 : Number.parseInt(url.get('sort'));
		for (let i = 0; i < 4; i++) {
			this.sortBy[i] = false;
		}
		setTimeout(() => {
			this.sort(sortstyle);
			this.sortBy[sortstyle] = true;
		}, 1000);
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}
	viewAnimalProfile(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}

	checkIfNew(title: string) {
		if (this.currentAlphabet === ("" + title).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).toLowerCase();
			return true;
		}
	}

	updateSearchText(event) {
		this.searchTextOnChange.emit(event);
		if ((<HTMLInputElement>document.getElementById("search-sidenav-input")).value == "")
			this.currentAlphabet = null;
	}

	sort(selection: number) {
		switch (selection) {
			case 1:
				this.sortAlphabetical();
				break;
			case 2:
				this.sortGroups();
				break;
			case 3:
				this.sortHeight();
				break;
			case 4:
				this.sortWeight();
				break;
		}
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

	sortHeight() {
		throw new Error("Method not implemented.");
	}
	sortWeight() {
		throw new Error("Method not implemented.");
	}

}
