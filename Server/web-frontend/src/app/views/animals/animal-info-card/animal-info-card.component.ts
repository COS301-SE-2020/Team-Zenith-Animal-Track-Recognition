import { Router } from '@angular/router';
import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { EditAnimalInfoComponent } from './../edit-animal-info/edit-animal-info.component';
//import {DeleteRangerComponent} from './../delete-ranger/delete-ranger.component';

@Component({
  selector: 'app-animal-info-card',
  templateUrl: './animal-info-card.component.html',
  styleUrls: ['./animal-info-card.component.css']
})
export class AnimalInfoCardComponent implements OnInit {

  @Input() animals;
  @Input() searchText: string;
  @Output() animalsOnChange: EventEmitter<Object> = new EventEmitter();
  
  constructor(private http: HttpClient, private router: Router, public dialog: MatDialog) { }

  ngOnInit(): void { this.startLoader();  }

  public ngOnChanges(changes: SimpleChanges) {
		this.startLoader();
		if ('rangers' in changes) {
			//If rangers has updated
		}
		this.stopLoader();
	}

  printOut(temp: any) {
    this.animals = temp[0];
    console.log(this.animals);
    this.sort(true);
  }


  //animal CRUD Quick-Actions

  //EDIT 
  openEditAnimalDialog(animalClassi) {
    const dialogConfig = new MatDialogConfig();

    //Get animal information for chosen card
    var animalName = document.getElementById(animalClassi + "Name").textContent;
    var animalClassification = document.getElementById(animalClassi + "Classification").textContent;
    var animalDescription = document.getElementById(animalClassi + "Descr").textContent;

    this.dialog.open(EditAnimalInfoComponent, { height: '85%', width: '65%', autoFocus: true, disableClose: true, data: { name: animalName, classification: animalClassification, description: animalDescription }, });
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
  //Loader
  startLoader() {
    console.log("Starting Loader");
    document.getElementById("loader-container").style.visibility = "visible";
  }
  stopLoader() {
    console.log("Stopping Loader");
    document.getElementById("loader-container").style.visibility = "hidden";
  }

}
