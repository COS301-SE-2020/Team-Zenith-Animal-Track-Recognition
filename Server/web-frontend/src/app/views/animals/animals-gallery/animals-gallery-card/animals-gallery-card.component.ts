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
	@Output() animalsOnChange: EventEmitter<Object> = new EventEmitter();
	test: boolean = false;
	@Input() selection: string;

	constructor(
		private http: HttpClient, 
		private router: Router, 
		public dialog: MatDialog, 
		private changeDetection: ChangeDetectorRef, 
		private snackBar: MatSnackBar) 
	{ }

	public ngOnChanges(changes: SimpleChanges) {
		if (changes.animalsList) {
			this.stopLoader();
		}
	}

	ngOnInit(): void {
		this.test = true;
		this.stopLoader();
	}

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
  
	//Loader
	startLoader() {
		document.getElementById("loader-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("loader-container").style.visibility = "hidden";
	}

}
