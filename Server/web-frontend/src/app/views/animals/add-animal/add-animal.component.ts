import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, FormControl, Validators } from '@angular/forms';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { doesNotReject } from 'assert';

@Component({
	selector: 'app-add-animal',
	templateUrl: './add-animal.component.html',
	styleUrls: ['./add-animal.component.css']
})
export class AddAnimalComponent implements OnInit {

	addAnimalForm: FormGroup;
	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private formBuilder: FormBuilder, public dialogRef: MatDialogRef<AddAnimalComponent>) { 
	}

	ngOnInit(): void {
		this.addAnimalForm = this.formBuilder.group({
			commonName: ['', [Validators.required, Validators.pattern(/^[a-z ,.'-]+$/i)]],
			classification: ['', [Validators.required, Validators.pattern(/^[a-z ,.'-]+$/i)]],
			animalDescription: ['', Validators.required]
		});
		document.getElementById('add-animal-dialog').style.overflow = "hidden";
	}

	get addAnimal() { return this.addAnimalForm.controls; }
	validationMsg(formCtrl: any, formCtrlName: string) {
		if (formCtrl.hasError('required')) {
			return 'Please enter a value';
		}
		switch (formCtrlName) {
			case "commonName":
				return this.addAnimal.commonName.hasError('pattern') ? 'Please only enter letters' : '';
			break;
			case "classification":
				return this.addAnimal.classification.hasError('pattern') ? 'Please only enter letters' : '';
			break;
		}
	}


	onSubmit(test: boolean) {
		if (false === test) {
			
		if (this.addAnimalForm.invalid) {
			return;
		}
			this.startLoader();

			const cont: boolean = (this.addAnimal.animalDescription.value).includes('.');
			let animalDescription = this.addAnimal.animalDescription.value;

			if(!cont){
				let fullstop = ".";
				animalDescription=animalDescription.concat(fullstop);
			}
			this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{wdbAddAnimal(token:"' +
				JSON.parse(localStorage.getItem('currentToken'))['value'] + '",classification:"' + encodeURIComponent(this.addAnimal.classification.value) +
				'",commonName:"' + encodeURIComponent(this.addAnimal.commonName.value) + '",animalDescription:"' +
				encodeURIComponent(animalDescription) + '"){animalID}}', '')
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
		let matDialog = document.getElementById('add-animal-dialog');
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
