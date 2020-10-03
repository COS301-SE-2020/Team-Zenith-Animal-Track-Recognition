import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { MatSnackBar } from '@angular/material/snack-bar';
import { MatOption } from '@angular/material/core';
import { TracksService } from './../../../services/tracks.service';
import { TrackViewNavigationService } from './../../../services/track-view-navigation.service';

@Component({
	selector: 'app-track-identifications-toolbar',
	templateUrl: './track-identifications-toolbar.component.html',
	styleUrls: ['./track-identifications-toolbar.component.css']
})
export class TrackIdentificationsToolbarComponent implements OnInit {

	@Input() searchText: string;
	@Input() trackIds;
	@Input() selectedFilter: string;
	@Output() sortByGroupsOnChange: EventEmitter<Object> = new EventEmitter();
	@ViewChild("filterOptionSelect") filterOptionSelect;

	filterByOption: string = "";
	filterOptions: any = [];
	animals = [];
	animalGroups = [];
	rangers = [];
	tags = [];
	showHeatmap: boolean = false;

	constructor(private http: HttpClient, public dialog: MatDialog, private snackBar: MatSnackBar, private router: Router, 
	private tracksService: TracksService, private trackViewNavService: TrackViewNavigationService) { }

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
				this.animals.splice(0, 0, "All Animals");
			});

		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{groups(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){groupName}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(Object.values(data)[0])[0]);
				temp.forEach(element => {
					this.animalGroups.push(element['groupName']);
				});
				this.animalGroups.splice(0, 0, "All Groups");
			});

		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){firstName, lastName}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(Object.values(data)[0])[0]);
				temp.forEach(element => {
					this.rangers.push(element['firstName'] + ' ' + element['lastName']);
				});
				this.rangers.splice(0, 0, "All Rangers");
			});

		this.stopLoader();
	}

	toggleHeatmap() {
		this.showHeatmap = !this.showHeatmap;
		if (this.showHeatmap)
			this.trackViewNavService.toggleHeatmap("on");
		else if (!this.showHeatmap)
			this.trackViewNavService.toggleHeatmap("off");
	}
	toggleHeatmapSettings() {
		if (this.filterByOption != 'Animal') {
			this.trackViewNavService.toggleHeatmap("off");
			this.trackViewNavService.toggleHeatmapSettings("off");
			return;
		}
		if (this.filterByOption == 'Animal' && !this.filterOptionSelect.empty) {
			this.trackViewNavService.toggleHeatmapSettings("on");
		}
	}
	route(location: string) {
		this.router.navigate([location]);
	}

	updateFilter(choice: string) {
		this.filterOptions = [];
		switch (choice) {
			case "animal":
				this.animals.forEach(element => {
					this.filterOptions.push(element);
				});
				this.filterByOption = "Animal";
				break;
			case "group":
				this.animalGroups.forEach(element => {
					this.filterOptions.push(element);
				});
				this.filterByOption = "Group";
				break;
			case "ranger":
				this.rangers.forEach(element => {
					this.filterOptions.push(element);
				});
				this.filterByOption = "Ranger";
				break;
		}
		this.sortByGroupsOnChange.emit(choice);
	}

	filterList(filter) {
		if (filter == "All Animals" || filter == "All Rangers" || filter == "All Groups")
			filter = "All";
		this.tracksService.changeTrackFilter(this.filterByOption, filter);
	}

	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}