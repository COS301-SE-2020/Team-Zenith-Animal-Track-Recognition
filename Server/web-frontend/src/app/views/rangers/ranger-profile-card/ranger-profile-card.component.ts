import { Router } from '@angular/router';
import { Component, OnInit, Input } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { EditRangerInfoComponent } from './../edit-ranger-info/edit-ranger-info.component';
import { DeleteRangerComponent } from './../delete-ranger/delete-ranger.component';


@Component({
  selector: 'app-ranger-profile-card',
  templateUrl: './ranger-profile-card.component.html',
  styleUrls: ['./ranger-profile-card.component.css']
})
export class RangerProfileCardComponent implements OnInit {

  @Input() searchText: string;
  rangers;

  constructor(private http: HttpClient, private router: Router, public dialog: MatDialog) {
  }

  ngOnInit(): void {
    this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{Users(TokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '"){Token,Password,Access_Level,e_mail,firstName,lastName,phoneNumber}}')
      .subscribe((data: any[]) => {
        let temp = [];
        temp = Object.values(Object.values(data)[0]);
        this.printOut(temp);
      });
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

    this.dialog.open(EditRangerInfoComponent, { height: '55%', width: '35%', autoFocus: true, disableClose: true, data: { Token: rangerID, firstName: rangerName[0], lastName: rangerName[1], level: rangerLevel, phoneNumber: rangerPhone.replace("call", ""), email: rangerEmail.replace("mail", "") }, });
  }

  route(temp: string){
    this.router.navigate([temp]);
  }

  //DELETE Ranger
  openDeleteRangerDialog(rangerID) {
    const dialogConfig = new MatDialogConfig();

    //Get ranger information for chosen card
    var rangerFullName = document.getElementById("ranger" + rangerID + "Name").textContent;

    this.dialog.open(DeleteRangerComponent, { height: '45%', width: '30%', autoFocus: true, disableClose: true, data: { name: rangerFullName, Token: rangerID}, });
  }

  printOut(temp: any) {
    this.rangers = temp[0];
    this.sort(true);
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
          if (this.rangers[i].Access_Level > this.rangers[j].Access_Level) {
            let temp = this.rangers[i];
            this.rangers[i] = this.rangers[j];
            this.rangers[j] = temp;
          }
        }
      }
    }
  }
}
