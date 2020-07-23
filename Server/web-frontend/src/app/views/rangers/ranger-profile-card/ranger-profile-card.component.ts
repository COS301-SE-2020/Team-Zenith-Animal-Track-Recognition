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
  
    
    openEditRangerDialog() 
	{
		const dialogConfig = new MatDialogConfig();
		
		this.dialog.open(EditRangerInfoComponent, {height: '55%', width: '35%', autoFocus: true, disableClose: true});
	}

}
