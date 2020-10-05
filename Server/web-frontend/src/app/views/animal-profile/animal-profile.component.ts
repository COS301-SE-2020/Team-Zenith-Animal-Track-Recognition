import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { ViewportScroller } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatTabsModule } from '@angular/material/tabs';
import { EditAnimalInfoComponent } from './../animals/edit-animal-info/edit-animal-info.component';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TRACKS_QUERY_STRING } from 'src/app/models/data';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { AddImageComponent } from '../animals/add-image/add-image.component';

@Component({
	selector: 'app-animal-profile',
	templateUrl: './animal-profile.component.html',
	styleUrls: ['./animal-profile.component.css']
})
export class AnimalProfileComponent implements OnInit {

	animal: any;
	animalClassi: string;
	femaleBehaviour: string;
	maleBehaviour: string;
	trackIdentifications: any;
	filteredListArray: any;
	displayedTracks: any;

	constructor(
		private http: HttpClient,
		private router: Router,
		private activatedRoute: ActivatedRoute,
		public dialog: MatDialog,
		private snackBar: MatSnackBar,
		private viewportScroller: ViewportScroller
	) { }

	ngOnInit(): void {
		this.startLoader();
		document.getElementById('animals-route-link').classList.add('activeRoute');
		//Determine which user was navigated to and fetch their information
		const classificationQuery = new URLSearchParams(window.location.search);
		const animal = classificationQuery.get("classification").split("_");
		
		this.animalClassi = animal[0] + " " + animal[1];
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsByClassification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", classification:"' + this.animalClassi + '"){classification,animalID,commonName,groupID{groupName},heightM,heightF,weightM,weightF,habitats{habitatID},dietType,' +
			'lifeSpan,gestationPeriod,Offspring,typicalBehaviourM{behaviour,threatLevel},typicalBehaviourF{behaviour,threatLevel},animalOverview,animalDescription,pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animal = temp[0];

				//DUMMY DATA
				const desc = ("" + this.animal.animalDescription);

				this.animal.animalOverview = desc.substring(0, desc.indexOf('.') + 1);

				this.stopLoader();
			});
		this.http.get<any>(TRACKS_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'",classification:"' + this.animalClassi + '"){spoorIdentificationID,animal{classification,animalID,groupID{groupName},commonName,pictures{picturesID,URL,kindOfPicture},animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},confidence},picture{picturesID,URL,kindOfPicture}}}')
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
				console.log(this.displayedTracks);

				//Check if a track was selected from the query parameters
				//this.filterRanger();
			});
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}

	viewAnimalPhotos(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/gallery/photos'], { queryParams: { classification: classificationQuery } });
	}

	getOffspringType(dtn, num) {
		switch (dtn) {
			case 'Browser':
			case 'Grazer':
				if (num == 1) {
					return 'Calf';
				} else {
					return 'Calves';
				}
				break;
			case 'Carnivore':
			case 'Insectivore':
			case 'Scavenger':
				if (num == 1) {
					return 'Cub';
				} else {
					return 'Cubs';
				}
				break;
			default:
				if (num == 1) {
					return 'Infant';
				} else {
					return 'Infants';
				}
				break;
		}
	}

	//Ranger CRUD Quick-Actions
	//EDIT Ranger
	openEditAnimalDialog(t: number) {
		const editDialogRef = this.dialog.open(EditAnimalInfoComponent, {
			height: '90%',
			width: '55%',
			autoFocus: true,
			disableClose: true,
			id: 'edit-animal-dialog',
			data: {
				animal: this.animal,
				tab: t
			},
		});
		editDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			if (result == "success") {
				//If animal was successfully edited refresh component 
				this.ngOnInit();
				this.snackBar.open('Animal information successfully edited.', 'Dismiss', { duration: 3000, });
			}
			else if (result == 'error') {
				this.snackBar.open('An error occured when editting the animal. Please try again.', "Dismiss", { duration: 5000, });
			}
		});
	}

	openAddNewImageDialog() {
		const editDialogRef = this.dialog.open(AddImageComponent, {
			height: '70%',
			width: '50%',
			autoFocus: true,
			disableClose: true,		
			id: 'add-new-image-dialog',
			data: {
				animal: this.animal
			},
		});
		editDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			if (result == "success") {
			}
			else if (result == 'error') {
				this.snackBar.open('An error occured when editting the animal. Please try again.', "Dismiss", { duration: 5000, });
			}
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
	navigateToSection(elementId: string): void {
		const elmnt = document.getElementById(elementId);
		elmnt.scrollIntoView({ behavior: "smooth", block: "start", inline: "nearest" });
	}
	viewRangerProfile(rangerID: string) {
		this.router.navigate(['rangers/profiles'], { queryParams: { ranger: rangerID } });
	}
	viewOnTrackMap(trackId: any) {
		this.router.navigate(['identifications'], { queryParams: { openTrackId: trackId } });
	}
	viewIdentifications() {
		this.router.navigate(['identifications'], { queryParams: { filterType: "Animals", filter: this.animal.commonName } });
	}
	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}
