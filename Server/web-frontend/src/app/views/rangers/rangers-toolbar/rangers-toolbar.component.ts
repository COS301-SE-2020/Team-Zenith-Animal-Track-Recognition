import { Component, OnInit, Input } from '@angular/core';
import {MatDialog, MatDialogRef, MatDialogConfig} from '@angular/material/dialog'; 
import {AddRangerComponent} from './../add-ranger/add-ranger.component'; 
import {MatDatepickerModule} from '@angular/material/datepicker'; 
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-rangers-toolbar',
  templateUrl: './rangers-toolbar.component.html',
  styleUrls: ['./rangers-toolbar.component.css']
})
export class RangersToolbarComponent implements OnInit {


  constructor(public dialog: MatDialog) { }

  @Input() searchText: string;

  ngOnInit(): void {
  }
  
    openAddRangerDialog() 
	{
		console.log("TEEEES");
		const dialogConfig = new MatDialogConfig();
		
		this.dialog.open(AddRangerComponent, {height: '55%', width: '35%', panelClass: "add-ranger-modal", autoFocus: true, disableClose: true});
	}

}