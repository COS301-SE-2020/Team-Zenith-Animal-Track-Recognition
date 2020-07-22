import { Component, OnInit, ViewChild } from '@angular/core';
import { MatSidenavModule } from '@angular/material/sidenav';

@Component({
	selector: 'app-rangers',
	templateUrl: './rangers.component.html',
	styleUrls: ['./rangers.component.css']
})
export class RangersComponent implements OnInit {

	@ViewChild('sidenav') sidenav;
	searchText: string;

	constructor() { }

	ngOnInit(): void {
		document.getElementById("rangers-route").classList.add("activeRoute");

	}

	openSidenav() {
		this.sidenav.open();
		document.getElementById("sidenav-open-btn-container").style.transitionDuration = "0.2s";
		document.getElementById("sidenav-open-btn-container").style.left = "-10%";
	}
	closeSidenav() {
		this.sidenav.close();
		document.getElementById("sidenav-open-btn-container").style.transitionDuration = "0.8s";
		document.getElementById("sidenav-open-btn-container").style.left = "0%";
	}

}
