import { Router } from '@angular/router';
import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FnParam } from '@angular/compiler/src/output/output_ast';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { EditAnimalInfoComponent } from './../edit-animal-info/edit-animal-info.component';
import { MatSnackBar } from '@angular/material/snack-bar';


@Component({
  selector: 'app-animal-info-card',
  templateUrl: './animal-info-card.component.html',
  styleUrls: ['./animal-info-card.component.css']
})
export class AnimalInfoCardComponent implements OnInit {

  @Input() animals: any;
  @Input() searchText: string;
  @Input() sortByCommonName: boolean;
  @Output() animalsOnChange: EventEmitter<Object> = new EventEmitter();

  constructor(private http: HttpClient, private router: Router, public dialog: MatDialog, private changeDetection: ChangeDetectorRef, private snackBar: MatSnackBar) { }

  ngOnInit(): void {
    this.startLoader();
    console.log(this.animals);
  }

	public ngOnChanges(changes: SimpleChanges) {
		this.startLoader();
		if (changes.animals) {
		  //If animals has updated
		  this.changeDetection.markForCheck();
		  this.ngOnInit();
		}
		this.stopLoader();
	}

  //Animal CRUD Quick-Actions

  //EDIT 
  openEditAnimalDialog(animalID) {

    const dialogConfig = new MatDialogConfig();

    //Get animal information for chosen card
    var chosenAnimal;
    for (let i = 0; i < this.animals.length; i++) {
      if (animalID == this.animals[i].Animal_ID) {
        chosenAnimal = this.animals[i];
        i = this.animals[i].length;
      }
    }
    const editDialogRef = this.dialog.open(EditAnimalInfoComponent, { height: '85%', width: '60%', autoFocus: true, disableClose: true, data: { animal: chosenAnimal }, });
    editDialogRef.afterClosed().subscribe(result => {
      this.stopLoader();
      if (result == "success") {
        //If animal was successfully edited
        //Refresh component and notify parent
        this.animalsOnChange.emit("update");
      }
      else if (result == 'error') {
		this.snackBar.open('An error occured when editting the animal. Please try again.', "Dismiss", { duration: 5000, });
      }
    });
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
    document.getElementById("loader-container").style.visibility = "visible";
  }
  stopLoader() {
    document.getElementById("loader-container").style.visibility = "hidden";
  }

}
