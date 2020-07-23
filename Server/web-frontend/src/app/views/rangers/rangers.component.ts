import { map } from 'rxjs/operators';
import { Component, OnInit, ViewChild } from '@angular/core';
import { Ranger } from './../../models/ranger';
import { RANGERS } from './../../models/mock-rangers';
import { HttpClient } from '@angular/common/http';

@Component({
	selector: 'app-rangers',
	templateUrl: './rangers.component.html',
	styleUrls: ['./rangers.component.css']
})
export class RangersComponent implements OnInit {

	@ViewChild('sidenav') sidenav;

	rangers;
	searchText: string;
	currentAlphabet;
	surnames: boolean = true;
	levels: boolean = false;

	constructor(private http: HttpClient) { }

	ngOnInit(): void {
		document.getElementById("rangers-route").classList.add("activeRoute");
		this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{Users(TokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '"){Token,Password,Access_Level,e_mail}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.printOut(temp);
			});
	}

	printOut(temp: any) {
		this.rangers = temp;
		console.log(this.rangers);
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
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].lastName.toUpperCase() > this.rangers[j].lastName.toUpperCase()) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
		} else {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].rangerLevel > this.rangers[j].rangerLevel) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
		}
	}
}
