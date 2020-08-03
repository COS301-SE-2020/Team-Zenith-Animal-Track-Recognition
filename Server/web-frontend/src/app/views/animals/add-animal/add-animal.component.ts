import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, FormControl, Validators } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
	selector: 'app-add-animal',
	templateUrl: './add-animal.component.html',
	styleUrls: ['./add-animal.component.css']
})
export class AddAnimalComponent implements OnInit {

	addAnimalForm: FormGroup;

	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private formBuilder: FormBuilder) { }

	ngOnInit(): void {
		
		//The Add Animal Form is made up of mat-steps. Each mat-step needs to have all fields filled in before you can proceed to the next one
		//FOR DEBUGGING PURPOSES if you want to be able to skip filling in the fields, remove the Validators.required for that field
		this.addAnimalForm = this.formBuilder.group({
			'animalOverview': new FormGroup({
				'Group_Name': new FormControl(null, Validators.required),
				'Common_Name': new FormControl(null, Validators.required), 
				'Classification': new FormControl(null, Validators.required),
				'HeightF': new FormControl(null, Validators.required),
				'HeightM': new FormControl(null, Validators.required),
				'WeightF': new FormControl(null, Validators.required),
				'WeightM': new FormControl(null, Validators.required),
				'Gestation_Period': new FormControl(null, Validators.required),
				'Diet_Type': new FormControl(null, Validators.required)
			}),
			'animalDescrip': new FormGroup({
				'Life_Span': new FormControl(null, Validators.required),
				'Overview_of_animal': new FormControl(null, Validators.required),
				'Description_of_animal': new FormControl(null, Validators.required)
			}),
			'animalBehaviour': new FormGroup({
				'Typical_BehaviourF': new FormControl(null, Validators.required),
				'Typical_BehaviourM': new FormControl(null, Validators.required)
			}),
			'animalHabitat': new FormGroup({
				'Habitat': new FormControl(null, Validators.required)
			}),
			'rangerThreats': new FormGroup({
				'Typical_BehaviourThreatF': new FormControl(null, Validators.required),
				'Typical_BehaviourThreatM': new FormControl(null, Validators.required)
			})
		});	
		
		
	}


	get f() { return this.addAnimalForm.controls; }

	onSubmit() {
	}
}
