import { Component, OnInit } from '@angular/core';
import { Ranger } from './../../../models/ranger';
import { RANGERS } from './../../../models/mock-rangers';

@Component({
	selector: 'app-ranger-search-sidenav-comp',
	templateUrl: './ranger-search-sidenav-comp.component.html',
	styleUrls: ['./ranger-search-sidenav-comp.component.css']
})
export class RangerSearchSidenavCompComponent implements OnInit {

	//USING MOCK RANGER DATA. @Zach please replace this with an API call that fetches the users. We only need ID, Name, Username and ranger level

	rangers = RANGERS;
	searchText;

	constructor() { }

	ngOnInit(): void {
	}

}
