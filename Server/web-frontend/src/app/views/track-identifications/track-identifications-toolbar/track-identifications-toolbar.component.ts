import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { MatSnackBar } from '@angular/material/snack-bar';
import { MatOption } from '@angular/material/core';

@Component({
	selector: 'app-track-identifications-toolbar',
	templateUrl: './track-identifications-toolbar.component.html',
	styleUrls: ['./track-identifications-toolbar.component.css']
})
export class TrackIdentificationsToolbarComponent implements OnInit {

	@Input() searchText: string;
	@Input() trackIds;
	@Input() selectedFilter: string;
	@Output() tracksOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() sortByGroupsOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() selectedFilterOnChange: EventEmitter<Object> = new EventEmitter();

	filterOptions: any = [];
	animals = [];
	animalGroups = [];
	rangers = [];
	tags = [];

	constructor(private router: Router, public dialog: MatDialog, private http: HttpClient, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		this.startLoader();
		var count = 1;
		//Replace Groups with appropiate radio button
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animals(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){commonName}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(Object.values(data)[0])[0]);
				temp.forEach(element => {
					this.animals.push(element['commonName']);
				});
			});

		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{groups(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){groupName}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(Object.values(data)[0])[0]);
				temp.forEach(element => {
					this.animalGroups.push(element['groupName']);
				});
			});

		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){firstName, lastName}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(Object.values(data)[0])[0]);
				temp.forEach(element => {
					this.rangers.push(element['firstName'] + ' ' + element['lastName']);
				});
			});

		this.stopLoader();
	}

	route(location: string) {
		this.router.navigate([location]);
	}

	updateFilter(choice: number) {
		this.filterOptions = [];
		switch (choice) {
			case 0:
				this.animals.forEach(element => {
					this.filterOptions.push(element);
				});
				break;
			case 1:
				this.animalGroups.forEach(element => {
					this.filterOptions.push(element);
				});
				break;
			case 2:
				this.rangers.forEach(element => {
					this.filterOptions.push(element);
				});
				break;
		}
		this.sortByGroupsOnChange.emit(choice);
	}

	filterList(filter) {
		this.selectedFilterOnChange.emit(filter);
	}

	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}