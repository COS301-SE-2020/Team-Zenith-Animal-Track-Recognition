import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { AnimalsService } from './../../../../../services/animals.service';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { Router } from '@angular/router';
import { catchError, retry } from 'rxjs/operators';
import { EMPTY } from 'rxjs';

@Component({
	selector: 'app-animal-photo-details',
	templateUrl: './animal-photo-details.component.html',
	styleUrls: ['./animal-photo-details.component.css']
})
export class AnimalPhotoDetailsComponent implements OnInit {

	@ViewChild('sidenav') sidenav: any;
	activeTrack: any = null;
	currentPhotoIndex: number;
	trackList: any;
	
	constructor(
		private animalsService: AnimalsService,
		@Inject(MAT_DIALOG_DATA) public data: any,
		public dialogRef: MatDialogRef<AnimalPhotoDetailsComponent>,
		private http: HttpClient,
		private router: Router,
		private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		//Style the modal/dialog
		document.getElementById("animal-photo-details-dialog").style.backgroundColor = "black";
		document.getElementById("animal-photo-details-dialog").style.borderRadius = "0";
		document.getElementById("animal-photo-details-dialog").style.left = "0";
		document.getElementById("animal-photo-details-dialog").style.minWidth = "100vw";
		document.getElementById("animal-photo-details-dialog").style.minHeight = "100vh";
		document.getElementById("animal-photo-details-dialog").style.padding = "0";
		document.getElementById("animal-photo-details-dialog").style.position = "absolute";

		//Determine index of currently viewed image
		this.currentPhotoIndex = this.data.initialIndex;

		if (this.data.photoType == "Track") {
			this.startSidenavLoader();
			this.activeTrack = this.data.entity[this.currentPhotoIndex];
			this.stopSidenavLoader();
		}
	}

	//Open/close sidenav
	toggleSidenav() {
		this.sidenav.toggle();
	}
	closeSideNav(status: any) {
		this.sidenav.close();
	}

	//If the photo is of an animal, adapt height to respond to toggling the sidenav
	fillHeight() {
		if (this.data.photoType == 'Animal')
			document.getElementById("animal-photo-detail-current-image").style.height = '100%';
	}
	fillWidth() {
		if (this.data.photoType == 'Animal')
			document.getElementById("animal-photo-detail-current-image").style.height = '80%';
	}

	//Photo navigation & setting functions
	nextPhoto() {
		//Navigate to next photo. If last photo, navigate to first
		if (this.data.photoType == 'Animal') {
			if (this.currentPhotoIndex >= (this.data.entity.pictures.length - 1))
				this.currentPhotoIndex = 0;
			else if (this.currentPhotoIndex < (this.data.entity.pictures.length - 1))
				this.currentPhotoIndex += 1;
		}
		else if (this.data.photoType == 'Track') {
			if (this.currentPhotoIndex >= (this.data.entity.length - 1)) {
				this.currentPhotoIndex = 0;
				this.activeTrack = this.data.entity[this.currentPhotoIndex];
			}
			else if (this.currentPhotoIndex < (this.data.entity.length - 1)) {
				this.currentPhotoIndex += 1;
				this.activeTrack = this.data.entity[this.currentPhotoIndex];
			}
		}

	}
	prevPhoto() {
		//Navigate to prev photo. If first photo, navigate to last
		if (this.data.photoType == 'Animal') {
			if (this.currentPhotoIndex >= 1)
				this.currentPhotoIndex -= 1;
			else if (this.currentPhotoIndex < 1)
				this.currentPhotoIndex = (this.data.entity.pictures.length - 1);
		}
		else if (this.data.photoType == 'Track') {
			if (this.currentPhotoIndex >= 1) {
				this.currentPhotoIndex -= 1;
				this.activeTrack = this.data.entity[this.currentPhotoIndex];
			}
			else if (this.currentPhotoIndex < 1) {
				this.currentPhotoIndex = (this.data.entity.length - 1);
				this.activeTrack = this.data.entity[this.currentPhotoIndex];
			}
		}
	}
	setAsMainPhoto(index: number) {
		//this.startLoader();
		if (index == 0) {
			this.snackBar.open('The photo you have selected is already the main photo.', "Dismiss", { duration: 5000, });
			return;
		}
		let newEntityImageList = [this.data.entity.pictures[index].picturesID];

		//Remove photo from original list
		for (let i = 0; i < this.data.entity.pictures.length; i++) {
			if (this.data.entity.pictures[i].picturesID !== newEntityImageList[0])
				newEntityImageList.push(this.data.entity.pictures[i].picturesID);
		}

		//Update entity in database
		this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{' + 'updateAnimal(token:"' + encodeURIComponent(JSON.parse(localStorage.getItem('currentToken'))['value']) +
			'",classification:"' + encodeURIComponent(this.data.entity.classification) + '",pictures:' + encodeURIComponent(JSON.stringify(newEntityImageList)) + '){animalID}}', '')
			.pipe(
				retry(3),
				catchError(() => {
					this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
					this.stopLoader();
					this.stopSidenavLoader();
					return EMPTY;
				})
			)
			.subscribe({
				next: data => this.dialogRef.close('success'),
				error: error => this.dialogRef.close('error')
			});
	}

	//Miscellaneous Functions
	closeDialog() {
		this.dialogRef.close("cancel");
	}
	route(temp: string) {
		this.router.navigate([temp]);
	}
	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
	//Sidenav Loader
	startSidenavLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'visible';
	}
	stopSidenavLoader() {
		document.getElementById('search-nav-loader-container').style.visibility = 'hidden';
	}
	viewAnimalProfile(animalClassi: string) {
		this.dialogRef.close("cancel");
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}
	viewOnTrackMap(trackId: any) {
		this.dialogRef.close("cancel");
		this.router.navigate(['identifications'], { queryParams: { openTrackId: trackId } });
	}
}
