import { Component, OnInit, Input } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import {MatDialog, MatDialogRef, MatDialogConfig} from '@angular/material/dialog'; 
import {AddRangerComponent} from './../add-ranger/add-ranger.component'; 

@Component({
  selector: 'app-rangers-toolbar',
  templateUrl: './rangers-toolbar.component.html',
  styleUrls: ['./rangers-toolbar.component.css']
})
export class RangersToolbarComponent implements OnInit {


  constructor( private router: Router, public dialog: MatDialog) { }

  @Input() searchText: string;

  ngOnInit(): void {
  }
  
    openAddRangerDialog() 
	{
		const dialogConfig = new MatDialogConfig();
		
		this.dialog.open(AddRangerComponent, {height: '55%', width: '35%', autoFocus: true, disableClose: true});
	}
  route(location: string) 
  {
    document.getElementById("animals-route").classList.remove("activeRoute");
    document.getElementById("overview-route").classList.remove("activeRoute");
    document.getElementById("rangers-route").classList.remove("activeRoute");
    document.getElementById("geotags-route").classList.remove("activeRoute");
    document.getElementById("settings-route").classList.remove("activeRoute");
	
    this.router.navigate([location]);
  }
}