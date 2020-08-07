import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
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
	
	/*Place holder values*/
	spoorIdentifications = [
		{
			commonName: 'Elephant',
			classification: 'Loxodonta Africanus',
			dateTime: '09:13, 12th Dec 2020',
			coordinates: '-24.019097, 31.559270',
			accuracyScore: '67%'
		},		
		{
			commonName: 'Black Rhinoceros',
			classification: 'Diceros Bicornis',
			dateTime: '09:13, 12th Dec 2020',
			coordinates: '-24.019097, 31.559270',
			accuracyScore: '97%'
		},		
		{
			commonName: 'Cape Buffalo',
			classification: 'Syncerus Caffer',
			dateTime: '09:13, 12th Dec 2020',
			coordinates: '-24.019097, 31.559270',
			accuracyScore: '73%'
		},		
		{
			commonName: 'Cheetah',
			classification: 'Acinonyx Jubatus',
			dateTime: '09:13, 12th Dec 2020',
			coordinates: '-24.019097, 31.559270',
			accuracyScore: '67%'
		},		
		{
			commonName: 'Lion',
			classification: 'Panthera Leo',
			dateTime: '09:13, 12th Dec 2020',
			coordinates: '-24.019097, 31.559270',
			accuracyScore: '67%'
		},		
		{
			commonName: 'Impala',
			classification: 'Aepyceros Melampus',
			dateTime: '09:13, 12th Dec 2020',
			coordinates: '-24.019097, 31.559270',
			accuracyScore: '59%'
		}
	];
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
  
	constructor(private http: HttpClient, private router: Router, private activatedRoute: ActivatedRoute, public dialog: MatDialog, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		this.startLoader();
		document.getElementById('rangers-route').classList.add('activeRoute');
		//Determine which user was navigated to and fetch their information
		this.userToken = this.activatedRoute.snapshot.paramMap.get("user");
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", tokenSearch:"' + this.userToken + '"){token,accessLevel,eMail,firstName,lastName,phoneNumber}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.user = temp[0][0];
				this.stopLoader();
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
				token: this.user.token,
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
				this.snackBar.open('An error occured when editting ranger. Please try again.', "Dismiss", { duration: 5000, });
			}
		});
	}
	//DELETE Ranger
	openDeleteRangerDialog(rangerID) {
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
					token: this.user.token
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
