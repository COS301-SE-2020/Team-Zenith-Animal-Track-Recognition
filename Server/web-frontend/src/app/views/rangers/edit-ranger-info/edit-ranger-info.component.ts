import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

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
	}

	get f() { return this.editUserForm.controls; }

	onSubmit(test: boolean) {
		if (false === test) {
			this.startLoader();
			// console.log(ROOT_QUERY_STRING + '?query=mutation{updateUser(' + 'tokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			// 	'",' + 'tokenChange:"' + this.data.token + '",' + 'eMail:"' + this.f.email.value + '",' + 'lastName:"' + this.f.lastName.value + '",' +
			// 	'phoneNumber:"' + this.f.phoneNumber.value + '",' + 'firstName:"' + this.f.firstName.value + '"){lastName,token}}');
			this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{updateUser(' + 'tokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
				'",' + 'tokenChange:"' + this.data.token + '",' + 'eMail:"' + this.f.email.value + '",' + 'lastName:"' + this.f.lastName.value + '",' +
				'phoneNumber:"' + this.f.phoneNumber.value + '",' + 'firstName:"' + this.f.firstName.value + '"){lastName,token}}', '')
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

	//Loader
	startLoader() {
		document.getElementById("loader-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("loader-container").style.visibility = "hidden";
	}
}
