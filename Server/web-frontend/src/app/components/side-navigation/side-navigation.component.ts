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
		this.router.navigate([location]);
	}
	
	toggleAnimalsPanel()
	{
		this.animalsPanel.toggle();
		document.getElementById("animals-expand-btn-icon").classList.toggle("rotateIcon");
	}
}
