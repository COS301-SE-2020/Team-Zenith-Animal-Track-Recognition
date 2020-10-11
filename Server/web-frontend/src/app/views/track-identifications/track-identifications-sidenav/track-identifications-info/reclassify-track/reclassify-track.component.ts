import { MatSnackBar } from '@angular/material/snack-bar';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';
import { EMPTY } from 'rxjs';
import { retry, catchError } from 'rxjs/operators';
import {Observable} from 'rxjs';
import {startWith, map} from 'rxjs/operators';

export const _filter = (opt: string[], value: string): string[] => {
  const filterValue = value.toLowerCase();

  return opt.filter(item => item.toLowerCase().indexOf(filterValue) === 0);
};

@Component({
  selector: 'app-reclassify-track',
  templateUrl: './reclassify-track.component.html',
  styleUrls: ['./reclassify-track.component.css']
})

export class ReclassifyTrackComponent implements OnInit {
	
	animalListForm: FormGroup;
	animalGroupOptions: Observable<any[]>;
	animalABCGroup: any [] = [];
	animals: any [] = [];
	animalNames: any [] = [];

	addUserForm: FormGroup;
	loading = false;
	submitted = false;
	minRangerAge = 16;
	maxRangerAge = 100;

	hide = true;
	constructor(private formBuilder: FormBuilder,
		private router: Router,
		@Inject(MAT_DIALOG_DATA) public data: any,
		private snackBar: MatSnackBar,
		private http: HttpClient,
		public dialogRef: MatDialogRef<ReclassifyTrackComponent>) { }

	ngOnInit(): void {
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animals(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(Object.values(data)[0])[0]);
				temp.forEach(element => {
					this.animalNames.push(element['commonName']);
					this.animals.push(element);
				});
				this.sortAnimalList();
			});
			
		var toAnimalName = "";
		if (this.data.toAnimal) 
			toAnimalName = this.data.toAnimal.commonName;
		
		this.animalListForm = this.formBuilder.group({
			animalGroupFormControl: [toAnimalName, Validators.required]
		});
		this.animalGroupOptions = this.animalListForm.get('animalGroupFormControl')!.valueChanges
		.pipe(
			startWith(''),
			map(value => this._filterGroup(value))
		);
		this.animalListForm.controls['animalGroupFormControl'].valueChanges.subscribe(val => {
			if (val != null && this.animalNames.includes(val)) {
				this.data.toAnimal = this.animals.filter(animal => animal.commonName == val)[0];
			}
		});
		document.getElementById('reclassify-track-dialog').style.overflow = "hidden";
	}
	
	sortAnimalList() {
		this.animalNames.sort();
		var letterGroup = [];
		var letterList = [];
		var letter = "A";
		for (let i = 0; i < this.animalNames.length; i++) {
			letterGroup = [];
			letter = this.animalNames[i].charAt(0);
			if (!letterList.includes(letter)) {
				letterList.push(letter);
			}	
			while (i < this.animals.length && this.animalNames[i].charAt(0) == letter) {
				letterGroup.push(this.animalNames[i]);
				i++;
			}			
			i--;
			this.animalABCGroup.push({letter: letter, names: letterGroup});
		}
	}

	//Form controls and error handling	
	validationMsg(formCtrl: any, formCtrlName: string) {
		/*
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
		}*/
	}
	

	private _filterGroup(value: string): any[] {
		if (value) {
			return this.animalABCGroup
			.map(group => ({letter: group.letter, names: _filter(group.names, value)}))
			.filter(group => group.names.length > 0);
		}
		return this.animalABCGroup;
	}

	onSubmit(test: boolean) {
		if (test) { return true; }
		this.submitted = true;
		/*if (this.addUserForm.invalid) {
			return;
		}*/
		this.loading = true;
		this.startLoader();
		//let phoneNumber: string = "" + this.addUser.phoneNumber.value;
		//phoneNumber = phoneNumber.trim();
		/*
		this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{addUser(firstName:"' + encodeURIComponent(this.addUser.firstName.value) +
			'",lastName:"' + encodeURIComponent(this.addUser.lastName.value) + '",password:"' + encodeURIComponent(this.addUser.password.value) +
			'",token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",accessLevel:"1",eMail:"' +
			encodeURIComponent(this.addUser.email.value) + '",phoneNumber:"' + encodeURIComponent(phoneNumber) + '"){lastName}}', '')
			.pipe(
				retry(3),
				catchError(() => {
					this.stopLoader();
					return EMPTY;
				})
			)
			.subscribe({
				next: data => this.dialogRef.close("success"),
				error: error => this.dialogRef.close("error")
			});
			*/
	}
	
	
	closeDialog() {
		this.dialogRef.close("cancel");
	}


	attachProgressbar() {
		//Append progress bar to dialog
		let matDialog = document.getElementById('reclassify-track-dialog');
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
