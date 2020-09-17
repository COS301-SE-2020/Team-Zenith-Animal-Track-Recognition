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
	loading = false;
	submitted = false;
	
	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private formBuilder: FormBuilder, public dialogRef: MatDialogRef<EditRangerInfoComponent>) { }

	ngOnInit(): void {
		this.editUserForm = this.formBuilder.group({
			firstName: [this.data.firstName, [Validators.required, Validators.pattern(/^[a-z ,.'-]+$/i)]],
			lastName: [this.data.lastName, [Validators.required, Validators.pattern(/^[a-z ,.'-]+$/i)]],
			email: [this.data.email, [Validators.required, Validators.email]],
			phoneNumber: [this.data.phoneNumber, [Validators.required, Validators.minLength(7), Validators.maxLength(15), Validators.pattern(/^[0-9]+$/)]]
		});
		document.getElementById('edit-ranger-dialog').style.overflow = "hidden";
	}

//Form controls and error handling
	get editUser() { return this.editUserForm.controls; }
	validationMsg(formCtrl: any, formCtrlName: string) {
		if (formCtrl.hasError('required')) {
			return 'Please enter a value';
		}
		switch (formCtrlName) {
			case "firstName":
				return this.editUser.firstName.hasError('pattern') ? 'Please only enter letters' : '';
			break;
			case "lastName":
				return this.editUser.lastName.hasError('pattern') ? 'Please only enter letters' : '';
			break;
			case "email":
				return this.editUser.email.hasError('email') ? 'Please enter a valid email address i.e example@domain.com' : '';
			break;
			case "phoneNumber":
				if(this.editUser.phoneNumber.hasError('minlength'))
					return 'Phone number can not be less than 7 digits';		
				if(this.editUser.phoneNumber.hasError('maxlength'))
					return 'Phone number can not be more than 15 digits';				
				if(this.editUser.phoneNumber.hasError('pattern'))
					return 'Phone number can only contain digits';
			break;
		}
	}

	onSubmit(test: boolean) {
		if (test) { return true; }
		this.submitted = true;
		if (this.editUserForm.invalid) {
			return;
		}
		this.loading = true;
		this.startLoader();
		this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{updateUser(' + 'tokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'",' + 'rangerID:"' + this.data.rangerID + '",' + 'eMail:"' + this.editUser.email.value + '",' + 'lastName:"' + this.editUser.lastName.value + '",' +
			'phoneNumber:"' + this.editUser.phoneNumber.value + '",' + 'firstName:"' + this.editUser.firstName.value + '"){lastName,rangerID}}', '')
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
