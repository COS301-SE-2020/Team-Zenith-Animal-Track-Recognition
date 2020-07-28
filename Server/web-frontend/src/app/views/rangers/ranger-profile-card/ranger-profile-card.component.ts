import { Router } from '@angular/router';
import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges} from '@angular/core';
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
export class RangerProfileCardComponent implements OnInit 
{

	@Input() searchText: string;
	@Input() rangers;
	@Output() rangersOnChange: EventEmitter<Object> = new EventEmitter();
	sorted: string;

	constructor(private http: HttpClient, private router: Router, public dialog: MatDialog) {}
	ngOnInit(): void {this.startLoader();}
	
	public ngOnChanges(changes: SimpleChanges) 
	{
		this.startLoader();
        if ('rangers' in changes) 
		{
			//If rangers has updated
			console.log("RANGER PROFILE CARD NGONCHANGE");
        }
		//console.log("RANGER PROFILE CARD There are  " + this.rangers.length + " rangers");
		this.stopLoader();
    }    
	
	trackByRangerSurname(index: number, ranger: any): string 
	{
		//console.log("RANGER PROFILE CARD TRACKING " + ranger.lastName);
		return ranger.lastName;
	}
	
	//Ranger CRUD Quick-Actions

	//EDIT Ranger
	openEditRangerDialog(rangerID) 
	{
		const dialogConfig = new MatDialogConfig();

		//Get ranger information for chosen card
		var rangerFullName = document.getElementById("ranger" + rangerID + "Name").innerHTML;
		var rangerName = rangerFullName.split("&nbsp;");
		var rangerLevel = document.getElementById("ranger" + rangerID + "RangerLevel").textContent;
		var rangerPhone = document.getElementById("ranger" + rangerID + "PhoneNumber").textContent;
		var rangerEmail = document.getElementById("ranger" + rangerID + "Email").textContent;

		const editDialogRef = this.dialog.open(EditRangerInfoComponent, { height: '55%', width: '35%', autoFocus: true, disableClose: true, data: { Token: rangerID, firstName: rangerName[0], lastName: rangerName[1], level: rangerLevel, phoneNumber: rangerPhone.replace("call", ""), email: rangerEmail.replace("mail", "") }, });
		editDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			if (result == "success")
			{
				//If ranger was successfully edited
				console.log("EDITING ", result);
				//Refresh component and notify parent
				this.rangersOnChange.emit("update");
			}
			else
			{
				console.log("Error editing ranger: ", result);
			}
		});
	}
	//DELETE Ranger
	openDeleteRangerDialog(rangerID) 
	{
		try 
		{
			const dialogConfig = new MatDialogConfig();

			var rangerFullName = document.getElementById("ranger" + rangerID + "Name").textContent;

			const deleteDialogRef = this.dialog.open(DeleteRangerComponent, { height: '45%', width: '30%', autoFocus: true, disableClose: true, data: { name: rangerFullName, Token: rangerID }, });
			deleteDialogRef.afterClosed().subscribe(result => {
				this.stopLoader();
				if (result == "success")
				{
					//If ranger was successfully deleted
					console.log("DELETING ", result);
					//Refresh component and notify parent
					this.rangersOnChange.emit("update");
				}
				else
				{
					console.log("Error deleting ranger: ", result);
				}
			});
		} 
		catch (e) 
		{
			return false;
		}
	}

  	route(temp: string) 
	{
		this.router.navigate([temp]);
	}

  sort(bool: boolean) {
    let temp: string;
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
      temp = "Sorted alphabetically";
    } else {
      for (let i = 0; i < this.rangers.length - 1; i++) {
        for (let j = i + 1; j < this.rangers.length; j++) {
          if (this.rangers[i].rangerLevel > this.rangers[j].rangerLevel) {
            let temp = this.rangers[i];
            this.rangers[i] = this.rangers[j];
            this.rangers[j] = temp;
          }
        }
      }
      temp = "Sorted by ranger level";
    }
    this.sorted = temp;
    return temp;
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
