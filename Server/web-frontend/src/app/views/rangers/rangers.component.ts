import { map } from 'rxjs/operators';
import { Component, OnInit, ViewChild, Input, Output, EventEmitter } from '@angular/core';
import { Ranger } from './../../models/ranger';
import { RANGERS } from './../../models/mock-rangers';
import { HttpClient } from '@angular/common/http';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
	selector: 'app-rangers',
	templateUrl: './rangers.component.html',
	styleUrls: ['./rangers.component.css']
})
export class RangersComponent implements OnInit {

	@ViewChild('sidenav') sidenav;
	rangers: any;
	searchText: string;
	sortBySurname: boolean = true;
	currentAlphabet;
	sorted: string;

	constructor(private http: HttpClient) { }

	ngOnInit(): void {
		document.getElementById('rangers-route').classList.add('activeRoute');
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){token,password,accessLevel,eMail,firstName,lastName,phoneNumber}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.rangers = temp[0];
				this.sort(this.sortBySurname);
			});
	}

	updateSearchText(event) {
		this.searchText = event;
	}

	refresh(updateOp: string) {
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){token,password,accessLevel,eMail,firstName,lastName,phoneNumber}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				var newRangerList = temp[0];
				switch (updateOp) {
					case "update":
						this.rangers = null;
						this.rangers = newRangerList;
						break;
					case "add":
						newRangerList.forEach(x => this.addIfNewRanger(x));
						break;
					case "delete":
						let removedRanger = this.rangers.filter(x => !newRangerList.some(y => y.token == x.token));
						this.removeRanger(removedRanger[0].token);
						break;
				}
				this.sort(this.sortBySurname);
			});
	}
	//Ranger CRUD Operations
	updateRangerList(updatedList: string) {
		this.refresh(updatedList);
	}
	addIfNewRanger(x: any) {
		let isNotNew = false;
		for (let i = 0; i < this.rangers.length; i++)
			if (x.token == this.rangers[i].token)
				isNotNew = true;

		if (!isNotNew)
			this.rangers.push(x);
	}
	removeRanger(t: string) {
		this.rangers.splice(this.rangers.findIndex(x => x.token == t), 1);
	}
	
	//Ranger Search sidenav
	openSidenav() {
		this.sidenav.open();
		document.getElementById('sidenav-open-btn-container').style.transitionDuration = '0.2s';
		document.getElementById('sidenav-open-btn-container').style.left = '-10%';
	}
	closeSidenav() {
		this.sidenav.close();
		document.getElementById('sidenav-open-btn-container').style.transitionDuration = '0.8s';
		document.getElementById('sidenav-open-btn-container').style.left = '0%';
	}

	//Sorting and Filtering
	toggle(bool: boolean) {
		this.sortBySurname = bool;
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
					if (this.rangers[i].accessLevel > this.rangers[j].accessLevel2) {
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
