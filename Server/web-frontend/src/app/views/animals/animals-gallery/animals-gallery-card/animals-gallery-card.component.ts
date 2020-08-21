import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-animals-gallery-card',
  templateUrl: './animals-gallery-card.component.html',
  styleUrls: ['./animals-gallery-card.component.css']
})
export class AnimalsGalleryCardComponent implements OnInit {

	@Input() animalsList: any;
	@Input() searchText: string;
	@Input() sortByCommonName: boolean;
	@Output() animalsOnChange: EventEmitter<Object> = new EventEmitter();

	constructor(
		private http: HttpClient, 
		private router: Router, 
		public dialog: MatDialog, 
		private changeDetection: ChangeDetectorRef, 
		private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		this.startLoader();
	}
	

	public ngOnChanges(changes: SimpleChanges) {
		this.startLoader();
		if (changes.animals) {
		//If animals has updated
		this.changeDetection.detectChanges();
		}
		this.stopLoader();
	}

	//Animal CRUD Quick-Actions

	//EDIT 
	/*
	openEditAnimalDialog(animalID) {

		const dialogConfig = new MatDialogConfig();

		//Get animal information for chosen card
		var chosenAnimal;
    for (let i = 0; i < this.animalsList.length; i++) {
      if (animalID == this.animalsList[i].animalID) {
        chosenAnimal = this.animalsList[i];
        i = this.animalsList[i].length;
      }
    }
    const editDialogRef = this.dialog.open(EditAnimalInfoComponent, {
      height: '80%',
      width: '55%',
      autoFocus: true,
      disableClose: true,
      id: 'edit-animal-dialog',
      data: {
        animal: chosenAnimal
      },
    });
	
    editDialogRef.afterClosed().subscribe(result => {
		this.stopLoader();
		if (result == "success") {
			//If animal was successfully edited refresh component and notify parent
			this.animalsOnChange.emit('update');
		}
		else if (result == 'error') {
			this.snackBar.open('An error occured when editting the animal. Please try again.', "Dismiss", { duration: 5000, });
		}
		});
	}
	*/
	viewAnimalPhotos(animalClassi: string) {
		let classification = animalClassi.split(" ");
		let classificationQuery = classification[0] + "_" + classification[1];
		this.router.navigate(['animals/gallery/photos'], { queryParams: { classification: classificationQuery } });
	}

	route(temp: string) {
		document.getElementById("animals-route-link").classList.remove("activeRoute");
		document.getElementById("animals-gallery-route").classList.remove("activeRoute");
		document.getElementById("overview-route").classList.remove("activeRoute");
		document.getElementById("rangers-route").classList.remove("activeRoute");
		document.getElementById("geotags-route").classList.remove("activeRoute");
		document.getElementById("settings-route").classList.remove("activeRoute");
		
		this.router.navigate([temp]);
	}


	sort(bool: boolean) {
		if (bool) {
		  for (let i = 0; i < this.animalsList.length - 1; i++) {
			for (let j = i + 1; j < this.animalsList.length; j++) {
			  if (this.animalsList[i].commonName.toUpperCase() > this.animalsList[j].commonName.toUpperCase()) {
				let temp = this.animalsList[i];
				this.animalsList[i] = this.animalsList[j];
				this.animalsList[j] = temp;
			  }
			}
		  }
		} else {
		  for (let i = 0; i < this.animalsList.length - 1; i++) {
			for (let j = i + 1; j < this.animalsList.length; j++) {
			  if (this.animalsList[i].accessLevel > this.animalsList[j].accessLevel) {
				let temp = this.animalsList[i];
				this.animalsList[i] = this.animalsList[j];
				this.animalsList[j] = temp;
			  }
			}
		  }
		}
	}
  
	//Loader
	startLoader() {
		document.getElementById("loader-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("loader-container").style.visibility = "hidden";
	}

}