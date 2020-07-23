import { Component, OnInit, Input } from '@angular/core';
import {MatDialog, MatDialogRef, MatDialogConfig} from '@angular/material/dialog'; 
import {EditRangerInfoComponent} from './../edit-ranger-info/edit-ranger-info.component'; 
import {DeleteRangerComponent} from './../delete-ranger/delete-ranger.component'; 
import { Ranger } from './../../../models/ranger';
import { RANGERS } from './../../../models/mock-rangers';

@Component({
  selector: 'app-ranger-profile-card',
  templateUrl: './ranger-profile-card.component.html',
  styleUrls: ['./ranger-profile-card.component.css']
})
export class RangerProfileCardComponent implements OnInit {

  @Input() searchText: string;
  rangers = RANGERS;

  constructor(public dialog: MatDialog) { }

  ngOnInit(): void {
  }
  
    //Ranger CRUD Quick-Actions
	
	//EDIT Ranger
    openEditRangerDialog(rangerID) 
	{
		const dialogConfig = new MatDialogConfig();
		
		//Get ranger information for chosen card
		var rangerFullName = document.getElementById("ranger" + rangerID + "Name").innerHTML;
		var rangerName = rangerFullName.split("&nbsp;");
		var rangerLevel = document.getElementById("ranger" + rangerID + "RangerLevel").textContent;
		var rangerPhone = document.getElementById("ranger" + rangerID + "PhoneNumber").textContent;
		var rangerEmail = document.getElementById("ranger" + rangerID + "Email").textContent;
		
		this.dialog.open(EditRangerInfoComponent, {height: '55%', width: '35%', autoFocus: true, disableClose: true, data: { firstName: rangerName[0], lastName: rangerName[1], level: rangerLevel, phoneNum: rangerPhone.replace("call",""), email: rangerEmail.replace("mail","")},});
	}
	
	//DELETE Ranger
	openDeleteRangerDialog(rangerID) 
	{
		const dialogConfig = new MatDialogConfig();
		
		//Get ranger information for chosen card
		var rangerFullName = document.getElementById("ranger" + rangerID + "Name").textContent;
		
		this.dialog.open(DeleteRangerComponent, {height: '45%', width: '30%', autoFocus: true, disableClose: true, data: { name: rangerFullName,},});
	}

}
