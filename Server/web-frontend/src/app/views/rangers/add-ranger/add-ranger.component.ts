import { MatSnackBar } from '@angular/material/snack-bar';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';
import { EMPTY } from 'rxjs';
import { retry, catchError } from 'rxjs/operators';

@Component({
	selector: 'app-add-ranger',
	templateUrl: './add-ranger.component.html',
	styleUrls: ['./add-ranger.component.css']
})
export class AddRangerComponent implements OnInit {
	addUserForm: FormGroup;
	loading = false;
	submitted = false;
	minRangerAge = 16;
	maxRangerAge = 100;
	maxDate = new Date(new Date().getFullYear() - this.minRangerAge, new Date().getMonth(), new Date().getDay());

	hide = true;
	constructor(private formBuilder: FormBuilder,
		private router: Router,
		private snackBar: MatSnackBar,
		private http: HttpClient,
		public dialogRef: MatDialogRef<AddRangerComponent>) { }

	ngOnInit(): void {
		this.addUserForm = this.formBuilder.group({
			firstName: ['', [Validators.required, Validators.pattern(/^[a-z ,.'-]+$/i)]],
			lastName: ['', [Validators.required, Validators.pattern(/^[a-z ,.'-]+$/i)]],
			email: ['', [Validators.required, Validators.email]],
			phoneNumber: ['', [Validators.required, Validators.minLength(7), Validators.maxLength(15), Validators.pattern(/^[0-9, ()+-]+$/)]],
			password: ['', Validators.required],
			dob: ['', Validators.required]
		});
		document.getElementById('add-ranger-dialog').style.overflow = "hidden";
	}

	//Form controls and error handling
	get addUser() { return this.addUserForm.controls; }
	validationMsg(formCtrl: any, formCtrlName: string) {
		if (formCtrl.hasError('required')) {
			return 'Please enter a value';
		}
		switch (formCtrlName) {
			case "firstName":
				return this.addUser.firstName.hasError('pattern') ? 'Please only enter letters' : '';
				break;
			case "lastName":
				return this.addUser.lastName.hasError('pattern') ? 'Please only enter letters' : '';
				break;
			case "email":
				return this.addUser.email.hasError('email') ? 'Please enter a valid email address i.e example@domain.com' : '';
				break;
			case "phoneNumber":
				if (this.addUser.phoneNumber.hasError('minlength'))
					return 'Phone number can not be less than 7 digits';
				if (this.addUser.phoneNumber.hasError('maxlength'))
					return 'Phone number can not be more than 15 digits';
				if (this.addUser.phoneNumber.hasError('pattern'))
					return 'Phone number can only contain digits';
				break;
		}
	}

	onSubmit(test: boolean) {
		if (test) { return true; }
		this.submitted = true;
		if (this.addUserForm.invalid) {
			return;
		}
		this.loading = true;
		this.startLoader();
		let phoneNumber: string = "" + this.addUser.phoneNumber.value;
		phoneNumber = phoneNumber.trim();

		this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{addUser(firstName:"' + encodeURIComponent(this.addUser.firstName.value) +
			'",lastName:"' + encodeURIComponent(this.addUser.lastName.value) + '",password:"' + encodeURIComponent(this.addUser.password.value) +
			'",token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",accessLevel:"1",eMail:"' +
			encodeURIComponent(this.addUser.email.value) + '",phoneNumber:"' + encodeURIComponent(phoneNumber) + '"){lastName}}', '')
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


	attachProgressbar() {
		//Append progress bar to dialog
		let matDialog = document.getElementById('add-ranger-dialog');
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
