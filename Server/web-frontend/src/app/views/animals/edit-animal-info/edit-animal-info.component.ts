import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import {Observable} from 'rxjs';
import {startWith, map} from 'rxjs/operators';

export interface Animals
{
	common_name: string;
	classification: string[];
}

export const _filter = (opt: string[], value: string): string[] => {
  const filterValue = value.toLowerCase();

  return opt.filter(item => item.toLowerCase().indexOf(filterValue) === 0);
};

@Component({
  selector: 'app-edit-animal-info',
  templateUrl: './edit-animal-info.component.html',
  styleUrls: ['./edit-animal-info.component.css']
})
export class EditAnimalInfoComponent implements OnInit {
	
	//stateForm: FormGroup = this.formBuilder.group({stateGroup: '',});
	animalListForm: FormGroup  = this.formBuilder.group({animal: '',});
	overviewForm: FormGroup;
	descrForm: FormGroup;
	behaviourForm: FormGroup;
	habitatForm: FormGroup;
	threatForm: FormGroup;
	
	animals: Animals[] = [
		{common_name: 'Antelope', classification: ['Blesbok', 'Red Hartebeest', 'Waterbuck']}, 
		{common_name: 'Buffalo', classification: ['Cape Buffalo']}, 
		{common_name: 'Elephant', classification: ['African Bush Elephant']}, 
		{common_name: 'Hippopotamus', classification: ['Common Hippopotamus']}, 
		{common_name: 'Jackal', classification: ['Black Backed Jackal']}, 
		{common_name: 'Rhino', classification: ['Black Rhino', 'White Rhino']}, 
		{common_name: 'Wildebeest', classification: ['Black Wildebeest']}, 
		{common_name: 'Zebra', classification: ['Moutain Zebra']}
	];

	animalListOptions: Observable<Animals[]>;

	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private router: Router, private http: HttpClient, private formBuilder: FormBuilder) { }


	ngOnInit(): void 
	{
		this.overviewForm = this.formBuilder.group({Classification: [this.data.Classification , Validators.required],
		Common_Name: [this.data.Common_Name, Validators.required], Description_of_animal: [this.data.Description_of_animal, Validators.required],});

		this.descrForm = this.formBuilder.group({Classification: [this.data.Classification , Validators.required],
		Common_Name: [this.data.Common_Name, Validators.required], Description_of_animal: [this.data.Description_of_animal, Validators.required],});

		this.behaviourForm = this.formBuilder.group({Classification: [this.data.Classification , Validators.required],
		Common_Name: [this.data.Common_Name, Validators.required], Description_of_animal: [this.data.Description_of_animal, Validators.required],});	

		this.habitatForm = this.formBuilder.group({Classification: [this.data.Classification , Validators.required],
		Common_Name: [this.data.Common_Name, Validators.required], Description_of_animal: [this.data.Description_of_animal, Validators.required],});	

		this.threatForm = this.formBuilder.group({Classification: [this.data.Classification , Validators.required],
		Common_Name: [this.data.Common_Name, Validators.required], Description_of_animal: [this.data.Description_of_animal, Validators.required],});
		
		/* this.animalCommonNameOptions = this.animalListForm.get('animal')!.valueChanges
			.pipe(startWith(''), map(value => this._filterGroup(value)));*/
			
		this.animalListOptions = this.animalListForm.get('animal')!.valueChanges.pipe(startWith(''), map(value => this._filterGroup(value)));
	}
	
	
	private _filterGroup(value: string): Animals[] 
	{
		if (value) 
		{
			return this.animals.map(group => ({common_name: group.common_name, classification: _filter(group.classification, value)}))
        .filter(group => group.classification.length > 0);
		}
		return this.animals;
	}
  
  //get f() { return this.overviewForm.controls; }

  onSubmit() {
	  /*
    let temp = this.http.post<any>('http://putch.dyndns.org:55555/graphql?query=mutation{UpdateUser('
      + 'TokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'
      + 'TokenChange:"' + this.data.Token + '",'
      + 'e_mail:"' + this.f.email.value + '",'
      + 'lastName:"' + this.f.lastName.value + '",'
      + 'phoneNumber:"' + this.f.phoneNumber.value + '",'
      + 'firstName:"' + this.f.firstName.value + '"){lastName,Token}}', '').subscribe((data: any[]) => {
        let t = [];
        t = Object.values(Object.values(data)[0]);        
      });

    this.router.navigate(["/geotags"], { queryParams: { reload: "true" } });
	*/
  }

}
