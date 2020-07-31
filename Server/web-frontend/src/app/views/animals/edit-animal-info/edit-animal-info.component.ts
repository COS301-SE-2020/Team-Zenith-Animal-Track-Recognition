import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject} from '@angular/core';
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
	
	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private http: HttpClient, private formBuilder: FormBuilder, public dialogRef: MatDialogRef<EditAnimalInfoComponent>) { }


	ngOnInit(): void 
	{
		this.overviewForm = this.formBuilder.group({
			Group_Name: [this.data.animal.Group_ID[0].Group_Name , Validators.required],
			Common_Name: [this.data.animal.Common_Name, Validators.required], 
			Classification: [this.data.animal.Classification, Validators.required],
			HeightF: [this.data.animal.HeightF, Validators.required],
			HeightM: [this.data.animal.HeightM, Validators.required],
			WeightF: [this.data.animal.WeightF, Validators.required],
			WeightM: [this.data.animal.WeightM, Validators.required],
			Gestation_Period: [this.data.animal.Gestation_Period, Validators.required],
			Diet_Type: [this.data.animal.Diet_Type, Validators.required],
			Typical_Behaviour: [this.data.animal.Typical_Behaviour, Validators.required],
		});		
		this.descrForm = this.formBuilder.group({
			Life_Span: [this.data.animal.Life_Span, Validators.required],
			Overview_of_animal: [this.data.animal.Overview_of_animal, Validators.required],
			Description_of_animal: [this.data.animal.Description_of_animal, Validators.required],
		});		
		this.behaviourForm = this.formBuilder.group({
			Typical_Behaviour: [this.data.animal.Typical_Behaviour, Validators.required]
		});		
		this.habitatForm = this.formBuilder.group({
			Habitat: [this.data.animal.Habitat, Validators.required]
		});
		this.threatForm = this.formBuilder.group({
			Typical_Behaviour: [this.data.animal.Typical_Behaviour, Validators.required]
		});	
	}
	
	get f() { return this.overviewForm.controls; }

	onSubmit(test: boolean) {
		
		if (false === test) {
			this.startLoader();
			//@Zach Please change the query string. 
			this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{UpdateUser('+ 'TokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'+ 'TokenChange:"' + this.data.Token + '"){lastName,Token}}', '')
			.subscribe({next: data => this.dialogRef.close("success"), error: error => this.dialogRef.close("Error " + error.message)});
		}
		else {
			return true;
		}
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
