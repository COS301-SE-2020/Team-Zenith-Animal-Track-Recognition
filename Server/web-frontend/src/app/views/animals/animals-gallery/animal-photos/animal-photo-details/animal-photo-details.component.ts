import { Component, OnInit, Inject, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-animal-photo-details',
  templateUrl: './animal-photo-details.component.html',
  styleUrls: ['./animal-photo-details.component.css']
})
export class AnimalPhotoDetailsComponent implements OnInit {
	
	@ViewChild('sidenav') sidenav: any;
	currentImageIndex: number;

	/*Place holder values*/
	trackInfoPlaceholder = [
		{
			commonName: 'Elephant',
			classification: 'Loxodonta Africanus',
			trackLocation: 'Kruger National Park',
			coordinates: '-24.019097, 31.559270',
			accuracyScore: '67%',
			capturedBy: 'Kagiso Ndlovu',
			date: '09/09/2020',
			dayTime: 'Fri, 09:17'
		}
	];
	
	constructor(
		@Inject(MAT_DIALOG_DATA) public data: any, 
		private router: Router, 
		public dialogRef: MatDialogRef<AnimalPhotoDetailsComponent>) { }

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
		this.currentImageIndex = this.data.currentIndex;
	}
	
	toggleSidenav() {
		this.sidenav.toggle();
	}
	fillHeight()
	{
		if (!this.data.isTrack)
			document.getElementById("animal-photo-detail-current-image").style.height = '100%';
	}
	fillWidth()
	{
		if (!this.data.isTrack)
			document.getElementById("animal-photo-detail-current-image").style.height = '80%';
	}
	isTrack()
	{
		return this.data.isTrack;
	}
	viewAnimalProfile(animalClassi: string) {
		this.dialogRef.close("cancel");	
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}
	route(temp: string) {
		this.router.navigate([temp]);
	}
	
	prevImage()
	{
		if (this.data.isTrack)
		{
		}
		else 
		{
			if (this.currentImageIndex >= 1)
				this.currentImageIndex -= 1;
			else if (this.currentImageIndex < 1)
				this.currentImageIndex = this.data.imageList.length - 1;

			this.data.currentImage = this.data.imageList[this.currentImageIndex].URL;
		}
	}
	
	nextImage()
	{
		if (this.data.isTrack)
		{
		}
		else 
		{
			if (this.currentImageIndex >= (this.data.imageList.length - 1))
				this.currentImageIndex = 0;
			else if (this.currentImageIndex < (this.data.imageList.length - 1))
				this.currentImageIndex += 1;

			this.data.currentImage = this.data.imageList[this.currentImageIndex].URL;
		}
	}
	
	closeDialog()
	{
		this.dialogRef.close("cancel");	
	}

}
