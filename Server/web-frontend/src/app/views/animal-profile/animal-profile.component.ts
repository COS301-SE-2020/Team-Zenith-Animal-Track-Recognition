import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatTabsModule } from '@angular/material/tabs'; 
import { EditRangerInfoComponent } from './../rangers/edit-ranger-info/edit-ranger-info.component';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
  selector: 'app-animal-profile',
  templateUrl: './animal-profile.component.html',
  styleUrls: ['./animal-profile.component.css']
})
export class AnimalProfileComponent implements OnInit {

	animal: any;
	animalClassi: string;
	
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
		document.getElementById('animals-route').classList.add('activeRoute');
		//Determine which user was navigated to and fetch their information
		let classificationQuery = this.activatedRoute.snapshot.paramMap.get("classification").split("_");
		this.animalClassi = classificationQuery[0] + " " + classificationQuery[1];
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsbyByClassification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", classification:"' + this.animalClassi + '"){classification,animalID,commonName,groupID{groupName},heightM,heightF,weightM,weightF,habitats{habitatID},dietType,' +
			'lifeSpan,gestationPeriod,animalOverview,animalDescription,pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animal = temp[0];
				console.log(this.animal);
				console.log(Object.values(this.animal));
				this.stopLoader();
			});
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}
	
	//Ranger CRUD Quick-Actions
	//EDIT Ranger
	openEditRangerDialog(rangerID) {
		/*
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
		});*/
	}
	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}

}
