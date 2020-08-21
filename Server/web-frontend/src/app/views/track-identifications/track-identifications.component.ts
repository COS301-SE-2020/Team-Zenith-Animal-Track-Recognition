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
	trackIdentifications: any;
	tracksRetrieved = false;
	searchText: string;
	sortBySurname: boolean = true;
	currentAlphabet;
	sorted: string;
	timeAsString: any = [];
	
	constructor(private http: HttpClient) { }

	ngOnInit(): void {
		document.getElementById("geotags-route").classList.add("activeRoute");
		/*this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'"){spoorIdentificationID,animal{classification,animalID,commonName,heightM,heightF,weightM,weightF,dietType,lifeSpan,Offspring,gestationPeriod,animalOverview,animalDescription,animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID,accessLevel,firstName,lastName,pictureURL},potentialMatches{confidence},picture{picturesID,URL,kindOfPicture}}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.trackIdentifications = temp[0];
				console.log("Parent: " + this.trackIdentifications);
				this.tracksRetrieved = true;
				console.log("Tracks have been retrieved: " + this.tracksRetrieved);
				this.timeToString();
			});
	}
	
	timeToString(){
		this.trackIdentifications.forEach(element => {
			let temp = element.dateAndTime;
			temp.month = temp.month < 10 ? '0' + temp.month : temp.month;
			temp.day = temp.day < 10 ? '0' + temp.day : temp.day;
			temp.hour = temp.hour < 10 ? '0' + temp.hour : temp.hour;
			temp.min = temp.min < 10 ? '0' + temp.min : temp.min;
			temp.second = temp.second < 10 ? '0' + temp.second : temp.second;        
			const str: string = temp.year + "-" + temp.month + "-" + temp.day + "T" + temp.hour + ":" + temp.min + ":" + temp.second + ".000Z";
			element.timeAsString = str;
		});
	}

	updateSearchText(event) {
		this.searchText = event;
	}

	refresh(updateOp: string) {
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
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
