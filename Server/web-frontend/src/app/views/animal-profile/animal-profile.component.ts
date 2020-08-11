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
		document.getElementById('animals-route').classList.add('activeRoute');
		//Determine which user was navigated to and fetch their information
		const classificationQuery = new URLSearchParams(window.location.search);
		const animal = classificationQuery.get("classification").split("_");
		
		this.animalClassi = animal[0] + " " + animal[1];
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsbyByClassification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", classification:"' + this.animalClassi + '"){classification,animalID,commonName,groupID{groupName},heightM,heightF,weightM,weightF,habitats{habitatID},dietType,' +
			'lifeSpan,gestationPeriod,animalOverview,animalDescription,pictures{URL}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animal = temp[0];
				
				//DUMMY DATA
				
				this.animal.animalOverview = "African Bush Elephants, also known as the African Savanna elephant," 
					+ " is the largest living terrestrial animal. Both sexes have tusks, which erupt when they are 1 - 3 years old and grow throughout life.";
					
				this.animal.animalDescription = this.animal.animalOverview + " The African Bush Elephant is the largest of the three elephant species and can weigh up to 6000kg and live up to " +
					+ "70 years - longer than any other mammal except humans." + " African Bush Elephants are herbivores and need to eat about " + "350 pounds of vegetation daily. The African Bush Elephant is "
					+ " characterized by two prominent tusks (present in both sexes), " + "two large ears, pillar-like legs, thickset body and a large head " + "with muscular, mobile trunk.";
				
				this.femaleBehaviour = "The adult male elephant rarely joins a herd and leads a solitary life, only approaching herds during mating season. "
					+ "In some cases adult bulls will join a small bachelor group of male elephants. Young bulls gradually separate from the "
					+ "family unit when they are between 10 and 19 years old.\n\n"
					+ "During musth manifestation periods, which may last from a few days to months, males show more aggression as a "
					+ "result of increased testosterone. Bulls begin to experience musth by the age of 24 years.";
				
				this.maleBehaviour = "The adult male elephant rarely joins a herd and leads a solitary life, only approaching herds during mating season. "
					+ "In some cases adult bulls will join a small bachelor group of male elephants. Young bulls gradually separate from the "
					+ "family unit when they are between 10 and 19 years old.\n\n"
					+ "During musth manifestation periods, which may last from a few days to months, males show more aggression as a"
					+ "result of increased testosterone. Bulls begin to experience musth by the age of 24 years.";
				
				this.stopLoader();
			});
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}
	
	//Ranger CRUD Quick-Actions
	//EDIT Ranger
	openEditAnimalDialog() {
		const editDialogRef = this.dialog.open(EditAnimalInfoComponent, {
			height: '85%', 
			width: '55%', 
			autoFocus: true, 
			disableClose: true,
			id: 'edit-animal-dialog',
			data: { 
				animal: this.animal
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
		elmnt.scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"});
	}
  
	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}

}
