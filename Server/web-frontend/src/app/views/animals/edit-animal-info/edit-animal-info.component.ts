import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
	selector: 'app-edit-animal-info',
	templateUrl: './edit-animal-info.component.html',
	styleUrls: ['./edit-animal-info.component.css']
})
export class EditAnimalInfoComponent implements OnInit {

	editAnimalForm: FormGroup;
	diet: string;
	//DUMMY DATA
	dietTypeList = [
		{
			displayValue: 'Herbivorous'
		},
		{
			displayValue: 'Carnivorous'
		},
		{
			displayValue: 'Omnivorous'
		},
		{
			displayValue: 'Insectivorous'
		}
	];

	constructor(
		@Inject(MAT_DIALOG_DATA) public data: any, 
		private http: HttpClient, 
		private formBuilder: FormBuilder, 
		public dialogRef: MatDialogRef<EditAnimalInfoComponent>) { }

	ngOnInit(): void {
		this.editAnimalForm = this.formBuilder.group({
			commonName: [this.data.animal.commonName],
			classification: [this.data.animal.classification],
			animalDescription: [this.data.animal.animalDescription],
			heightF: [this.data.animal.heightF],
			heightM: [this.data.animal.heightM],
			weightF: [this.data.animal.weightF],
			weightM: [this.data.animal.weightM],
			gestationPeriod: [this.data.animal.gestationPeriod],
			numOffspring: [''],
			lifeSpan: [this.data.animal.lifeSpan],
			dietType: [this.data.animal.dietType],
			femaleBehaviour: [''],
			maleBehaviour: [''],
			habitatDescrip: [''],
			habitatFeatures: [''],
			femaleThreat: [''],
			maleThreat: ['']
		});
		document.getElementById('edit-animal-dialog').style.overflow = "hidden";
	}

	get f() { return this.editAnimalForm.controls; }

	onSubmit(test: boolean) {

		if (false === test) {
			this.startLoader();
			this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{updateAnimal(token:"' + encodeURIComponent(JSON.parse(localStorage.getItem('currentToken'))['value']) +
				'",classification:"' + encodeURIComponent(this.f.classification.value) + '",commonName:"' + encodeURIComponent(this.f.commonName.value) +
				'",lifeSpan:"' + encodeURIComponent(this.f.classification.value) + '",animalDescription:"' + encodeURIComponent(this.f.animalDescription.value) +
				'",heightF:' + encodeURIComponent(this.f.heightF.value) + ',heightM:' + encodeURIComponent(this.f.heightM.value) + ',weightM:' +
				encodeURIComponent(this.f.weightM.value) + ',weightF:' + encodeURIComponent(this.f.weightF.value != null ? this.f.weightF.value : this.f.weightM.value) +
				',gestationPeriod:"' + encodeURIComponent(this.f.gestationPeriod.value) + '",dietType:"' + encodeURIComponent(this.data.animal.dietType) + '",animalOverview:"' +
				'"){animalID}}', '')
				.subscribe({
					next: data => this.dialogRef.close('success'),
					error: error => this.dialogRef.close('error')
				});
		}
		else {
			return true;
		}
	}
	closeDialog() {
		this.dialogRef.close("cancel");
	}

	attachProgressbar() {
		//Append progress bar to dialog
		let matDialog = document.getElementById('edit-animal-dialog');
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