import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, FormControl, Validators } from '@angular/forms';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
	selector: 'app-add-animal',
	templateUrl: './add-animal.component.html',
	styleUrls: ['./add-animal.component.css']
})
export class AddAnimalComponent implements OnInit {

	addAnimalForm: FormGroup;

	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private formBuilder: FormBuilder, public dialogRef: MatDialogRef<AddAnimalComponent>) { }

	ngOnInit(): void {
		this.addAnimalForm = this.formBuilder.group({
			commonName: ['', Validators.required],
			classification: ['', Validators.required],
			animalDescription: ['', Validators.required]
		});
		document.getElementById('add-animal-dialog').style.overflow = "hidden";
	}

	get f() { return this.addAnimalForm.controls; }

	onSubmit(test: boolean) {
		if (false === test) {
			this.startLoader();
			//@Zach Please change the query string. 
			this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{wdbAddAnimal(token:"' +
				JSON.parse(localStorage.getItem('currentToken'))['value'] + '",classification:"' + encodeURIComponent(this.f.classification.value) +
				'",commonName:"' + encodeURIComponent(this.f.commonName.value) + '",animalDescription:"' +
				encodeURIComponent(this.f.animalDescription.value) + '"){animalID}}', '')
				.subscribe({ 
					next: data => this.dialogRef.close("success"), 
					error: error => this.dialogRef.close("error") 
				});
				window.location.reload();
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
