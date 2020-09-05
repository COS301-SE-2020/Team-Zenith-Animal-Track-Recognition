import { MatCheckboxModule } from '@angular/material/checkbox';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatAccordion } from '@angular/material/expansion';
import { MatDialogConfig } from '@angular/material/dialog';
import { EditAnimalInfoComponent } from '../edit-animal-info/edit-animal-info.component';

@Component({
	selector: 'app-animal-groups',
	templateUrl: './animal-groups.component.html',
	styleUrls: ['./animal-groups.component.css']
})
export class AnimalGroupsComponent implements OnInit {

	@ViewChild(MatAccordion) accordion: MatAccordion;
	animalGroupsColumns: string[] = ['Animal'];
	animalGroups: any[] = [];
	animalGroupsDataSource: any;	
	
	constructor(private router: Router, private http: HttpClient) { }

	ngOnInit(): void {

	}
	
	route(location: string) {
		this.router.navigate([location]);
	}
}
