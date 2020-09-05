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
	currentPhotoIndex: number;
	
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
		this.currentPhotoIndex = this.data.initialIndex;
	}

	//Open/close sidenav
	toggleSidenav() {
		this.sidenav.toggle();
	}
	
	//If the photo is of an animal, adapt height to respond to toggling the sidenav
	fillHeight()
	{
		if (this.data.photoType == 'Animal')
			document.getElementById("animal-photo-detail-current-image").style.height = '100%';
	}
	fillWidth()
	{
		if (this.data.photoType == 'Animal')
			document.getElementById("animal-photo-detail-current-image").style.height = '80%';
	}
	
	
	//Photo navigation functions
	nextPhoto()
	{
		//Temporary photo navigation solution until API updates 
		if (this.data.photoType != 'Single Track')
		{
			//Navigate to next photo. If last photo, navigate to first
			if (this.currentPhotoIndex >= (this.data.imageList.length - 1))
				this.currentPhotoIndex = 0;
			else if (this.currentPhotoIndex < (this.data.imageList.length - 1))
				this.currentPhotoIndex += 1;			
		}
	}
	prevPhoto()
	{
		//Temporary photo navigation solution until API updates 
		if (this.data.photoType != 'Single Track')
		{
			//Navigate to prev photo. If first photo, navigate to last
			if (this.currentPhotoIndex >= 1)
				this.currentPhotoIndex -= 1;
			else if (this.currentPhotoIndex < 1)
				this.currentPhotoIndex = (this.data.imageList.length - 1);
		}
	}
	
	//Miscellaneous Functions
	closeDialog()
	{
		this.dialogRef.close("cancel");	
	}
	route(temp: string) {
		this.router.navigate([temp]);
	}
	viewAnimalProfile(animalClassi: string) {
		this.dialogRef.close("cancel");	
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/information'], { queryParams: { classification: classificationQuery } });
	}
}
