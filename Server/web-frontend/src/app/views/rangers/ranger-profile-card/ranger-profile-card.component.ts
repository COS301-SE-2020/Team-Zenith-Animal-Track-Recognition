import { Component, OnInit, Input } from '@angular/core';
import {MatDialog, MatDialogRef, MatDialogConfig} from '@angular/material/dialog'; 
import {EditRangerInfoComponent} from './../edit-ranger-info/edit-ranger-info.component'; 
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
  
    
    openEditRangerDialog(rangerID) 
	{
		const dialogConfig = new MatDialogConfig();
		
		//Get ranger information for chosen card
		var rangerFullName = document.getElementById("ranger" + rangerID + "Name").innerHTML;
		var rangerName = rangerFullName.split("&nbsp;");
		var rangerLevel = document.getElementById("ranger" + rangerID + "RangerLevel").textContent;
		var rangerPhone = document.getElementById("ranger" + rangerID + "PhoneNumber").textContent;
		var rangerEmail = document.getElementById("ranger" + rangerID + "Email").textContent;
		
		console.log(document.getElementById("ranger" + rangerID + "PhoneNumber"));
		
		this.dialog.open(EditRangerInfoComponent, {height: '55%', width: '35%', autoFocus: true, disableClose: true, data: { firstName: rangerName[0], lastName: rangerName[1], level: rangerLevel, phoneNum: rangerPhone.replace("call",""), email: rangerEmail.replace("mail","")},});
	}

}
