import { Component, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-side-navigation',
  templateUrl: './side-navigation.component.html',
  styleUrls: ['./side-navigation.component.css']
})
export class SideNavigationComponent implements OnInit {
  test: boolean = false;

	@ViewChild('animalsPanel') animalsPanel: any;

	constructor(private router: Router) { }

	ngOnInit(): void {
		this.test = true;
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
	
	toggleAnimalsPanel()
	{
		this.animalsPanel.toggle();
		document.getElementById("animals-expand-btn-icon").classList.toggle("rotateIcon");
	}
}
