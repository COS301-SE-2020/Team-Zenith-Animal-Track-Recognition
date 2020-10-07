import { Component, OnInit } from '@angular/core';
import { EMPTY } from 'rxjs';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { retry, catchError } from 'rxjs/operators';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { Router, ActivatedRoute } from '@angular/router';
import { Track } from 'src/app/models/track';
import { RangerStatisticsService } from './../../services/ranger-statistics.service';
//import * as CanvasJS from './canvasjs.min';

@Component({
  selector: 'app-overview',
  templateUrl: './overview.component.html',
  styleUrls: ['./overview.component.css']
})
export class OverviewComponent implements OnInit {
	logins: any;
	mostTracked: any;
	rangers: any;
	latest: any;
	animalPercentages: any;
	leastIdentified: any;
	
	loginsPerApp = [
		{
			"name": "Mobile App Logins",
			"value": 0
		},
		{
			"name": "Web App Logins",
			"value": 0
		}
	];
	loginsPerLevel = [
		{
			"name": "Level 1 Logins",
			"value": 0
		},
		{
			"name": "Level 2 Logins",
			"value": 0
		},
		{
			"name": "Level 3 Logins",
			"value": 0
		}
	];
	//view: any[] = [];

	showLegend: boolean = true;
	showLabels: boolean = true;
	loginsPerAppColorScheme = {
		domain: ['#E44D25', '#509CD0']
	};
	loginsPerLevelColorScheme = {
		domain: ['#E44D25', '#509CD0', '#5AA454']
	};

	constructor(private router: Router, private rangerStatsService: RangerStatisticsService) { 
		rangerStatsService.loginsByApplication$.subscribe(
			logins => {
				this.loginsPerApp = logins;
			}
		);
		rangerStatsService.loginsByLevel$.subscribe(
			logins => {
				this.loginsPerLevel = logins;
			}
		);
		/*
		//Get the latest collection of track identifications
		tracksService.identifications.subscribe(
			trackList => {
				//Add track markers to the map if tracks are present
				if (trackList != null && trackList.length > 0) {
					//Add track markers to the map if initial list of tracks
					if (this.trackIdentifications == null) {
						this.trackIdentifications = trackList;	
						this.addTrackMarkers();
					}
					else {
						//Updating identifications with filtered tracks
						this.trackIdentifications = trackList;
					}
				}
				else if (trackList != null && trackList.length == 0) {
					if (this.trackIdentifications != null) {
						//If the track list returned is not the initial value but is empty nonetheless (if filtered for example)
						this.trackIdentifications = trackList;
					}
				}
			}
		);
		//Determines which filter option is applied to the tracks and markers
		tracksService.trackFilter$.subscribe(
			filter => {
				this.filterTrackMarkers(filter[0], filter[1]);
			}
		);		
		//Determines which track is being zoomed on
		trackViewNavService.trackMapZoom$.subscribe(
			coords => {
				this.zoomOnTrack(coords);
			}
		);
		//Determines whether the heatmap is currently viewable
		trackViewNavService.trackHeatmap$.subscribe(
			state => {
				this.toggleHeatmap(state);
			}
		);
		//Determines whether the heatmap is currently viewable
		trackViewNavService.trackHeatmapTimeRange$.subscribe(
			timeRange => {
				this.changeHeatmapTimeRange(timeRange);
			}
		);
		//Determine whether the heatmap settings tab is open, closed or simply inactive
		trackViewNavService.trackHeatmapSettings$.subscribe(
			state => {
				switch(state) {
					case "on":
						this.showHeatmapSettingsBtn = true;
					break;
					case "off":
						this.showHeatmapSettingsBtn = false;
					break;
					case "inactive":
						this.toggleHeatmapTab();
					break;
				};
			}
		);
		//Determines which colour the heatmap is set to
		trackViewNavService.trackHeatmapColour$.subscribe(
			colour => {
				this.changeHeatmapColour(colour);
			}
		);
		//Determines the radius of the heatmap around each track
		trackViewNavService.trackHeatmapRadius$.subscribe(
			radius => {
				this.changeHeatmapRadius(radius);
			}
		);*/
	}
	ngOnInit(): void {
		document.getElementById("overview-route").classList.add("activeRoute");
		this.loadStatistics();
	  /*
    this.mostTracked = { mosotTrakedRanger: '' };
    this.latest = { ranger: { firstName: '', lastName: '' }, animal: { commonName: '' } };
    this.leastIdentified = { commonName: ''};
    this.animalPercentages = { commonName: ''};

    this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
      '"){rangerID,password,accessLevel,eMail,firstName,lastName,phoneNumber}}')
      .pipe(
        retry(3),
        catchError(() => {
          this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
          this.stopLoader();
          this.stopSidenavLoader();
          return EMPTY;
        })
      )
      .subscribe((data: any[]) => {
        let temp = [];
        temp = Object.values(Object.values(data)[0]);
        this.rangers = temp[0];
      });


    this.http.get<any>(ROOT_QUERY_STRING + '?query=query{rangersStats2(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
      '"){mosotTrakedRanger{firstName,lastName},AnimalTracked}}')
      .pipe(
        retry(3),
        catchError(() => {
          this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
          this.stopLoader();
          this.stopSidenavLoader();
          return EMPTY;
        })
      )
      .subscribe((data: any[]) => {
        let temp = [];
        temp = Object.values(Object.values(data)[0]);
        this.mostTracked = temp[0];
      });

    this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
      '",sigil:"yes"){animal{commonName},ranger{rangerID,accessLevel,firstName,lastName},dateAndTime{year,month,day,hour,min,second}}}')
      .pipe(
        retry(3),
        catchError(() => {
          this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
          this.stopLoader();
          this.stopSidenavLoader();
          return EMPTY;
        })
      )
      .subscribe((data: any[]) => {
        let temp = [];
        temp.push(Object.values(Object.values(data)[0])[0]);
        this.latest = temp[0][0];
        this.timeToString(this.latest);
      });

    this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsStats3(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
      '"){commonName,NumberOfIdentifications}}')
      .pipe(
        retry(3),
        catchError(() => {
          this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
          this.stopLoader();
          this.stopSidenavLoader();
          return EMPTY;
        })
      )
      .subscribe((data: any[]) => {
        let temp = [];
        temp = Object.values(Object.values(data)[0]);
        this.animalPercentages = temp[0];

      });

    this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsStats4(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
      '"){commonName,NumberOfIdentifications}}')
      .pipe(
        retry(3),
        catchError(() => {
          this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
          this.stopLoader();
          this.stopSidenavLoader();
          return EMPTY;
        })
      )
      .subscribe((data: any[]) => {
        let temp = [];
        temp = Object.values(Object.values(data)[0]);
        this.leastIdentified = temp[0];

      });

    setTimeout(() => {
      this.stopLoader();
    }, 1000);
	*/
	}
	
	onSelect(event) {
		console.log(event);
	}

	
	loadStatistics() {
		this.rangerStatsService.getRangerLogins(JSON.parse(localStorage.getItem('currentToken'))['value']);
	}
	
	route(temp: string) {
		this.router.navigate([temp]);
	}

	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}		
	stopSidenavLoader() {
		//throw new Error('Method not implemented.');
	}
}
