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
	@Input() searchText: string;
	@Input() selection: string;
	@Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();
	@Output() searchTextOnChange: EventEmitter<string> = new EventEmitter();
	@Output() sortOptionOnChange: EventEmitter<string> = new EventEmitter();

	currentAlphabet: any;
	sorted: string;
	display: boolean = true;

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
		this.router.navigate([location]);
	}

	checkIfNew(title: string, pos: number) {
		if (this.currentAlphabet === ('' + title).charAt(pos).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ('' + title).charAt(pos).toLowerCase();
			return true;
		}
	}

	updateSearchText(event) {
		if (!this.rangers || this.rangers.length == 0) {
			return;
		}
		if (this.rangers.length == 1) {
			return;
		}
		this.searchTextOnChange.emit(event);
		if ((<HTMLInputElement>document.getElementById("search-sidenav-input")).value == "")
			this.currentAlphabet = null;
	}

	sort(selection: string) {
		if (!this.rangers || this.rangers.length == 0) {
			this.snackBar.open('There is no data to sort. Please add a ranger and try again.', "Dismiss", { duration: 5000, });			
			return;
		}
		if (this.rangers.length == 1) {
			this.snackBar.open('Sorting requires two or more rangers.', "Dismiss", { duration: 5000, });			
			return;
		}
		this.sortOptionOnChange.emit(selection);
	}

	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}








