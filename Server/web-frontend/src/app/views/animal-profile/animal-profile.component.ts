import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { ViewportScroller } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatTabsModule } from '@angular/material/tabs';
import { EditAnimalInfoComponent } from './../animals/edit-animal-info/edit-animal-info.component';
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
	femaleBehaviour: string;
	maleBehaviour: string;


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
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}
	viewAnimalPhotos(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/gallery/photos'], { queryParams: { classification: classificationQuery } });
	}

	//Ranger CRUD Quick-Actions
	//EDIT Ranger
	openEditAnimalDialog(t: number) {
		const editDialogRef = this.dialog.open(EditAnimalInfoComponent, {
			height: '85%',
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
				//If animal was successfully edited refresh component and notify parent
				//this.animalsOnChange.emit('update');
			}
			else if (result == 'error') {
				this.snackBar.open('An error occured when editting the animal. Please try again.', "Dismiss", { duration: 5000, });
			}
		});
	}
	navigateToSection(elementId: string): void {
		const elmnt = document.getElementById(elementId);
		elmnt.scrollIntoView({ behavior: "smooth", block: "start", inline: "nearest" });
	}

	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}
