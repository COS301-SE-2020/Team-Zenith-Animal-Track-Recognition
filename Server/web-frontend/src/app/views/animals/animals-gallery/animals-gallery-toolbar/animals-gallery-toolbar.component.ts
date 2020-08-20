import { Component, OnInit, Input, Output, EventEmitter, SimpleChanges } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-animals-gallery-toolbar',
  templateUrl: './animals-gallery-toolbar.component.html',
  styleUrls: ['./animals-gallery-toolbar.component.css']
})
export class AnimalsGalleryToolbarComponent implements OnInit {

	constructor(private router: Router, public dialog: MatDialog, private http: HttpClient, private snackBar: MatSnackBar) { }

	ngOnInit(): void {
	}

	route(location: string) {
		document.getElementById("animals-route-link").classList.remove("activeRoute");
		document.getElementById("animals-gallery-route").classList.remove("activeRoute");
		document.getElementById("overview-route").classList.remove("activeRoute");
		document.getElementById("rangers-route").classList.remove("activeRoute");
		document.getElementById("geotags-route").classList.remove("activeRoute");
		document.getElementById("settings-route").classList.remove("activeRoute");
		
		this.router.navigate([location]);
	}
}
