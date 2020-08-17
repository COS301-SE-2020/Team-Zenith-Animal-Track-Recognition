import { Component, OnInit, ViewChild, Input, Output, EventEmitter} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs/operators';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
  selector: 'app-track-identifications',
  templateUrl: './track-identifications.component.html',
  styleUrls: ['./track-identifications.component.css']
})

export class TrackIdentificationsComponent implements OnInit {
	
	@ViewChild('sidenav') sidenav;
	
	constructor(private http: HttpClient) { }

	ngOnInit(): void {
		document.getElementById("geotags-route").classList.add("activeRoute");
		/*this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){rangerID,password,accessLevel,eMail,firstName,lastName,phoneNumber}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.rangers = temp[0];
				this.sort(this.sortBySurname);
			});*/
	}
	
	showOpenBtn() {
		//Show Open Button
		document.getElementById('sidenav-open-btn-container').style.visibility = 'visible';
		document.getElementById('sidenav-open-btn-container').style.transitionDuration = '0.8s';
		document.getElementById('sidenav-open-btn-container').style.left = '0%';
		
		//Hide Closed Button
		document.getElementById('sidenav-close-btn-container').style.transitionDuration = '0.2s';
		document.getElementById('sidenav-close-btn-container').style.left = '-10%';	
		document.getElementById('sidenav-close-btn-container').style.visibility = 'hidden';
	}
	
	showCloseBtn() {
		//Show Close Button
		document.getElementById('sidenav-close-btn-container').style.visibility = 'visible';
		document.getElementById('sidenav-close-btn-container').style.transitionDuration = '0.8s';
		document.getElementById('sidenav-close-btn-container').style.left = '0%';		
		
		//Hide Open Button
		document.getElementById('sidenav-open-btn-container').style.transitionDuration = '0.2s';
		document.getElementById('sidenav-open-btn-container').style.left = '-10%';
		document.getElementById('sidenav-open-btn-container').style.visibility = 'hidden';
	}

	openSidenav() {
		this.sidenav.open();
		this.showCloseBtn();
	}
	
	closeSidenav() {
		this.sidenav.close();
		this.showOpenBtn();
	}
}
