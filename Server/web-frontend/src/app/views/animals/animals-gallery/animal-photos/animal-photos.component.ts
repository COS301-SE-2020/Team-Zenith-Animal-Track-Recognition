import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatTabsModule } from '@angular/material/tabs';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AnimalPhotoDetailsComponent } from './animal-photo-details/animal-photo-details.component'; 
import { ROOT_QUERY_STRING } from 'src/app/models/data';

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
	
	/*Place holder values*/
	defaultImage = "https://upload.wikimedia.org/wikipedia/commons/8/86/Solid_grey.svg";
	trackImages = [
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		},		
		{
			imagePlaceholder: 'Elephant',
		}
	];

	constructor(
		private http: HttpClient,
		private router: Router,
		private activatedRoute: ActivatedRoute,
		public dialog: MatDialog,
		private snackBar: MatSnackBar,
	) { }

	ngOnInit(): void {
		this.startLoader();
		document.getElementById('animals-route-link').classList.add('activeRoute');
		document.getElementById("animals-gallery-route").classList.add("activeRoute");
		//Determine which user was navigated to and fetch their information
		const classificationQuery = new URLSearchParams(window.location.search);
		const animal = classificationQuery.get("classification").split("_");

		this.animalClassi = animal[0] + " " + animal[1];
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsByClassification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", classification:"' + this.animalClassi + '"){classification,animalID,commonName,groupID{groupName},heightM,heightF,weightM,weightF,habitats{habitatID},dietType,' +
			'lifeSpan,gestationPeriod,animalOverview,animalDescription,pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animal = temp[0];
				this.stopLoader();
			});
	}
	
	openPhotoDetails(isTrack: boolean, photoUrl: any, photoIndex: number) {
		const animalPhotoDetailsDialogRef = this.dialog.open(AnimalPhotoDetailsComponent, {
			height: '100%',
			width: '100%',
			autoFocus: true,
			disableClose: true,
			id: 'animal-photo-details-dialog',
			data: {
				isTrack: isTrack,
				currentImage: photoUrl,
				currentIndex: photoIndex,
				imageList: this.animal.pictures,
				animal: this.animal
			},
		});
		animalPhotoDetailsDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			if (result == "success") {
				//If animal was successfully edited refresh component and notify parent
				//this.animalsOnChange.emit('update');
			}
			else if (result == 'error') {
				//this.snackBar.open('An error occured when editting the animal. Please try again.', "Dismiss", { duration: 5000, });
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
