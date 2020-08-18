import { Router } from '@angular/router';
import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { EditRangerInfoComponent } from './../edit-ranger-info/edit-ranger-info.component';
import { DeleteRangerComponent } from './../delete-ranger/delete-ranger.component';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
	selector: 'app-ranger-profile-card',
	templateUrl: './ranger-profile-card.component.html',
	styleUrls: ['./ranger-profile-card.component.css'],
})
export class RangerProfileCardComponent implements OnInit {

	@Input() searchText: string;
	@Input() rangersList;
	numRangers: any;
	@Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();
	sorted: string;

	constructor(private http: HttpClient, private router: Router, public dialog: MatDialog, private changeDetection: ChangeDetectorRef, private snackBar: MatSnackBar) { }

	ngOnInit(): void { this.startLoader(); }


	public ngOnChanges(changes: SimpleChanges) {
		this.startLoader();
		if (changes.rangers) {
			//If rangers has updated
			this.changeDetection.detectChanges();
		}
		this.stopLoader();
	}

	//Ranger CRUD Quick-Actions

	//EDIT Ranger
	openEditRangerDialog(rangerID) {
		const dialogConfig = new MatDialogConfig();

		//Get ranger information for chosen card
		var rangerFullName = document.getElementById("ranger" + rangerID + "Name").innerHTML;
		var rangerName = rangerFullName.split("&nbsp;");
		var rangerLevel = document.getElementById("ranger" + rangerID + "RangerLevel").textContent;
		var rangerPhone = document.getElementById("ranger" + rangerID + "PhoneNumber").textContent;
		var rangerEmail = document.getElementById("ranger" + rangerID + "Email").textContent;

		const editDialogRef = this.dialog.open(EditRangerInfoComponent, {
			height: '55%',
			width: '35%',
			autoFocus: true,
			disableClose: true,
			id: 'edit-ranger-dialog',
			data: {
				rangerID: rangerID,
				firstName: rangerName[0],
				lastName: rangerName[1],
				phoneNumber: rangerPhone.replace("call", ""),
				email: rangerEmail.replace("mail", "")
			},
		});
		editDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			if (result == "success") {
				//If ranger was successfully edited refresh component and notify parent
				this.rangersOnChange.emit("update");
			}
			else if (result == 'error') {
				this.snackBar.open('An error occured when editting ranger. Please try again.', "Dismiss", { duration: 5000, });
			}
		});
	}
	//DELETE Ranger
	openDeleteRangerDialog(rangerID) {
		try {
			const dialogConfig = new MatDialogConfig();

			var rangerFullName = document.getElementById("ranger" + rangerID + "Name").textContent;

			const deleteDialogRef = this.dialog.open(DeleteRangerComponent, {
				height: '45%',
				width: '30%',
				autoFocus: true,
				disableClose: true,
				id: 'delete-ranger-dialog',
				data: {
					name: rangerFullName,
					token: rangerID
				},
			});
			deleteDialogRef.afterClosed().subscribe(result => {
				this.stopLoader();
				if (result == "success") {
					//If ranger was successfully deleted
					//Refresh component and notify parent
					this.rangersOnChange.emit('delete');
				}
				else if (result == 'error') {
					this.snackBar.open('An error occured when deleting ranger. Please try again.', "Dismiss", { duration: 5000, });
				}
			});
		}
		catch (e) {
			return false;
		}
	}

	viewRangerProfile(rangerID: string) {
		this.router.navigate(['rangers/profiles'], { queryParams: { ranger: rangerID } });
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}

	sort(bool: boolean) {
		let temp: string;
		if (bool) {
			for (let i = 0; i < this.rangersList.length - 1; i++) {
				for (let j = i + 1; j < this.rangersList.length; j++) {
					if (this.rangersList[i].lastName.toUpperCase() > this.rangersList[j].lastName.toUpperCase()) {
						let temp = this.rangersList[i];
						this.rangersList[i] = this.rangersList[j];
						this.rangersList[j] = temp;
					}
				}
			}
			temp = "Sorted alphabetically";
		} else {
			for (let i = 0; i < this.rangersList.length - 1; i++) {
				for (let j = i + 1; j < this.rangersList.length; j++) {
					if (this.rangersList[i].rangerLevel > this.rangersList[j].rangerLevel) {
						let temp = this.rangersList[i];
						this.rangersList[i] = this.rangersList[j];
						this.rangersList[j] = temp;
					}
				}
			}
			temp = "Sorted by ranger level";
		}
		this.sorted = temp;
		return temp;
	}
	//Loader
	startLoader() {
		document.getElementById("loader-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("loader-container").style.visibility = "hidden";
	}
}
