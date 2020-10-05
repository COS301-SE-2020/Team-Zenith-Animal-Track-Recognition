import { Component, OnInit, ViewChild, Input, Output, EventEmitter } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { EMPTY } from 'rxjs';
import { catchError, map, retry } from 'rxjs/operators';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
	selector: 'app-rangers',
	templateUrl: './rangers.component.html',
	styleUrls: ['./rangers.component.css']
})
export class RangersComponent implements OnInit {

	@ViewChild('sidenav') sidenav;
	rangers: any = null;
	searchText: string;
	selection: string;
	currentAlphabet;
	sorted: string;

	constructor(private http: HttpClient, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		this.startLoader();
		this.startSidenavLoader();
		document.getElementById('rangers-route-link').classList.add('activeRoute');
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){rangerID,password,accessLevel,eMail,firstName,lastName,phoneNumber}}')
			.pipe(
				retry(3),
				catchError(() => {
					this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
					this.stopLoader();
					this.stopSidenavLoader();
					return EMPTY;
				})
			)
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.rangers = temp[0];
				this.sort('bySurname');
			});
	}

	updateSearchText(event) {
		this.searchText = event;
	}

	refresh(updateOp: string) {
		this.startLoader();
		this.startSidenavLoader();
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){rangerID,password,accessLevel,eMail,firstName,lastName,phoneNumber}}')
			.pipe(
				retry(3),
				catchError(() => {
					this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
					this.stopLoader();
					return EMPTY;
				})
			)
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
						let removedRanger = this.rangers.filter(x => !newRangerList.some(y => y.rangerID == x.rangerID));
						this.removeRanger(removedRanger[0].rangerID);
						break;
				}
				//Force ngOnChanges to detect the change
				this.rangers = this.rangers.slice();
				this.sort('bySurname');
			});
	}

	//Ranger CRUD Operations
	updateRangerList(updatedList: string) {
		this.refresh(updatedList);
	}
	addIfNewRanger(x: any) {
		let isNotNew = false;
		for (let i = 0; i < this.rangers.length; i++)
			if (x.rangerID == this.rangers[i].rangerID)
				isNotNew = true;

		if (!isNotNew)
			this.rangers.push(x);
	}
	removeRanger(t: string) {
		this.rangers.splice(this.rangers.findIndex(x => x.rangerID == t), 1);
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
	//Sort functions
	sort(selection: string) {
		this.startLoader();
		this.startSidenavLoader();
		switch (selection) {
			case "byLevel":
				this.sortLevel();
				break;
			case "bySurname":
				this.sortSurname();
				break;
		}
		this.selection = selection;
		this.rangers = this.rangers.slice();
	}
	sortLevel() {
		for (let i = 0; i < this.rangers.length - 1; i++) {
			for (let j = i + 1; j < this.rangers.length; j++) {
				if (this.rangers[i].accessLevel > this.rangers[j].accessLevel) {
					let temp = this.rangers[i];
					this.rangers[i] = this.rangers[j];
					this.rangers[j] = temp;
				}
			}
		}
	}
	sortSurname() {
		for (let i = 0; i < this.rangers.length - 1; i++) {
			for (let j = i + 1; j < this.rangers.length; j++) {
				if (this.rangers[i].lastName.toUpperCase() > this.rangers[j].lastName.toUpperCase()) {
					let temp = this.rangers[i];
					this.rangers[i] = this.rangers[j];
					this.rangers[j] = temp;
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
	startSidenavLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopSidenavLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
}
