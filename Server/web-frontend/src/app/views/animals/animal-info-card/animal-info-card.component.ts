import { Router } from '@angular/router';
import { Component, OnInit, Input } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
//import {EditRangerInfoComponent} from './../edit-ranger-info/edit-ranger-info.component'; 
//import {DeleteRangerComponent} from './../delete-ranger/delete-ranger.component';

@Component({
  selector: 'app-animal-info-card',
  templateUrl: './animal-info-card.component.html',
  styleUrls: ['./animal-info-card.component.css']
})
export class AnimalInfoCardComponent implements OnInit {

  @Input() searchText: string;
  animals;

  constructor(private http: HttpClient, private router: Router, public dialog: MatDialog) { }

  ngOnInit(): void {
    this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{animals(Token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '"){Classification,Common_Name,Description_of_animal,Pictures{URL}}}')
      .subscribe((data: any[]) => {
        let temp = [];
        temp = Object.values(Object.values(data)[0]);
        this.printOut(temp);
      });
  }

  printOut(temp: any) {
    this.animals = temp[0];
    this.sort(true);
  }


  //animal CRUD Quick-Actions

  //EDIT 
  openEditAnimalDialog(animalID) {
    const dialogConfig = new MatDialogConfig();

    //Get animal information for chosen card
    var animalFullName = document.getElementById("animal" + animalID + "Name").innerHTML;
    var animalName = animalFullName.split("&nbsp;");
    var animalLevel = document.getElementById("animal" + animalID + "animalLevel").textContent;
    var animalPhone = document.getElementById("animal" + animalID + "PhoneNumber").textContent;
    var animalEmail = document.getElementById("animal" + animalID + "Email").textContent;


    //this.dialog.open(EditAnimalInfoComponent, {height: '55%', width: '35%', autoFocus: true, disableClose: true, data: { firstName: animalName[0], lastName: animalName[1], level: animalLevel, phoneNum: animalPhone.replace("call",""), email: animalEmail.replace("mail","")},});
  }

  //DELETE animal
  openDeleteAnimalDialog(animalID) {
    const dialogConfig = new MatDialogConfig();

    //Get animal information for chosen card
    var animalFullName = document.getElementById("animal" + animalID + "Name").textContent;

    //	this.dialog.open(DeleteAnimalComponent, {height: '45%', width: '30%', autoFocus: true, disableClose: true, data: { name: animalFullName,},});
  }


  sort(bool: boolean) {
    if (bool) {
      for (let i = 0; i < this.animals.length - 1; i++) {
        for (let j = i + 1; j < this.animals.length; j++) {
          if (this.animals[i].Common_Name.toUpperCase() > this.animals[j].Common_Name.toUpperCase()) {
            let temp = this.animals[i];
            this.animals[i] = this.animals[j];
            this.animals[j] = temp;
          }
        }
      }
    } else {
      for (let i = 0; i < this.animals.length - 1; i++) {
        for (let j = i + 1; j < this.animals.length; j++) {
          if (this.animals[i].Access_Level > this.animals[j].Access_Level) {
            let temp = this.animals[i];
            this.animals[i] = this.animals[j];
            this.animals[j] = temp;
          }
        }
      }
    }
  }

}
