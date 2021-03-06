import { MatSnackBar } from '@angular/material/snack-bar';
import { catchError, first, retry } from 'rxjs/operators';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { EMPTY } from 'rxjs';

@Component({
	selector: 'app-delete-ranger',
	templateUrl: './delete-ranger.component.html',
	styleUrls: ['./delete-ranger.component.css']
})
export class DeleteRangerComponent implements OnInit {

	temp: boolean;

	constructor(
		@Inject(MAT_DIALOG_DATA) public data: any,
		private http: HttpClient,
		private snackBar: MatSnackBar,
		private router: Router,
		public dialogRef: MatDialogRef<DeleteRangerComponent>) { }

	ngOnInit(): void {
		this.temp = false;
		document.getElementById('delete-ranger-dialog').style.overflow = "hidden";
	}

	confirmDelete(test: boolean) {
		if (test) { return true; }
		this.startLoader();
		this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{deleteUser(' + 'tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'",' + 'rangerID:"' + this.data.rangerID + '"){msg}}', '')
			.pipe(
				retry(3),
				catchError(() => {
					this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
					this.stopLoader();
					return EMPTY;
				})
			)
			.subscribe({
				next: data => this.dialogRef.close("success"),
				error: error => this.dialogRef.close("error")
			});
	}
	closeDialog() {
		this.dialogRef.close("cancel");
	}

	attachProgressbar()
	{
		//Append progress bar to dialog
		let matDialog = document.getElementById('delete-ranger-dialog');
		let progressBar = document.getElementById("dialog-progressbar-container");
		matDialog.insertBefore(progressBar, matDialog.firstChild);
	}

	//Loader - Progress bar
	startLoader() {
		this.attachProgressbar();
		document.getElementById("dialog-progressbar-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("dialog-progressbar-container").style.visibility = "hidden";
	}
}
