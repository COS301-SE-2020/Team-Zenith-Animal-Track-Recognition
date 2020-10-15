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

	loading = false;
	submitted = false;


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
			animalGroupFormControl: [toAnimalName, [Validators.required, Validators.pattern(/^[a-z ,.'-]+$/i)]]
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
	get animalList() { return this.animalListForm.controls; }
	validationMsg() {
		if (this.animalList.animalGroupFormControl.hasError('required'))
			return 'Please enter a value';
		if (this.animalList.animalGroupFormControl.hasError('pattern'))
			return 'Please only enter letters';
		if (this.animalList.animalGroupFormControl.hasError('invalid')) 
			return 'Please enter or select a valid animal';
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
		if (this.animalListForm.invalid) {
			return;
		}
		if (!this.animalNames.includes(this.animalList.animalGroupFormControl.value)) {
			this.animalList.animalGroupFormControl.setErrors({'invalid': true});
			return;
		}
		this.loading = true;
		this.startLoader();
		
		for (let i = 0; i < this.animals.length; i++) {
			if (this.animals[i].commonName == this.animalList.animalGroupFormControl.value)
				this.data.toAnimal = this.animals[i];
		}			

		this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{updateIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'",latitude:' + encodeURIComponent(this.data.fromAnimal.location.latitude) + ',longitude:' +  encodeURIComponent(this.data.fromAnimal.location.longitude) +
			',spoorIdentificationID:"' + encodeURIComponent(this.data.fromAnimal.spoorIdentificationID) + '",ranger:"' + encodeURIComponent(this.data.fromAnimal.ranger.rangerID) + 
			'",animal:"' + encodeURIComponent(this.data.toAnimal.animalID) + '",tags:"' + encodeURIComponent(this.data.fromAnimal.tags) + '"){spoorIdentificationID}}', '')
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
