import { Component, OnInit, Input } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { AddRangerComponent } from './../add-ranger/add-ranger.component';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-rangers-toolbar',
  templateUrl: './rangers-toolbar.component.html',
  styleUrls: ['./rangers-toolbar.component.css']
})
export class RangersToolbarComponent implements OnInit {
  rangers;

  constructor(
    private router: Router,
    public dialog: MatDialog,
    private http: HttpClient
  ) { }

  @Input() searchText: string;

  ngOnInit(): void {

    document.getElementById("rangers-route").classList.add("activeRoute");
    this.http.get<any>('http://192.168.8.95:55555/graphql?query=query{Users(TokenIn:"asdfg"){Token,Password,Access_Level,e_mail}}')
      .subscribe((data: any[]) => {
        let temp = [];
        temp = Object.values(Object.values(data)[0]);
        this.printOut(temp);
      });
  }

  printOut(temp: any) {
    this.rangers = temp;
  }

  openAddRangerDialog() {
    console.log("TEEEES");
    const dialogConfig = new MatDialogConfig();

    this.dialog.open(AddRangerComponent, { height: '55%', width: '35%', panelClass: "add-ranger-modal", autoFocus: true, disableClose: true });
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