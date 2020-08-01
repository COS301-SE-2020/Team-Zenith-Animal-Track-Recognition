import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { AddAnimalComponent } from './../add-animal/add-animal.component';
import { HttpClient } from '@angular/common/http';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-animals-toolbar',
  templateUrl: './animals-toolbar.component.html',
  styleUrls: ['./animals-toolbar.component.css']
})
export class AnimalsToolbarComponent implements OnInit {


  @Input() animals;
  @Input() searchText: string;
  @Input() sortByCommonName: boolean;
  @Output() animalsOnChange: EventEmitter<Object> = new EventEmitter();
  @Output() sBSOnChange: EventEmitter<string> = new EventEmitter();
	
  constructor(private router: Router, public dialog: MatDialog, private http: HttpClient, private snackBar: MatSnackBar) { }

  ngOnInit(): void {}

  openAddAnimalDialog() {
		const dialogConfig = new MatDialogConfig();

		const addDialogRef = this.dialog.open(AddAnimalComponent, { height: '85%', width: '70%', panelClass: 'add-ranger-modal', autoFocus: true, disableClose: true });
		addDialogRef.afterClosed().subscribe(result => {
			this.stopLoader();
			if (result == 'success') {
				//If ranger was successfully added, refresh component and notify parent
				this.animalsOnChange.emit('update');
			}
			else {
				this.snackBar.open('An error occured when adding the new animal. Please try again.', "Dismiss", { duration: 5000, });
				//console.log('Error adding animal: ', result);
			}
		});
  }
 	//Loader
	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}

	route(location: string) {
		document.getElementById('animals-route').classList.remove('activeRoute');
		document.getElementById('overview-route').classList.remove('activeRoute');
		document.getElementById('rangers-route').classList.remove('activeRoute');
		document.getElementById('geotags-route').classList.remove('activeRoute');
		document.getElementById('settings-route').classList.remove('activeRoute');

		this.router.navigate([location]);
	}
}
