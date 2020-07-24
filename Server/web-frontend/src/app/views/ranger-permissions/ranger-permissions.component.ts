import { HttpClient } from '@angular/common/http';
import { Component, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatAccordion } from '@angular/material/expansion';


export interface Permissions {
	permission: string;
	level1: string;
	level2: string;
	level3: string;
}

//Default Ranger Permissions  
const PERMISSIONS: Permissions[] = [
	{ permission: "Spoor Capture & Identification", level1: "1", level2: "1", level3: "1" },
	{ permission: "View Spoor Geotag Information", level1: "1", level2: "1", level3: "1" },
	{ permission: "Seach Spoor Geotag Information", level1: "1", level2: "1", level3: "1" },
	{ permission: "View Animal Information", level1: "1", level2: "1", level3: "1" },
	{ permission: "Search Animal Information", level1: "1", level2: "1", level3: "1" },
	{ permission: "Edit Spoor Information", level1: "0", level2: "1", level3: "1" },
	{ permission: "Add Animal Information", level1: "0", level2: "0", level3: "1" },
	{ permission: "Edit Animal Information", level1: "0", level2: "0", level3: "1" },
];

@Component({
	selector: 'app-ranger-permissions',
	templateUrl: './ranger-permissions.component.html',
	styleUrls: ['./ranger-permissions.component.css']
})
export class RangerPermissionsComponent implements OnInit {

	@ViewChild(MatAccordion) accordion: MatAccordion;
	permissionsColumns: string[] = ['Permissions', 'Level 1 Rangers', 'Level 2 Rangers', 'Level 3 Rangers'];
	permissionsDataSource = PERMISSIONS;
	rangerPermissionsColumns: string[] = ['Ranger', 'Level 1 Ranger', 'Level 2 Ranger', 'Level 3 Ranger', 'Assigned Level'];
	rangerPermissionsDataSource;

	constructor(private router: Router, private http: HttpClient) { }

	ngOnInit(): void {
		document.getElementById("rangers-route").classList.add("activeRoute");

		//Replace Permissions with appropiate icon
		PERMISSIONS.forEach(function (perm) {
			if (perm.level1 == "1")
				perm.level1 = "<span class='material-icons allowed'>check_circle</span>";
			else if (perm.level1 == "0")
				perm.level1 = "<span class='material-icons notAllowed'>cancel</span>";

			if (perm.level2 == "1")
				perm.level2 = "<span class='material-icons allowed'>check_circle</span>";
			else if (perm.level2 == "0")
				perm.level2 = "<span class='material-icons notAllowed'>cancel</span>";

			if (perm.level3 == "1")
				perm.level3 = "<span class='material-icons allowed'>check_circle</span>";
			else if (perm.level3 == "0")
				perm.level3 = "<span class='material-icons notAllowed'>cancel</span>";
		});

		var count = 1;
		//Replace Permissions with appropiate radio button
		this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{Users(TokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '"){Token,Access_Level,firstName,lastName}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.printOut(temp);
			});
	}

	printOut(temp: any) {
		this.rangerPermissionsDataSource = temp[0];
		this.sort(true);
	}

	route(location: string) {
		document.getElementById("animals-route").classList.remove("activeRoute");
		document.getElementById("overview-route").classList.remove("activeRoute");
		document.getElementById("rangers-route").classList.remove("activeRoute");
		document.getElementById("geotags-route").classList.remove("activeRoute");
		document.getElementById("settings-route").classList.remove("activeRoute");

		this.router.navigate([location]);
	}

	isLevel(rangerLvl: number, seekNumber: number) {
		return seekNumber == rangerLvl;
	}

	sort(bool: boolean) {
		if (bool) {
			for (let i = 0; i < this.rangerPermissionsDataSource.length - 1; i++) {
				for (let j = i + 1; j < this.rangerPermissionsDataSource.length; j++) {
					if (this.rangerPermissionsDataSource[i].lastName.toUpperCase() > this.rangerPermissionsDataSource[j].lastName.toUpperCase()) {
						let temp = this.rangerPermissionsDataSource[i];
						this.rangerPermissionsDataSource[i] = this.rangerPermissionsDataSource[j];
						this.rangerPermissionsDataSource[j] = temp;
					}
				}
			}
		} else {
			for (let i = 0; i < this.rangerPermissionsDataSource.length - 1; i++) {
				for (let j = i + 1; j < this.rangerPermissionsDataSource.length; j++) {
					if (this.rangerPermissionsDataSource[i].Access_Level > this.rangerPermissionsDataSource[j].Access_Level) {
						let temp = this.rangerPermissionsDataSource[i];
						this.rangerPermissionsDataSource[i] = this.rangerPermissionsDataSource[j];
						this.rangerPermissionsDataSource[j] = temp;
					}
				}
			}
		}
		return bool;
	}

	updateLevel(tkn: string, lvl: string) {
		let temp = this.http.post<any>('http://putch.dyndns.org:55555/graphql?query=mutation{UpdateUser('
			+ 'TokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'
			+ 'TokenChange:"' + tkn + '",'
			+ 'Access_Level:"' + lvl + '"){lastName,Token}}', '').subscribe((data: any[]) => {
			let t = [];
			t = Object.values(Object.values(data)[0]);
		});

		this.router.navigate(["/geotags"], { queryParams: { reloadPerms: "true" } });
	}
}
