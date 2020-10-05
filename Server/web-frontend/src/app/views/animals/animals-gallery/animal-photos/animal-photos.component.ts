import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatTabsModule } from '@angular/material/tabs';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AnimalPhotoDetailsComponent } from './animal-photo-details/animal-photo-details.component'; 
import { AnimalsService } from './../../../../services/animals.service';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { AddImageComponent } from '../../add-image/add-image.component';

@Component({
	selector: 'app-animal-photos',
	templateUrl: './animal-photos.component.html',
	styleUrls: ['./animal-photos.component.css'],
	providers: [AnimalsService]
})
export class AnimalPhotosComponent implements OnInit {

	animal: any;
	tracksList: any;
	animalClassi: string;
	femaleBehaviour: string;
	maleBehaviour: string;
	tempTracks: any;

	constructor(
		private animalsService: AnimalsService,
		private http: HttpClient,
		private router: Router,
		private activatedRoute: ActivatedRoute,
		public dialog: MatDialog,
		private snackBar: MatSnackBar
	) { }

	ngOnInit(): void {
		this.startPhotoGalleryLoader();
		this.startTrackGalleryLoader();
		//Highlight current view in side navigation
		document.getElementById('animals-route-link').classList.add('activeRoute');
		document.getElementById("animals-gallery-route").classList.add("activeRoute");
		this.tempTracks = [];

		//Determine which animal was navigated to and fetch their information
		const classificationQuery = new URLSearchParams(window.location.search);
		const animal = classificationQuery.get("classification").split("_");
		this.animalClassi = animal[0] + " " + animal[1];
		
		//Fetch animal from db
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsByClassification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", classification:"' + this.animalClassi + '"){classification,animalID,commonName,pictures{picturesID, URL, kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animal = temp[0];

				temp = [];
				this.animal['pictures'].forEach(element => {
					if(('' + element['kindOfPicture']).toLowerCase() == 'animal'){
						temp.push(element);
					}else{
						this.tempTracks.push(element);
					}
				});
				this.animal['pictures'] = temp;

				this.stopPhotoGalleryLoader();
		});
		//Fetch all track identifications for a the animal current being viewed
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", classification:"' +  this.animalClassi + '"){spoorIdentificationID,animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}}dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},confidence},picture{picturesID,URL,kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.tracksList = temp[0];
				this.tempTracks.forEach(e => {
					this.tracksList['pictures'].push(e);
				});
				this.stopTrackGalleryLoader();
		});	
	}
	
	//Functions for animal photo viewing and adding
	viewAnimalPhotoDetails(photoIndex: number) {
		//Open AnimalPhotoDetailsComponent and display the selected photo 
		const animalPhotoDetailsDialogRef = this.dialog.open(AnimalPhotoDetailsComponent, {
			height: '100%',
			width: '100%',
			autoFocus: true,
			disableClose: true,
			id: 'animal-photo-details-dialog',
			data: {
				initialIndex: photoIndex,
				entity: this.animal,
				photoType: "Animal"
			}
		});
		animalPhotoDetailsDialogRef.afterClosed().subscribe(result => {
			this.stopPhotoGalleryLoader()
			if (result == "success") {
				this.snackBar.open('Photo successfully set as main.', "Dismiss", { duration: 3000, });
				this.ngOnInit();
			}
			else if (result == 'error') {
				this.snackBar.open('An error occured when updating the main photo. Please try again.', "Dismiss", { duration: 5000, });
			}
		});
	}
	viewTrackPhotoDetails(photoIndex: number) {
		//Open AnimalPhotoDetailsComponent and display the selected photo 
		const animalPhotoDetailsDialogRef = this.dialog.open(AnimalPhotoDetailsComponent, {
			height: '100%',
			width: '100%',
			autoFocus: true,
			disableClose: true,
			id: 'animal-photo-details-dialog',
			data: {
				initialIndex: photoIndex,
				entity: this.tracksList,
				photoType: "Track"
			}
		});
	}
	openAddNewPhotoDialog() {
		const editDialogRef = this.dialog.open(AddImageComponent, {
			height: '75%',
			width: '60%',
			autoFocus: true,
			disableClose: true,
			id: 'add-image-dialog',
			data: {
				animal: this.animal
			},
		});
		editDialogRef.afterClosed().subscribe(result => {
			if (result == "success") {
				this.ngOnInit();
			}
			else if (result == 'error') {
				this.snackBar.open('An error occured when editting the animal. Please try again.', "Dismiss", { duration: 5000, });
			}
		});
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}

	viewAnimalProfile(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}
	
	//Loaders
	startPhotoGalleryLoader() {
		if (document.getElementById('animal-photo-gallery-loader') != null)
			document.getElementById('animal-photo-gallery-loader').style.visibility = 'visible';
	}
	stopPhotoGalleryLoader() {
		if (document.getElementById('animal-photo-gallery-loader') != null)
			document.getElementById('animal-photo-gallery-loader').style.visibility = 'hidden';
	}	
	startTrackGalleryLoader() {
		if (document.getElementById('animal-track-gallery-loader') != null)
			document.getElementById('animal-track-gallery-loader').style.visibility = 'visible';
	}
	stopTrackGalleryLoader() {
		if (document.getElementById('animal-track-gallery-loader') != null)
			document.getElementById('animal-track-gallery-loader').style.visibility = 'hidden';
	}
}
