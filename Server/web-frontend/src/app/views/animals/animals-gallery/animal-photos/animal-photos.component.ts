import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatTabsModule } from '@angular/material/tabs';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AnimalPhotoDetailsComponent } from './animal-photo-details/animal-photo-details.component'; 
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { AddImageComponent } from '../../add-image/add-image.component';

@Component({
  selector: 'app-animal-photos',
  templateUrl: './animal-photos.component.html',
  styleUrls: ['./animal-photos.component.css']
})
export class AnimalPhotosComponent implements OnInit {

	animal: any;
	animalClassi: string;
	femaleBehaviour: string;
	maleBehaviour: string;

	constructor(
		private http: HttpClient,
		private router: Router,
		private activatedRoute: ActivatedRoute,
		public dialog: MatDialog,
		private snackBar: MatSnackBar,
	) { }

	ngOnInit(): void {
		this.startLoader();
		//Highlight current view in side navigation
		document.getElementById('animals-route-link').classList.add('activeRoute');
		document.getElementById("animals-gallery-route").classList.add("activeRoute");
		
		//Determine which animal was navigated to and fetch their information
		const classificationQuery = new URLSearchParams(window.location.search);
		const animal = classificationQuery.get("classification").split("_");

		this.animalClassi = animal[0] + " " + animal[1];
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsByClassification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", classification:"' + this.animalClassi + '"){classification,animalID,commonName,pictures{URL, kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animal = temp[0];
				this.stopLoader();
			});
	}
	
	//Functions for animal photo viewing and adding
	viewAnimalPhotoDetails(photoUrl: string) {
		//Create fill media array with animal photos
		let index = 0;
		let photoIndex;
		let mediaList = [];
		for (let i = 0; i < this.animal.pictures.length; i++) {
			if (this.animal.pictures[i].kindOfPicture === 'Animal') {
				mediaList.push(this.animal.pictures[i]);
				if (this.animal.pictures[i].URL === photoUrl)
					photoIndex = index;
				index++;
			}
		}
		
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
				imageList: mediaList,
				photoType: "Animal"
			}
		});
	}
	viewTrackPhotoDetails(photoUrl: string) {
		//Create fill media array with animal photos
		let index = 0;
		let photoIndex;
		let mediaList = [];
		for (let i = 0; i < this.animal.pictures.length; i++) {
			if (this.animal.pictures[i].kindOfPicture === 'trak') {
				mediaList.push(this.animal.pictures[i]);
				if (this.animal.pictures[i].URL === photoUrl)
					photoIndex = index;
				index++;
			}
		}
		
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
				imageList: mediaList,
				photoType: "Track"
			}
		});
	}
	openAddNewImageDialog() {
		const editDialogRef = this.dialog.open(AddImageComponent, {
			height: '75%',
			width: '60%',
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

	route(temp: string) {
		this.router.navigate([temp]);
	}

	viewAnimalProfile(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}
	
	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}
