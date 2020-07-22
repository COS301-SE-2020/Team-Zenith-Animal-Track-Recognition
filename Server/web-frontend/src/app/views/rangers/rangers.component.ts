import { Component, OnInit, ViewChild } from '@angular/core';
import {MatDialog, MatDialogRef} from '@angular/material/dialog'; 
import { Ranger } from './../../models/ranger';
import { RANGERS } from './../../models/mock-rangers';

@Component({
  selector: 'app-rangers',
  templateUrl: './rangers.component.html',
  styleUrls: ['./rangers.component.css']
})
export class RangersComponent implements OnInit {

  @ViewChild('sidenav') sidenav;
  	rangers = RANGERS;
	searchText;
	currentAlphabet;
	surnames: boolean = true;
	levels: boolean = false;
	
	constructor(public dialog: MatDialog) { }

  ngOnInit(): void {
    document.getElementById("rangers-route").classList.add("activeRoute");
  
  }
	
	//Ranger Search Side Navigation	
	openSidenav()
	{
		this.sidenav.open();
		document.getElementById("sidenav-open-btn-container").style.transitionDuration = "0.2s";
		document.getElementById("sidenav-open-btn-container").style.left = "-10%";
	}
	closeSidenav()
	{
		this.sidenav.close();
		document.getElementById("sidenav-open-btn-container").style.transitionDuration = "0.8s";
		document.getElementById("sidenav-open-btn-container").style.left = "0%";
	}
	
	//Add New Ranger Dialog
	openAddRangerDialog()
	{
		const dialogRef = this.dialog.open(AddRangerComponent);

		dialogRef.afterClosed().subscribe(result => {
		  console.log(`Dialog result: ${result}`);
		});
	}
	
	//Sorting and Filtering
	checkIfNew(title: string, pos: number) {
		if (this.currentAlphabet === ("" + title).charAt(pos).toLowerCase()) {
			return false;
		} else {
			this.currentAlphabet = ("" + title).charAt(pos).toLowerCase();
			return true;
		}
	}
	toggle(bool: boolean) {
		this.surnames = bool;
		this.levels = !bool;
		this.sort(bool);
	}
	sort(bool: boolean) {
		if (bool) {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if (this.rangers[i].lastName.toUpperCase() > this.rangers[j].lastName.toUpperCase()) {
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp;
					}
				}
			}
		} else {
			for (let i = 0; i < this.rangers.length - 1; i++) {
				for (let j = i + 1; j < this.rangers.length; j++) {
					if(this.rangers[i].rangerLevel > this.rangers[j].rangerLevel){
						let temp = this.rangers[i];
						this.rangers[i] = this.rangers[j];
						this.rangers[j] = temp; 
					}
				}
			}
		}
	}
}

@Component({
  selector: 'app-add-ranger',
  templateUrl: './add-ranger/add-ranger.component.html',
  styleUrls: ['./add-ranger/add-ranger.component.css']
})
export class AddRangerComponent {
	
	constructor(public dialogRef: MatDialogRef<AddRangerComponent>) { }

	closeDialog() 
	{
		this.dialogRef.close('Pizza!');
	}
}
