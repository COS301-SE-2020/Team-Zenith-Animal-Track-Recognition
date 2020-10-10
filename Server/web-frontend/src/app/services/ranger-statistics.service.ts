import { Injectable } from '@angular/core';
import { clone, cloneDeep } from "lodash";
import { BehaviorSubject, Observable, of, Subject, EMPTY } from 'rxjs';
import { catchError, map, retry } from 'rxjs/operators';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { MessageService } from './message.service';
import { Track } from 'src/app/models/track';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { TRACKS_QUERY_STRING } from 'src/app/models/data';
import { TracksService } from './tracks.service';

@Injectable({
  providedIn: 'root'
})
export class RangerStatisticsService {
	//private activeTrackSource = new BehaviorSubject<Track>(null);
	//activeTrack$ = this.activeTrackSource.asObservable();
	
	private trackRootQueryUrl = TRACKS_QUERY_STRING + '?query=query{spoorIdentification';
	private userRootQueryUrl = ROOT_QUERY_STRING + '?query=query{user';
	private loginsRootQueryUrl = ROOT_QUERY_STRING + '?query=query{recentLogins';
	
	//Ranger Login statistics variables
	//Store a local copy of all ranger logins
	private rangerLoginsStore: { rangerLogins: any[] } = { rangerLogins: null };
	private _rangerLogins = new BehaviorSubject<any[]>([]);
	readonly rangerLogins = this._rangerLogins.asObservable();
	
	private defaultNumRecentLogins = 50;	
	private recentLoginsSource = new BehaviorSubject<any[]>([]);
	recentLogins$ = this.recentLoginsSource.asObservable();
	
	private loginsByApplicationSource = new Subject<any[]>();
	loginsByApplication$ = this.loginsByApplicationSource.asObservable();	
	
	private loginsByDateSource = new Subject<any[]>();
	loginsByDate$ = this.loginsByDateSource.asObservable();	
	
	private loginsByLevelSource = new Subject<any[]>();
	loginsByLevel$ = this.loginsByLevelSource.asObservable();
	
	//Tracking Activity Variables
	private _displayedTracks = new BehaviorSubject<any[]>([]);
	readonly displayedTracks = this._displayedTracks.asObservable();
	//Store a local copy of all track identifications
	private trackIdentificationsStore: { trackIdentifications: Track[] } = { trackIdentifications: null };
	
	private allIdentificationsByDateSource = new Subject<any[]>();
	allIdentificationsByDate$ = this.allIdentificationsByDateSource.asObservable();
	private avgScoreAllTimeSource = new Subject<any[]>();
	avgScoreAllTime$ = this.avgScoreAllTimeSource.asObservable();	
	private numIdentificationsSource = new Subject<any[]>();
	numIdentifications$ = this.numIdentificationsSource.asObservable();	
		private mostIdentifiedSource = new Subject<any[]>();
	 mostIdentified$ = this.mostIdentifiedSource.asObservable();	
	
	constructor(private http: HttpClient, private messageService: MessageService) { }
	
	get logins() {
		return this._rangerLogins.asObservable();
	}
	get identifications() {
		return this._displayedTracks.asObservable();
	}
	
		
	//Login Activity functions
	getRangerLoginActivity(token: string)
	{
		const getRangerLoginQueryUrl = this.loginsRootQueryUrl + '(token:"' + token + '"){rangerID{rangerID, firstName,lastName,accessLevel},time,platform}}';
		this.http.get<Track[]>(getRangerLoginQueryUrl)
			.subscribe( data => {
				this.rangerLoginsStore.rangerLogins = Object.values(Object.values(data)[0])[0];	
				this.rangerLoginsStore.rangerLogins.forEach(ranger => {
					let temp = ranger.time.split(" ");
					let temp2 = temp[1].split(":");
					if (temp2[0].length == 1) 
						temp2[0] = "0" + temp2[0];
					if (temp2[1].length == 1) 
						temp2[1] = "0" + temp2[1];
					if (temp2[2].length == 1) 
						temp2[2] = "0" + temp2[2];
					let dateObjString = temp[0] + "T" + temp2[0] + ":" + temp2[1] + ":" + temp2[2];
					ranger.dateObj = new Date(dateObjString);
				});
				this._rangerLogins.next(Object.assign({}, this.rangerLoginsStore).rangerLogins);
				this.calculateLoginsByApplication();
				this.calculateLoginsByLevel();
				
				var startDate = new Date();
				startDate.setDate(startDate.getDate() - 7);
				this.getLoginsByDate(startDate, new Date(), "platform");
				this.getRecentLogins(this.defaultNumRecentLogins);
			},
				error => {
					this._rangerLogins.next([]);
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);
	}
	getLoginsByDate(startDate: any, endDate: any, dataType: string) {
		var allRangerLogins = cloneDeep(this.rangerLoginsStore.rangerLogins);
		
		//Filter out logins that do not fall within the time range
		var filteredLogins = [];		
		var startDateTime = startDate.getTime();
		var endDateTime = endDate.getTime();
		var loginTime;
				
		allRangerLogins.forEach(login => {
			loginTime = login.dateObj.getTime();
			if (loginTime >= startDateTime && loginTime <= endDateTime) {
				filteredLogins.push(login);
			}
		});
		
		var numDays = Math.abs((endDateTime - startDateTime) / (1000 * 3600 * 24));
		numDays++;
		//console.log("Checking dates from " + endDate.toDateString() + " to " + startDate.toDateString());
		//console.log("Difference in days between start and end dates is:" + numDays);
		
		//Count number of logins on a specific date per platform or level
		var fromDate = new Date(startDateTime);
		var logins = [];
		switch(dataType) {
			case "level":
				var levelOneSeries = [];
				var levelTwoSeries = [];
				var levelThreeSeries = [];
				var levelOneNumLogins = 0;
				var levelTwoNumLogins = 0;
				var levelThreeNumLogins = 0;
				
				for (let i = 0; i < numDays; i++) {
					levelOneNumLogins = 0;
					levelTwoNumLogins = 0;
					levelThreeNumLogins = 0;
					fromDate = new Date(endDateTime);
					fromDate.setDate(fromDate.getDate() - i);
					
					filteredLogins.forEach(ranger => {
						if (this.isSameDay(ranger.dateObj, fromDate))  {
							if (ranger.rangerID.accessLevel == "1") {
								levelOneNumLogins++;
							}
							else if (ranger.rangerID.accessLevel == "2") {
								levelTwoNumLogins++;
							}
							else if (ranger.rangerID.accessLevel == "3") {
								levelThreeNumLogins++;
							}
						}
					});
					levelOneSeries.push({"value": levelOneNumLogins, "name": fromDate});
					levelTwoSeries.push({"value": levelTwoNumLogins, "name": fromDate});
					levelThreeSeries.push({"value": levelThreeNumLogins, "name": fromDate});
				}
				logins.push(
					{"name":"Level 1 Rangers", "series": levelOneSeries.reverse()}, 
					{"name":"Level 2 Rangers", "series": levelTwoSeries.reverse()}, 
					{"name":"Level 3 Ranger", "series": levelThreeSeries.reverse()}
				);
			break;
			case "platform":
				var mobileAppSeries = []; 
				var webAppSeries = []; 
				var mobileNumLogins = 0;
				var webNumLogins = 0;
				
				for (let i = 0; i < numDays; i++) {
					mobileNumLogins = 0;
					webNumLogins = 0;
					fromDate = new Date(endDateTime);
					fromDate.setDate(fromDate.getDate() - i);
					
					filteredLogins.forEach(ranger => {
						if (this.isSameDay(ranger.dateObj, fromDate))  {
							if (ranger.platform == "app" || ranger.platform == "Mobile Application") {
								mobileNumLogins++;
							}
							else if (ranger.platform == "wdb") {
								webNumLogins++;
							}
						}
					});
					mobileAppSeries.push({"value": mobileNumLogins, "name": fromDate});
					webAppSeries.push({"value": webNumLogins, "name": fromDate});
				}
				logins.push(
					{"name":"Mobile Application", "series": mobileAppSeries.reverse()}, 
					{"name":"Web Application", "series": webAppSeries.reverse()}
				);
			break;
		}
		
		this.loginsByDateSource.next(logins);		
	}
	getRecentLogins(numLogins: number) {
		var allRangerLogins = cloneDeep(this.rangerLoginsStore.rangerLogins);
		allRangerLogins.reverse();
		var maxNumLogins = allRangerLogins.length;
		
		if (numLogins < maxNumLogins) {
			maxNumLogins = numLogins;
		}
		this.recentLoginsSource.next(allRangerLogins.slice(0, maxNumLogins));
	}
	calculateLoginsByApplication() {
		var allRangerLogins = cloneDeep(this.rangerLoginsStore.rangerLogins);
		var mobileAppLogins = 0;
		var webAppLogins = 0;
		
		allRangerLogins.forEach(ranger => {
			if (ranger.platform == "app" || ranger.platform == "Mobile Application") {
				mobileAppLogins++;
			}
			else if (ranger.platform == "wdb") {
				webAppLogins++;
			}
		});
		var numLogins = [
			{"name": "Mobile Tracking", "value": mobileAppLogins}, 
			{"name": "Web Dashboard", "value": webAppLogins}
		];
		this.loginsByApplicationSource.next(numLogins);
	}
	calculateLoginsByLevel() {
		var allRangerLogins = cloneDeep(this.rangerLoginsStore.rangerLogins);
		var levelOneLogins = 0;
		var levelTwoLogins = 0;
		var levelThreeLogins = 0;
		
		allRangerLogins.forEach(ranger => {
			if (ranger.rangerID.accessLevel == "1") {
				levelOneLogins++;
			}
			else if (ranger.rangerID.accessLevel == "2") {
				levelTwoLogins++;
			}
			else if (ranger.rangerID.accessLevel == "3") {
				levelThreeLogins++;
			}
		});
		var numLogins = [
			{"name": "Level 1 Logins", "value": levelOneLogins}, 
			{"name": "Level 2 Logins", "value": levelTwoLogins},
			{"name": "Level 3 Logins", "value": levelThreeLogins}
		];
		this.loginsByLevelSource.next(numLogins);		
	}
	
	//Tracking Activity Statistics
	//HTTPS Requests
	getRangerTrackingActivity(token: string)
	{
		const getIdentificationsQueryUrl = this.trackRootQueryUrl + '(token:"' + token + '"){spoorIdentificationID,animal{classification,animalID,groupID{groupName},' +
			'commonName,pictures{picturesID,URL,kindOfPicture},animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},' +
			'ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},' +
			'confidence},picture{picturesID,URL,kindOfPicture},tags}}';
		this.http.get<Track[]>(getIdentificationsQueryUrl)
			.subscribe( data => {
				this.trackIdentificationsStore.trackIdentifications = Object.values(Object.values(data)[0])[0];	
				this.trackIdentificationsStore.trackIdentifications.forEach(element => {
					let temp = element.dateAndTime;
					element.dateObj = new Date(temp.year, temp.month - 1, temp.day, temp.hour, temp.min, temp.second);
					element.recency = element.dateObj.toISOString();
				});
				//this.calculateLoginsByApplication();
				//this.calculateLoginsByLevel();
				
				var startDate = new Date();
				startDate.setDate(startDate.getDate() - 7);
				this.getAllIdentificationsByDate(startDate, new Date());
				this.getAvgAccuracyScoreAllTime();
				this.numIdentificationsSource.next([{"name": "Animals Identified", "value":this.trackIdentificationsStore.trackIdentifications.length }]);
				this.getMostIdsByRanger();
				this._displayedTracks.next(Object.assign({}, this.trackIdentificationsStore).trackIdentifications);
			},
				error => {
					this._displayedTracks.next([]);
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);
	}
	getAllIdentificationsByDate(startDate: any, endDate: any) {
		var allTrackIdentifications = cloneDeep(this.trackIdentificationsStore.trackIdentifications);
		
		//Filter out logins that do not fall within the time range
		var filteredIds = [];		
		var startDateTime = startDate.getTime();
		var endDateTime = endDate.getTime();
		var trackTime;
				
		allTrackIdentifications.forEach(track => {
			trackTime = track.dateObj.getTime();
			if (trackTime >= startDateTime && trackTime <= endDateTime) {
				filteredIds.push(track);
			}
		});
		
		var numDays = Math.abs((endDateTime - startDateTime) / (1000 * 3600 * 24));
		numDays++;
		//console.log("Checking dates from " + endDate.toDateString() + " to " + startDate.toDateString());
		//console.log("Difference in days between start and end dates is:" + numDays);
		
		//Count number of logins on a specific date per platform or level
		var fromDate = new Date(startDateTime);
		var idPerDay = [];
		var identifications = [];
		var numIds = 0;
			
		for (let i = 0; i < numDays; i++) {
			numIds = 0;
			fromDate = new Date(endDateTime);
			fromDate.setDate(fromDate.getDate() - i);
					
			filteredIds.forEach(track => {
				if (this.isSameDay(track.dateObj, fromDate)) {
					numIds++;
				}
			});
			idPerDay.push({"value": numIds, "name": fromDate});
		}
		identifications.push({"name":"Track Identifications", "series": idPerDay.reverse()});

		this.allIdentificationsByDateSource.next(identifications);		
	}
	getAvgAccuracyScoreAllTime() {
		var allTrackIdentifications = cloneDeep(this.trackIdentificationsStore.trackIdentifications);
		var accuracyScore = 0;
		
		allTrackIdentifications.forEach(track => {
			accuracyScore += track.potentialMatches[track.potentialMatches.length - 1].confidence;
		});
		
		var avgScore =  Math.round(((accuracyScore/allTrackIdentifications.length) * 100));

		this.avgScoreAllTimeSource.next([{"name": "Average Accuracy Score","value": avgScore}]);
	}
	getMostIdsByRanger() {
		/*const getMostQueryUrl = this.trackRootQueryUrl + '(token:"' + token + '"){spoorIdentificationID,animal{classification,animalID,groupID{groupName},' +
			'commonName,pictures{picturesID,URL,kindOfPicture},animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},' +
			'ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},' +
			'confidence},picture{picturesID,URL,kindOfPicture},tags}}';
		this.http.get<Track[]>(getIdentificationsQueryUrl)
			.subscribe( data => {
				this.numIdentificationsSource.next([{"name": "Animals Identified", "value":this.trackIdentificationsStore.trackIdentifications.length }]);
			},
				error => {
					this._displayedTracks.next([]);
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);*/
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{rangersStats2(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
		  '"){mosotTrakedRanger{firstName,lastName},AnimalTracked}}')
		  .pipe(
			retry(3),
			catchError(() => {
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
			  return EMPTY;
			})
		  )
		  .subscribe((data: any[]) => {
			let temp = [];
			temp = Object.values(Object.values(data)[0]);
			var mostTracked = temp[0];
			console.log("most tracked");
			console.log(mostTracked);
			console.log(mostTracked.mosotTrakedRanger.AnimalTracked);
			this.mostIdentifiedSource.next([{"name": mostTracked.mosotTrakedRanger.firstName + " " + mostTracked.mosotTrakedRanger.lastName,
				"value": mostTracked.AnimalTracked }]);
		  });
	}
	
	isSameDay(date1: any, date2: any) {
		var isSameDay = false;
		if (date1.getDate() === date2.getDate() && date1.getMonth() === date2.getMonth() && date1.getFullYear() === date2.getFullYear())
			isSameDay = true;
		return isSameDay;
	}

	/**
	* Handle Http operation that failed.
	* Let the app continue.
	* @param operation - name of the operation that failed
	* @param result - optional value to return as the observable result
	*/
	private handleError<T>(operation = 'operation', result?: T) 
	{
		return (error: any): Observable<T> => {

			// TODO: send the error to remote logging infrastructure
			console.error(error);

			// TODO: better job of transforming error for user consumption
			this.log(`${operation} failed: ${error.message}`, true);

			// Let the app keep running by returning an empty result.
			return of(result as T);
		};
		
			/*  if (error.error instanceof ErrorEvent) {
		// A client-side or network error occurred. Handle it accordingly.
		console.error('An error occurred:', error.error.message);
	  } else {
		// The backend returned an unsuccessful response code.
		// The response body may contain clues as to what went wrong.
		console.error(
		  `Backend returned code ${error.status}, ` +
		  `body was: ${error.error}`);
	  }
	  // Return an observable with a user-facing error message.
	  return throwError(
		'Something bad happened; please try again later.');*/
	}

	/** Log a HeroService message with the MessageService */
	private log(message: string, dismissible: boolean) 
	{
		this.messageService.show(`${message}`, dismissible);
	}
}
