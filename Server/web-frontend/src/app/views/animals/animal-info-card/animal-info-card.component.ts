import { Router } from '@angular/router';
import { Component, OnInit, Input } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import {EditAnimalInfoComponent} from './../edit-animal-info/edit-animal-info.component'; 
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

  ngOnInit(): void 
  {
	this.startLoader();
	    this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{animals(Token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '"){Classification,Common_Name,Description_of_animal,Pictures{URL}}}')
      .subscribe((data: any[]) => {
        let temp = [];
        temp = Object.values(Object.values(data)[0]);
		this.stopLoader();
        this.printOut(temp);
      });
  }
  
  
   //animal CRUD Quick-Actions
	
	//EDIT 
    openEditAnimalDialog(animalClassi) 
	{
		const dialogConfig = new MatDialogConfig();
		
		//Get animal information for chosen card
		var animalName = document.getElementById(animalClassi + "Name").textContent;
		var animalClassification = document.getElementById(animalClassi + "Classification").textContent;
		var animalDescription = document.getElementById(animalClassi + "Descr").textContent;
		
		this.dialog.open(EditAnimalInfoComponent, {height: '85%', width: '65%', autoFocus: true, disableClose: true, data: { name: animalName, classification: animalClassification, description: animalDescription},});
	}
  
  	//DELETE animal
	openDeleteAnimalDialog(animalID) 
	{
		const dialogConfig = new MatDialogConfig();
		
		//Get animal information for chosen card
		var animalFullName = document.getElementById("animal" + animalID + "Name").textContent;
		
	//	this.dialog.open(DeleteAnimalComponent, {height: '45%', width: '30%', autoFocus: true, disableClose: true, data: { name: animalFullName,},});
	}

  printOut(temp: any) 
  {
    this.animals = temp[0];
    this.sort(true);
	this.stopLoader();
  }

  sort(bool: boolean) {
    if (bool) {
      for (let i = 0; i < this.animals.length - 1; i++) {
        for (let j = i + 1; j < this.animals.length; j++) {
          if (this.animals[i].lastName.toUpperCase() > this.animals[j].lastName.toUpperCase()) {
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
  startLoader()
  {
	  console.log("Starting Loader");
	  document.getElementById("loader-container").style.visibility = "visible";
  }  
  stopLoader()
  {
	  	  console.log("Stopping Loader");
	  document.getElementById("loader-container").style.visibility = "hidden";
  }


}
