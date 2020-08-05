import { first } from 'rxjs/operators';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

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
		private router: Router,
		public dialogRef: MatDialogRef<DeleteRangerComponent>) { }

	ngOnInit(): void {
		this.temp = false;
	}

	confirmDelete(test: boolean) {
		if (test) { return true; }
		this.startLoader();
		console.log(this.data.token);
		this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{deleteUser(' + 'tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'",' + 'tokenDelete:"' + this.data.token + '"){msg}}', '')
			.subscribe({
				next: data => this.dialogRef.close("success"),
				error: error => this.dialogRef.close("error")
			});
	}
	closeDialog() {
		this.dialogRef.close("cancel");
	}

	//Loader
	startLoader() {
		document.getElementById("loader-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("loader-container").style.visibility = "hidden";
	}
}
