import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges, ChangeDetectorRef } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-track-identifications-map',
  templateUrl: './track-identifications-map.component.html',
  styleUrls: ['./track-identifications-map.component.css']
})
export class TrackIdentificationsMapComponent implements OnInit {

	@Input() searchText: string;
	@Input() rangersList;
	numRangers: any;
	@Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();
	sorted: string;
	
	constructor(private http: HttpClient, private router: Router, private changeDetection: ChangeDetectorRef, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		//this.startLoader(); 
	}
	
	public ngOnChanges(changes: SimpleChanges) {
		this.startLoader();
		if (changes.rangers) {
			//If rangers has updated
			this.changeDetection.detectChanges();
		}
		this.stopLoader();
	}

	//Ranger CRUD Quick-Actions
	route(temp: string) {
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
