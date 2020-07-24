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
		this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{animals(Token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '"){Classification,Common_Name,Group_ID{Group_Name}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.printOut(temp);
			});
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

	checkSpecies(title: string) {
		if (this.currentAlphabet === ("" + title).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).toLowerCase();
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
