import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { MatSnackBar } from '@angular/material/snack-bar';
import { MatOption } from '@angular/material/core';

@Component({
	selector: 'app-track-identifications-toolbar',
	templateUrl: './track-identifications-toolbar.component.html',
	styleUrls: ['./track-identifications-toolbar.component.css']
})
export class TrackIdentificationsToolbarComponent implements OnInit {

	@Input() searchText: string;
	@Input() trackIds;
	@Output() tracksOnChange: EventEmitter<Object> = new EventEmitter();
	filterOptions: any = [];

	constructor(private router: Router, public dialog: MatDialog, private http: HttpClient, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		// this.filterOptions[0] = 'test';
		// var temp = document.createElement("mat-option");
		// temp.innerHTML = "Test";
		// console.log(temp);

		// document.getElementById('identifications-filter-btn').appendChild(temp);
		// console.log(document.getElementById('identifications-filter-btn'));
	}

	route(location: string) {
		this.router.navigate([location]);
	}
}