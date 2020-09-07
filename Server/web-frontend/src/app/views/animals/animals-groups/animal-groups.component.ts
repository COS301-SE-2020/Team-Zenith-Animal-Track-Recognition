import { MatCheckboxModule } from '@angular/material/checkbox';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatAccordion } from '@angular/material/expansion';
import { MatDialogConfig, MatDialog } from '@angular/material/dialog';
import { AddGroupsComponent } from '../add-groups/add-groups.component';
import { MatSnackBar } from '@angular/material/snack-bar';

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

	constructor(private router: Router, private http: HttpClient, public dialog: MatDialog, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
		this.startLoader();
		document.getElementById("animals-route").classList.add("activeRoute");

		var count = 1;
		//Replace Groups with appropiate radio button
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animals(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){classification,animalID,commonName,groupID{groupID}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.animalGroupsDataSource = temp[0];
				this.sort(true);
			});

		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{groups(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){groupName, groupID}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(Object.values(data)[0])[0]);
				temp.forEach(element => {
					this.animalGroups.push(element);
					this.animalGroupsColumns.push(element['groupName']);
				});
			});

		setTimeout(() => {
			// this.animalGroupsDataSource.forEach(e => {
			// 	e['groupID'].forEach(element => {
			// 		console.log(e['commonName'] + '  ' + element['groupID']);
			// 	});
			// });

			let temp: any[] = [];
			this.animalGroupsDataSource.forEach(element => {
				let t = {};
				t['Animal'] = element['commonName'];
				this.animalGroups.forEach(gpName => {
					let tmp = 0;
					element['groupID'].forEach(gpID => {
						if (gpName['groupID'] == gpID['groupID']) {
							tmp = 1;
						}
					});
					t[gpName['groupName']] = tmp;
				});
				t['animalID'] = element['animalID'];
				t['classification'] = element['classification'];
				temp.push(t);
			});

			this.animalGroupsDataSource = null;
			this.animalGroupsDataSource = temp;
			console.log(this.animalGroups);
			this.log(this.animalGroupsColumns);
			this.stopLoader();
		}, 500);

	}

	log(str: any) {
		console.log(str);
	}

	route(location: string) {
		document.getElementById("animals-route").classList.remove("activeRoute");
		document.getElementById("overview-route").classList.remove("activeRoute");
		document.getElementById("animals-route").classList.remove("activeRoute");
		document.getElementById("geotags-route").classList.remove("activeRoute");
		document.getElementById("settings-route").classList.remove("activeRoute");

		this.router.navigate([location]);
	}

	isLevel(animalLvl: number, seekNumber: number) {
		return seekNumber == animalLvl;
	}

	sort(bool: boolean) {
		if (bool) {
			for (let i = 0; i < this.animalGroupsDataSource.length - 1; i++) {
				for (let j = i + 1; j < this.animalGroupsDataSource.length; j++) {
					if (this.animalGroupsDataSource[i].commonName.toUpperCase() > this.animalGroupsDataSource[j].commonName.toUpperCase()) {
						let temp = this.animalGroupsDataSource[i];
						this.animalGroupsDataSource[i] = this.animalGroupsDataSource[j];
						this.animalGroupsDataSource[j] = temp;
					}
				}
			}
		} else {
			for (let i = 0; i < this.animalGroupsDataSource.length - 1; i++) {
				for (let j = i + 1; j < this.animalGroupsDataSource.length; j++) {
					if (this.animalGroupsDataSource[i].accessLevel > this.animalGroupsDataSource[j].accessLevel) {
						let temp = this.animalGroupsDataSource[i];
						this.animalGroupsDataSource[i] = this.animalGroupsDataSource[j];
						this.animalGroupsDataSource[j] = temp;
					}
				}
			}
		}
		return bool;
	}

	openAddGroupDialog() {

		const dialogConfig = new MatDialogConfig();

		const addDialogRef = this.dialog.open(AddGroupsComponent, {
			height: '70%',
			width: '45%',
			id: 'add-groups-dialog',
			autoFocus: true,
			disableClose: true
		});
		addDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			if (result == 'success') {
				//If animal was successfully added, refresh component and notify parent
			}
			else if (result == 'error') {
				this.snackBar.open('An error occured when adding the new animal. Please try again.', "Dismiss", { duration: 5000, });
			}
		});
	}

	updateLevel(tkn: string, lvl: string) {
		let temp = this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{updateUser('
			+ 'tokenSend:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'
			+ 'animalID:"' + tkn + '",'
			+ 'accessLevel:"' + lvl + '"){lastName,animalID}}', '').subscribe((data: any[]) => {
				let t = [];
				t = Object.values(Object.values(data)[0]);
			});

		this.router.navigate(["/geotags"], { queryParams: { reloadPerms: "true" } });
	}

	viewAnimalProfile(token: string) {
		token = token.replace(' ', '_');
		this.router.navigate(['animals/information'], { queryParams: { classification: token } });
	}

	isAnimal(group: string) {
		return 'Animal' == group;
	}

	isGroup(group: number) {
		return 1 == group;
	}

	addGroup(animalID, groupID){
		let temp = this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{addAnimalGroup('
			+ 'token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'
			+ 'animalID:"' + animalID + '",'
			+ 'groupID:"' + groupID + '"){animalID}}', '').subscribe((data: any[]) => {
				let t = [];
				t = Object.values(Object.values(data)[0]);
			});
	}

	removeGroup(animalID, groupID){
		let temp = this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{removeAnimalGroup('
			+ 'token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '",'
			+ 'animalID:"' + animalID + '",'
			+ 'groupID:"' + groupID + '"){animalID}}', '').subscribe((data: any[]) => {
				let t = [];
				t = Object.values(Object.values(data)[0]);
			});
	}

	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}
}