import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { AddRangerComponent } from './../add-ranger/add-ranger.component';
import { HttpClient } from '@angular/common/http';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
	selector: 'app-rangers-toolbar',
	templateUrl: './rangers-toolbar.component.html',
	styleUrls: ['./rangers-toolbar.component.css']
})
export class RangersToolbarComponent implements OnInit {
	@Input() rangers;
	@Input() sortBySurname: boolean;
	@Output() rangersOnChange: EventEmitter<string> = new EventEmitter();
	@Output() sBSOnChange: EventEmitter<string> = new EventEmitter();
	currentAlphabet: any;
	sortByLevel: boolean = false;
	sorted: string;
	display: boolean = false;
	
	constructor(private router: Router, public dialog: MatDialog, private http: HttpClient, private snackBar: MatSnackBar) { }
	
	ngOnInit(): void { }

	openAddRangerDialog() {
		const dialogConfig = new MatDialogConfig();

		const addDialogRef = this.dialog.open(AddRangerComponent, { 
			height: '55%', 
			width: '35%', 
			id: 'add-ranger-dialog', 
			autoFocus: true, 
			disableClose: true 
		});
		addDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			if (result == 'success') {
				//If ranger was successfully added, refresh component and notify parent
				this.rangersOnChange.emit('add');
			}
			else if (result == 'error') {
				this.snackBar.open('An error occured when adding the new ranger. Please try again.', "Dismiss", { duration: 5000, });
			}
		});
	}

	route(location: string) {
		document.getElementById('animals-route').classList.remove('activeRoute');
		document.getElementById('overview-route').classList.remove('activeRoute');
		document.getElementById('rangers-route').classList.remove('activeRoute');
		document.getElementById('geotags-route').classList.remove('activeRoute');
		document.getElementById('settings-route').classList.remove('activeRoute');

		this.router.navigate([location]);
	}
	
	toggle(bool: boolean) {
		this.sortBySurname = bool;
		this.sort(bool);
		this.sBSOnChange.emit('' + bool);
	}

	sort(bool: boolean) {
		let temp: string;
		if (bool) {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].lastName.toUpperCase() > this.rangers[j].lastName.toUpperCase()) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
			temp = "Sorted alphabetically";
		} else {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].Access_Level > this.rangers[j].Access_Level) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
			temp = "Sorted by ranger level";
		}
		this.sorted = temp;
		return temp;
	}
	
	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}








