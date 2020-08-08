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
	overviewForm: FormGroup;
	descrForm: FormGroup;
	behaviourForm: FormGroup;
	habitatForm: FormGroup;
	threatForm: FormGroup;
	diet: string;

	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private formBuilder: FormBuilder, public dialogRef: MatDialogRef<EditAnimalInfoComponent>) { }

	ngOnInit(): void {
		this.overviewForm = this.formBuilder.group({
			groupName: [this.data.animal.groupID[0].groupName, Validators.required],
			commonName: [this.data.animal.commonName, Validators.required],
			classification: [this.data.animal.classification, Validators.required],
			heightF: [this.data.animal.heightF, Validators.required],
			heightM: [this.data.animal.heightM, Validators.required],
			weightF: [this.data.animal.weightF, Validators.required],
			weightM: [this.data.animal.weightM, Validators.required],
			gestationPeriod: [this.data.animal.gestationPeriod, Validators.required],
			dietType: [this.data.animal.dietType, Validators.required],
			//Typical_Behaviour: [this.data.animal.Typical_Behaviour, Validators.required],
		});
		/*this.descrForm = this.formBuilder.group({
			Life_Span: [this.data.animal.Life_Span, Validators.required],
			Overview_of_animal: [this.data.animal.Overview_of_animal, Validators.required],
			Description_of_animal: [this.data.animal.Description_of_animal, Validators.required],
		});		
		this.behaviourForm = this.formBuilder.group({
			//Typical_Behaviour: [this.data.animal.Typical_Behaviour, Validators.required]
		});		
		this.habitatForm = this.formBuilder.group({
			Habitat: [this.data.animal.Habitat, Validators.required]
		});
		this.threatForm = this.formBuilder.group({
			//Typical_Behaviour: [this.data.animal.Typical_Behaviour, Validators.required]
		});	*/
		document.getElementById('edit-animal-dialog').style.overflow = "hidden";
	}

	get f() { return this.overviewForm.controls; }

	onSubmit(test: boolean) {

		if (false === test) {
			this.startLoader();
			this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{token:"' + encodeURIComponent(JSON.parse(localStorage.getItem('currentToken'))['value']) +
				'",' + 'classification:"' + encodeURIComponent(this.f.classification.value) + '",commonName:"' + encodeURIComponent(this.f.commonName.value) +
				'",heightF:"' + encodeURIComponent(this.f.heightF.value) + '",heightM:"' + encodeURIComponent(this.f.heightM.value) + '",weightM:"' +
				encodeURIComponent(this.f.weightM.value) + '",weightF:"' + encodeURIComponent(this.f.weightF.value) + '",gestationPeriod"' +
				encodeURIComponent(this.f.gestationPeriod.value) + '",dietType:"' + encodeURIComponent(this.diet) + '"){animalID}}', '')
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

	attachProgressbar()
	{
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