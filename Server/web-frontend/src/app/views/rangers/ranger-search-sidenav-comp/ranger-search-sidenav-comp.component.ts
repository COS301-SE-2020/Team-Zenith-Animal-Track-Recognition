import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges } from '@angular/core';
import { Ranger } from './../../../models/ranger';
import { RANGERS } from './../../../models/mock-rangers';
import { HttpClient } from '@angular/common/http';

@Component({
	selector: 'app-ranger-search-sidenav-comp',
	templateUrl: './ranger-search-sidenav-comp.component.html',
	styleUrls: ['./ranger-search-sidenav-comp.component.css']
})
export class RangerSearchSidenavCompComponent implements OnInit 
{

	currentAlphabet;
	surnames: boolean = true;
	levels: boolean = false;
	sorted: string;
	searchText: string;
	@Input() rangers;
	@Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();

	constructor(private http: HttpClient) { }

	ngOnInit(): void {
		document.getElementById("rangers-route").classList.add("activeRoute");
		this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{Users(TokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +'"){Token,Password,Access_Level,e_mail,firstName,lastName}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.printOut(temp);
			});
	}

	printOut(temp: any) {
		this.rangers = temp[0];
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
		let temp: string;
		if (bool) {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].lastName.toUpperCase() > this.rangers[j].lastName.toUpperCase()) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
			temp = "Sorted alphabetically";
		} else {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].Access_Level > this.rangers[j].Access_Level) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
			temp = "Sorted by ranger level";
		}
		this.sorted = temp;
		return temp;
	}
}
