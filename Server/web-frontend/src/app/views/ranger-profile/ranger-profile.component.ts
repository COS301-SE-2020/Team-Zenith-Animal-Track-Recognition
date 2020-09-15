import { Component, OnInit, Input  } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatTabsModule } from '@angular/material/tabs'; 
import { EditRangerInfoComponent } from './../rangers/edit-ranger-info/edit-ranger-info.component';
import { DeleteRangerComponent } from './../rangers/delete-ranger/delete-ranger.component';
import { MatSnackBar } from '@angular/material/snack-bar';
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


	/*Place holder values*/
	constructor(
		private http: HttpClient, 
		private router: Router, 
		private activatedRoute: ActivatedRoute, 
		public dialog: MatDialog, 
		private snackBar: MatSnackBar ) { }

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

			this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){spoorIdentificationID,animal{classification,animalID,commonName,heightM,heightF,weightM,weightF,dietType,lifeSpan,Offspring,gestationPeriod,animalOverview,animalDescription,animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName,pictureURL},potentialMatches{confidence},picture{picturesID,URL,kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.spoorIdentifications = temp[0];
				// this.timeToString();
			});
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
	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}