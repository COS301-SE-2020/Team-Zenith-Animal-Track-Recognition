import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
//import { AddRangerComponent } from './../add-ranger/add-ranger.component';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-animals-toolbar',
  templateUrl: './animals-toolbar.component.html',
  styleUrls: ['./animals-toolbar.component.css']
})
export class AnimalsToolbarComponent implements OnInit {

	animals;
  constructor(    private router: Router,
    public dialog: MatDialog,
    private http: HttpClient) { }

  ngOnInit(): void {
  }
  
  printOut(temp: any) {
    this.animals = temp;
  }

  openAddAnimalDialog() {
    const dialogConfig = new MatDialogConfig();

   // this.dialog.open(AddRangerComponent, { height: '55%', width: '35%', panelClass: "add-ranger-modal", autoFocus: true, disableClose: true });
  }
  route(location: string) {
    document.getElementById("animals-route").classList.remove("activeRoute");
    document.getElementById("overview-route").classList.remove("activeRoute");
    document.getElementById("rangers-route").classList.remove("activeRoute");
    document.getElementById("geotags-route").classList.remove("activeRoute");
    document.getElementById("settings-route").classList.remove("activeRoute");

    this.router.navigate([location]);
  }

}
