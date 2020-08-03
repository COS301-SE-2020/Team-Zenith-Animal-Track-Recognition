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

	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private formBuilder: FormBuilder,  public dialogRef: MatDialogRef<AddAnimalComponent>) { }

	ngOnInit(): void {
		
		//---- API Call to get list of all Animal groups should be here -----
		//To be implemented after the changes to the API are complete
		//-----------------------------------------------------------
		
		this.addAnimalForm = this.formBuilder.group({
			'animalOverview': new FormGroup({
				'Group_Name': new FormControl(null, Validators.required),
				'Common_Name': new FormControl(null, Validators.required), 
				'Classification': new FormControl(null, Validators.required),
				'Description_of_animal': new FormControl(null, Validators.required)
			})
		});	
		
		//The Add Animal Form is made up of mat-steps. Each mat-step needs to have all fields filled in before you can proceed to the next one
		//FOR DEBUGGING PURPOSES if you want to be able to skip filling in the fields, remove the Validators.required for that field
		/*
		this.addAnimalForm = this.formBuilder.group({
			'animalOverview': new FormGroup({
				'Group_Name': new FormControl(null),
				'Common_Name': new FormControl(null), 
				'Classification': new FormControl(null),
				'HeightF': new FormControl(null),
				'HeightM': new FormControl(null),
				'WeightF': new FormControl(null),
				'WeightM': new FormControl(null),
				'Gestation_Period': new FormControl(null),
				'Diet_Type': new FormControl(null)
			}),
			'animalDescrip': new FormGroup({
				'Life_Span': new FormControl(null),
				'Overview_of_animal': new FormControl(null),
				'Description_of_animal': new FormControl(null)
			}),
			'animalBehaviour': new FormGroup({
				'Typical_BehaviourF': new FormControl(null),
				'Typical_BehaviourM': new FormControl(null)
			}),
			'animalHabitat': new FormGroup({
				'Habitat': new FormControl(null)
			}),
			'rangerThreats': new FormGroup({
				'Typical_BehaviourThreatF': new FormControl(null),
				'Typical_BehaviourThreatM': new FormControl(null)
			})
		});	
		*/	
	}

	get f() { return this.addAnimalForm.controls; }

	onSubmit(test: boolean) {
		if (false === test) {
			this.startLoader();
			//@Zach Please change the query string. 
			this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{UpdateUser('+ 'TokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'+ 'TokenChange:"' + this.data.Token + '"){lastName,Token}}', '')
			.subscribe({next: data => this.dialogRef.close("success"), error: error => this.dialogRef.close("error")});
		}
		else {
			return true;
		}
	}
	closeDialog()
	{
		this.dialogRef.close("cancel");
	}
	
	//Loader
	startLoader()
	{
		document.getElementById("loader-container").style.visibility = "visible";
	}  
	stopLoader()
	{
		document.getElementById("loader-container").style.visibility = "hidden";
	}
}
