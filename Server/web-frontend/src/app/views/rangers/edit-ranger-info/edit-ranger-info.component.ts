import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import {MatProgressBarModule} from '@angular/material/progress-bar'; 

@Component({
	selector: 'app-edit-ranger-info',
	templateUrl: './edit-ranger-info.component.html',
	styleUrls: ['./edit-ranger-info.component.css']
})
export class EditRangerInfoComponent implements OnInit {
	editUserForm: FormGroup;

	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private formBuilder: FormBuilder, public dialogRef: MatDialogRef<EditRangerInfoComponent>) { }

	ngOnInit(): void {
		this.editUserForm = this.formBuilder.group({
			firstName: [this.data.firstName, Validators.required],
			lastName: [this.data.lastName, Validators.required],
			email: [this.data.email, Validators.required],
			phoneNumber: [this.data.phoneNumber, Validators.required]
		});
		document.getElementById('edit-ranger-dialog').style.overflow = "hidden";
	}

	get f() { return this.editUserForm.controls; }

	onSubmit(test: boolean) {
		if (false === test) {
			this.startLoader();
			// console.log(ROOT_QUERY_STRING + '?query=mutation{updateUser(' + 'tokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			// 	'",' + 'tokenChange:"' + this.data.token + '",' + 'eMail:"' + this.f.email.value + '",' + 'lastName:"' + this.f.lastName.value + '",' +
			// 	'phoneNumber:"' + this.f.phoneNumber.value + '",' + 'firstName:"' + this.f.firstName.value + '"){lastName,token}}');
			this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{updateUser(' + 'tokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
				'",' + 'rangerID:"' + this.data.rangerID + '",' + 'eMail:"' + this.f.email.value + '",' + 'lastName:"' + this.f.lastName.value + '",' +
				'phoneNumber:"' + this.f.phoneNumber.value + '",' + 'firstName:"' + this.f.firstName.value + '"){lastName,rangerID}}', '')
				.subscribe({ 
					next: data => this.dialogRef.close("success"), 
					error: error => this.dialogRef.close("error")
				});
		}
		else {
			return true;
		}
	}
	closeDialog() {
		this.dialogRef.close("cancel");
	}
	
	attachProgressbar()
	{
		//Append progress bar to dialog
		let matDialog = document.getElementById('edit-ranger-dialog');
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
