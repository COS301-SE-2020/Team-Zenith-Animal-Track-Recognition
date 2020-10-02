import { Component, OnInit, Input } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatTabsModule } from '@angular/material/tabs';
import { EditRangerInfoComponent } from './../rangers/edit-ranger-info/edit-ranger-info.component';
import { DeleteRangerComponent } from './../rangers/delete-ranger/delete-ranger.component';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TRACKS_QUERY_STRING } from 'src/app/models/data';
import { ROOT_QUERY_STRING } from 'src/app/models/data';



@Component({
	selector: 'app-ranger-profile',
	templateUrl: './ranger-profile.component.html',
	styleUrls: ['./ranger-profile.component.css']
})


export class RangerProfileComponent implements OnInit {

	user: any;
	userToken: string;
	spoorIdentifications: any;
	activities = [
		{
			type: 'Reclassified Spoor',
			dateTime: '09:13, 12th Dec 2020',
			summary: {
				info1: 'Diceros Bicornis',
				info2: 'Syncerus Caffer'
			}
		},
		{
			type: 'Captured Spoor',
			dateTime: '09:13, 12th Dec 2020',
			summary: {
				info1: 'Diceros Bicornis',
				info2: '67% Accuracy'
			}
		},
		{
			type: 'Uploaded Spoor Image',
			dateTime: '09:13, 12th Dec 2020',
			summary: {
				info1: 'Spoor Image',
				info2: 'Syncerus Caffer'
			}
		},
		{
			type: 'Uploaded Animal Image',
			dateTime: '09:13, 12th Dec 2020',
			summary: {
				info1: 'Animal Photo',
				info2: 'Syncerus Caffer'
			}
		},
		{
			type: 'Edited Animal Info',
			dateTime: '09:13, 12th Dec 2020',
			summary: {
				info1: 'Edit Information',
				info2: 'Syncerus Caffer'
			}
		},
		{
			type: 'Added New Animal',
			dateTime: '09:13, 12th Dec 2020',
			summary: {
				info1: 'Add Animal',
				info2: 'Syncerus Caffer'
			}
		},
	];
	trackIdentifications: any;
	filteredListArray: any;
	displayedTracks: any;


	/*Place holder values*/
	constructor(
		private http: HttpClient,
		private router: Router,
		private activatedRoute: ActivatedRoute,
		public dialog: MatDialog,
		private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		this.startLoader();
		document.getElementById('rangers-route-link').classList.add('activeRoute');
		//Determine which user was navigated to and fetch their information
		const url = new URLSearchParams(window.location.search);
		this.userToken = url.get('ranger');

		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'",rangerID:"' + this.userToken + '"){rangerID,accessLevel,eMail,firstName,lastName,phoneNumber}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.user = temp[0][0];
				this.stopLoader();
			});

		this.http.get<any>(TRACKS_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'",ranger:"' + this.userToken + '"){spoorIdentificationID,animal{classification,animalID,groupID{groupName},commonName,pictures{picturesID,URL,kindOfPicture},animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},confidence},picture{picturesID,URL,kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.trackIdentifications = temp[0];
				this.filteredListArray = temp[0];
				//Add 'time ago' field to each track
				this.timeToString();
			//	this.createTagList();

				//Only display a certain number of tracks per sidenav page
				this.displayedTracks = this.trackIdentifications.slice(0, 25);

				//Check if a track was selected from the query parameters
				//this.filterRanger();
			});
	}
	
	filterRanger() {
		this.filteredListArray = [];

		for (let i = 0; i < this.trackIdentifications.length; i++) {
			if ((this.trackIdentifications[i]['ranger']['firstName'] + ' ' + this.trackIdentifications[i]['ranger']['lastName']) == (this.user['firstName'] + ' ' + this.user['lastName'])) {
				this.filteredListArray.push(this.trackIdentifications[i]);
			}
		}
		this.displayedTracks = [];
		this.displayedTracks = this.filteredListArray.slice(0, this.filteredListArray.length > 10 ? 10 : this.filteredListArray.length);
		this.stopLoader();
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}

	//Ranger CRUD Quick-Actions
	//EDIT Ranger
	openEditRangerDialog(rangerID) {
		const dialogConfig = new MatDialogConfig();

		const editDialogRef = this.dialog.open(EditRangerInfoComponent, {
			height: '55%',
			width: '35%',
			autoFocus: true,
			disableClose: true,
			id: 'edit-ranger-dialog',
			data: {
				rangerID: this.user.rangerID,
				firstName: this.user.firstName,
				lastName: this.user.lastName,
				phoneNumber: this.user.phoneNumber,
				email: this.user.eMail
			},
		});
		editDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			if (result == 'success') {
				//If ranger was successfully edited refresh component
				this.ngOnInit();
				this.snackBar.open('Ranger information successfully edited.', 'Dismiss', { duration: 3000, });
			}
			else if (result == 'error') {
				this.snackBar.open('An error occured when editing ranger. Please try again.', "Dismiss", { duration: 5000, });
			}
		});
	}
	//DELETE Ranger
	openDeleteRangerDialog(rangerID: any) {
		try {
			const dialogConfig = new MatDialogConfig();

			const deleteDialogRef = this.dialog.open(DeleteRangerComponent, {
				height: '45%',
				width: '30%',
				autoFocus: true,
				disableClose: true,
				id: 'delete-ranger-dialog',
				data: {
					name: this.user.firstName + " " + this.user.lastName,
					rangerID: this.user.rangerID
				},
			});
			deleteDialogRef.afterClosed().subscribe(result => {
				this.stopLoader();
				if (result == "success") {
					//If ranger was successfully deleted navigate back to Rangers View
					this.route('rangers');
				}
				else if (result == 'error') {
					this.snackBar.open('An error occured when deleting ranger. Please try again.', "Dismiss", { duration: 5000, });
				}
			});
		}
		catch (e) {
			return false;
		}
	}
	createTagList() {
		this.trackIdentifications.forEach(element => {
			let temp = element.tag.split(",");
			element.dateObj = new Date(temp.year, temp.month, temp.day, temp.hour, temp.min, temp.second);
		});
	}	
	timeToString() {
		this.trackIdentifications.forEach(element => {
			let temp = element.dateAndTime;
			temp.month = temp.month < 10 ? '0' + temp.month : temp.month;
			temp.day = temp.day < 10 ? '0' + temp.day : temp.day;
			temp.hour = temp.hour < 10 ? '0' + temp.hour : temp.hour;
			temp.min = temp.min < 10 ? '0' + temp.min : temp.min;
			temp.second = temp.second < 10 ? '0' + temp.second : temp.second;
			const str: string = temp.year + "-" + temp.month + "-" + temp.day + "T" + temp.hour + ":" + temp.min + ":" + temp.second + ".000Z";
			element.timeAsString = str;
			element.dateObj = new Date(temp.year, temp.month, temp.day, temp.hour, temp.min, temp.second);
		});
	}
	viewAnimalProfile(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}
	viewOnTrackMap(trackId: any) {
		console.log("trackID in profile view: " + trackId);
		this.router.navigate(['identifications'], { queryParams: { openTrackId: trackId } });
	}
	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}