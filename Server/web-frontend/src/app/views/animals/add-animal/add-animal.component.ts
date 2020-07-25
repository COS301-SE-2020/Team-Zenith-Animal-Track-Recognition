import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { startWith, map } from 'rxjs/operators';

export interface Animals {
	Common_Name: string;
	Classification: string[];
}

export const _filter = (opt: string[], value: string): string[] => {
	const filterValue = value.toLowerCase();

	return opt.filter(item => item.toLowerCase().indexOf(filterValue) === 0);
};

@Component({
	selector: 'app-add-animal',
	templateUrl: './add-animal.component.html',
	styleUrls: ['./add-animal.component.css']
})
export class AddAnimalComponent implements OnInit {

	animalListForm: FormGroup = this.formBuilder.group({ animal: '', });

	overviewForm: FormGroup;
	descrForm: FormGroup;
	behaviourForm: FormGroup;
	habitatForm: FormGroup;
	threatForm: FormGroup;

	//animals;
	//animals: Animals[] = [];
	animals: Animals[] = [
		{ Common_Name: 'Big Five', Classification: ['Blesbok', 'Red Hartebeest', 'Waterbuck'] },
		{ Common_Name: 'Big Cats', Classification: ['Cape Buffalo'] },
		{ Common_Name: 'Large Antelope', Classification: ['African Bush Elephant'] }
	];

	animalListOptions: Observable<Animals[]>;

	constructor(@Inject(MAT_DIALOG_DATA) public data: any, private router: Router, private http: HttpClient, private formBuilder: FormBuilder) { }

	ngOnInit(): void {
		/*
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
		*/
		//Fetch Animal List
		this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{animals(Token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '"){Classification,Common_Name,Group_ID{Group_Name}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.printOut(temp);
			});
		this.animalListOptions = this.animalListForm.get('animal')!.valueChanges.pipe(startWith(''), map(value => this._filterGroup(value)));
	}

	printOut(temp: any) {
		//this.animals = temp[0];
		//this.sort(true);
	}


	private _filterGroup(value: string): Animals[] {
		if (value) {
			return this.animals.map(group => ({ Common_Name: group.Common_Name, Classification: _filter(group.Classification, value) }))
				.filter(group => group.Classification.length > 0);
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
	  */
		this.router.navigate(["/geotags"], { queryParams: { reload: "true" } });
	}
}
