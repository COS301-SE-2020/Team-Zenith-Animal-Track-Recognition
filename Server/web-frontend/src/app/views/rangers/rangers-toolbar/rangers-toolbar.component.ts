import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges} from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { AddRangerComponent } from './../add-ranger/add-ranger.component';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-rangers-toolbar',
  templateUrl: './rangers-toolbar.component.html',
  styleUrls: ['./rangers-toolbar.component.css']
})
export class RangersToolbarComponent implements OnInit 
{
	@Input() searchText: string;
	@Input() rangers;
	@Output() rangersOnChange: EventEmitter<string> = new EventEmitter();

	constructor(private router: Router, public dialog: MatDialog, private http: HttpClient) { }
	ngOnInit(): void {}
	
	public ngOnChanges(changes: SimpleChanges) 
	{
        if ('rangers' in changes) 
		{
			//If rangers has updated
			console.log("RANGER TOOLBAR NGONCHANGE");
        }
    }

	openAddRangerDialog() 
	{
		const dialogConfig = new MatDialogConfig();

		const addDialogRef = this.dialog.open(AddRangerComponent, { height: '55%', width: '35%', panelClass: "add-ranger-modal", autoFocus: true, disableClose: true });
		addDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			//Refresh component and notify parent
			if (result == "success")
			{
				//If ranger was successfully added
				console.log("ADDING ", result);
				//Refresh component and notify parent
				this.rangersOnChange.emit("update");
			}
			else
			{
				console.log("Error adding ranger: ", result);
			}
		});
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








