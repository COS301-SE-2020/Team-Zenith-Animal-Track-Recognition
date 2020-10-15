import { Injectable } from '@angular/core';
import { clone, cloneDeep } from "lodash";
import { BehaviorSubject, Observable, of, Subject, EMPTY } from 'rxjs';
import { catchError, map, retry } from 'rxjs/operators';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { MessageService } from './message.service';
import { User } from 'src/app/models/user';
import { Track } from 'src/app/models/track';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { TRACKS_QUERY_STRING } from 'src/app/models/data';

@Injectable({
  providedIn: 'root'
})
export class AnimalStatisticsService {
	private trackRootQueryUrl = TRACKS_QUERY_STRING + '?query=query{spoorIdentification';
	private userRootQueryUrl = ROOT_QUERY_STRING + '?query=query{users';
	private loginsRootQueryUrl = ROOT_QUERY_STRING + '?query=query{recentLogins';
	
	//animal Login statistics variables
	//Store a local copy of all animal logins
	private animalLoginsStore: { animalLogins: any[] } = { animalLogins: null };
	private _animalLogins = new BehaviorSubject<any[]>([]);
	readonly animalLogins = this._animalLogins.asObservable();
	
	private defaultNumRecentLogins = 50;	
	private recentLoginsSource = new BehaviorSubject<any[]>([]);
	recentLogins$ = this.recentLoginsSource.asObservable();
	
	private loginsByApplicationSource = new Subject<any[]>();
	loginsByApplication$ = this.loginsByApplicationSource.asObservable();	
	
	private loginsByDateSource = new Subject<any[]>();
	loginsByDate$ = this.loginsByDateSource.asObservable();	
	
	private loginsByLevelSource = new Subject<any[]>();
	loginsByLevel$ = this.loginsByLevelSource.asObservable();
	
	//Tracking Activity Overview Variables
	private _displayedTracks = new BehaviorSubject<any[]>([]);
	readonly displayedTracks = this._displayedTracks.asObservable();
	//Store a local copy of all track identifications
	private trackIdentificationsStore: { trackIdentifications: Track[] } = { trackIdentifications: null };
	
	private allIdentificationsByDateSource = new Subject<any[]>();
	allIdentificationsByDate$ = this.allIdentificationsByDateSource.asObservable();
	private allTimeNumAndScoreIdsSource = new Subject<any[]>();
	allTimeNumAndScoreIds$ = this.allTimeNumAndScoreIdsSource.asObservable();	
	private allIdentificationsByLevelSource = new Subject<any[]>();		
	allIdentificationsByLevel$ = this.allIdentificationsByLevelSource.asObservable();		
	private mostIdentifiedSource = new Subject<any[]>();
	mostIdentified$ = this.mostIdentifiedSource.asObservable();	
	
	//Tracking Activity By animal Variables
	//Store a local copy of all track identifications
	private animalsStore: { animals: User[] } = { animals: null };
	private allIdsByanimalAndDateSource = new Subject<any[]>();
	allIdsanimalAndDate$ = this.allIdsByanimalAndDateSource.asObservable();
	
	constructor(private http: HttpClient, private messageService: MessageService) { }
	
	get logins() {
		return this._animalLogins.asObservable();
	}
	get identifications() {
		return this._displayedTracks.asObservable();
	}
	
		
	//Login Activity functions
	getAnimalLoginActivity(token: string)
	{
			/*
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
		*/
	}
	getLoginsByDate(startDate: any, endDate: any, dataType: string) {
		/*
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
		
		this.loginsByDateSource.next(logins);*/
	}
	getRecentLogins(numLogins: number) {
	/*
		var allRangerLogins = cloneDeep(this.rangerLoginsStore.rangerLogins);
		allRangerLogins.reverse();
		var maxNumLogins = allRangerLogins.length;
		
		if (numLogins < maxNumLogins) {
			maxNumLogins = numLogins;
		}
		this.recentLoginsSource.next(allRangerLogins.slice(0, maxNumLogins));
		*/
	}
	calculateLoginsByApplication() {
			/*
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
		*/
	}
	calculateLoginsByLevel() {
			/*
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
		*/
	}
	
	//Tracking Activity Overview Statistics
	//HTTPS Requests
	getAllTrackingActivity(token: string)
	{
		/*
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
				
				var startDate = new Date();
				startDate.setDate(startDate.getDate() - 7);
				this.getAllIdentificationsByDate(startDate, new Date(), "identifications");
				this.getAllTimeIdsNumAndScore();
				this.getAllIdentificationsByLevel();
				this.getMostIdsByRanger();
				this._displayedTracks.next(Object.assign({}, this.trackIdentificationsStore).trackIdentifications);
			},
				error => {
					this._displayedTracks.next([]);
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);
			*/
	}	
	getAllIdentificationsByDate(startDate: any, endDate: any, dataType: string) {
		/*
		var allTrackIdentifications = cloneDeep(this.trackIdentificationsStore.trackIdentifications);
		
		//Filter out identifications that do not fall within the time range
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
		
		//Count number of Identifications on a specific date per platform or level
		var graphData = [];
		
		switch(dataType) {
			case "identifications":
				graphData = this.getNumIdentificationsByDate(filteredIds, endDateTime, numDays);
			break;
			case "accuracy score":
				graphData = this.getAvgAccuracyScoreByDate(filteredIds, endDateTime, numDays);
			break;
		}			

		this.allIdentificationsByDateSource.next(graphData);	
		*/		
	}
	getNumIdentificationsByDate(trackList: Track[], endDateTime: any, numDays: number) {
	/*
		var fromDate = new Date(endDateTime);
		var graphData = [];
		var levelOneSeries = [];
		var levelTwoSeries = [];
		var levelThreeSeries = [];
		var levelOneNumIds = 0;
		var levelTwoNumIds = 0;
		var levelThreeNumIds = 0;
				
		for (let i = 0; i < numDays; i++) {
			levelOneNumIds = 0;
			levelTwoNumIds = 0;
			levelThreeNumIds = 0;
			fromDate = new Date(endDateTime);
			fromDate.setDate(fromDate.getDate() - i);
							
			trackList.forEach(track => {
				if (this.isSameDay(track.dateObj, fromDate)) {
					switch(track.ranger.accessLevel) {
						case "1":
							levelOneNumIds++;
						break;
						case "2":
							levelTwoNumIds++;
						break;
						case "3":
							levelThreeNumIds++;
						break;
						case "4":
							levelThreeNumIds++;
						break;
					}
				}
			});
			levelOneSeries.push({"value": levelOneNumIds, "name": fromDate});
			levelTwoSeries.push({"value": levelTwoNumIds, "name": fromDate});
			levelThreeSeries.push({"value": levelThreeNumIds, "name": fromDate});
		}
		graphData.push({"name":"Level 1 Rangers", "series": levelOneSeries.reverse()}, 
			{"name":"Level 2 Rangers", "series": levelTwoSeries.reverse()}, 
			{"name":"Level 3 Rangers", "series": levelThreeSeries.reverse()}
		);
		return graphData;
		*/
	}
	getAvgAccuracyScoreByDate(trackList: Track[], endDateTime: any, numDays: number) {
		/*
		var fromDate = new Date(endDateTime);
		var graphData = [];
		var avgScorePerDay = [];
		var avgScorePerDayLevelOne = [];
		var avgScorePerDayLevelTwo = [];
		var avgScorePerDayLevelThree = [];
		var tracksPerDay = [];
		var tracksPerDayLevelOne = [];
		var tracksPerDayLevelTwo = [];
		var tracksPerDayLevelThree = [];
		var avgScore = 0;
		var avgScoreLevelOne = 0;
		var avgScoreLevelTwo = 0;
		var avgScoreLevelThree = 0;
				
		for (let i = 0; i < numDays; i++) {
			avgScore = 0;
			avgScoreLevelOne = 0;
			avgScoreLevelTwo = 0;
			avgScoreLevelThree = 0;
			tracksPerDay = [];
			tracksPerDayLevelOne = [];
			tracksPerDayLevelTwo = [];
			tracksPerDayLevelThree = [];
			fromDate = new Date(endDateTime);
			fromDate.setDate(fromDate.getDate() - i);
					
			trackList.forEach(track => {
				if (this.isSameDay(track.dateObj, fromDate))  {
					tracksPerDay.push(track);
					switch(track.ranger.accessLevel) {
						case "1":
							tracksPerDayLevelOne.push(track);
						break;
						case "2":
							tracksPerDayLevelTwo.push(track);
						break;
						case "3":
							tracksPerDayLevelThree.push(track);
						break;
						case "4":
							tracksPerDayLevelThree.push(track);
						break;
					}
				}
			});
			avgScore = this.getAvgAccuracyScore(tracksPerDay);
			avgScoreLevelOne = this.getAvgAccuracyScore(tracksPerDayLevelOne);
			avgScoreLevelTwo = this.getAvgAccuracyScore(tracksPerDayLevelTwo);
			avgScoreLevelThree = this.getAvgAccuracyScore(tracksPerDayLevelThree);
					
			avgScorePerDay.push({"value": avgScore, "name": fromDate});
			avgScorePerDayLevelOne.push({"value": avgScoreLevelOne, "name": fromDate});
			avgScorePerDayLevelTwo.push({"value": avgScoreLevelTwo, "name": fromDate});
			avgScorePerDayLevelThree.push({"value": avgScoreLevelThree, "name": fromDate});
		}
		graphData.push({"name":"Avg. Accuracy Score", "series": avgScorePerDay.reverse()},
			{"name":"Level 1 Ranger Accuracy Score", "series": avgScorePerDayLevelOne.reverse()},
			{"name":"Level 2 Ranger Accuracy Score", "series": avgScorePerDayLevelTwo.reverse()},
			{"name":"Level 3 Ranger Accuracy Score", "series": avgScorePerDayLevelThree.reverse()}
		);
		return graphData;*/
	}
	getAllIdentificationsByLevel() {
	/*
		var allTrackIdentifications = cloneDeep(this.trackIdentificationsStore.trackIdentifications);
		var levelOneIds = 0;
		var levelTwoIds = 0;
		var levelThreeIds = 0;
		allTrackIdentifications.forEach(track => {
			if (track.ranger.accessLevel == "1") {
				levelOneIds++;
			}
			else if (track.ranger.accessLevel == "2") {
				levelTwoIds++;
			}
			else if (track.ranger.accessLevel == "3" || track.ranger.accessLevel == "4") {
				levelThreeIds++;
			}
		});
		var numIds = [
			{"name": "Level 1", "value": levelOneIds}, 
			{"name": "Level 2", "value": levelTwoIds},
			{"name": "Level 3", "value": levelThreeIds}
		];
		this.allIdentificationsByLevelSource.next(numIds);	
		*/		
	}
	getAllTimeIdsNumAndScore() {
	/*
		var allTrackIdentifications = cloneDeep(this.trackIdentificationsStore.trackIdentifications);
		var numAndScoreData = [];
		var avgScore = this.getAvgAccuracyScore(allTrackIdentifications);
		
		numAndScoreData.push({"name": "Total Identifications", "value": allTrackIdentifications.length });
		numAndScoreData.push({"name": "Accuracy Score", "value": avgScore});
				
		this.allTimeNumAndScoreIdsSource.next(numAndScoreData);
		*/
	}

	//Tracking Activity By animal Statistics
	//HTTPS Requests
	getAllTrackingActivityByanimal(token: string) {
				/*
		const getRangersQueryUrl = this.userRootQueryUrl + '(tokenIn:"' + token + '"){rangerID,accessLevel,firstName,lastName}}';
		this.http.get<User[]>(getRangersQueryUrl)
			.subscribe( data => {
				this.rangersStore.rangers = Object.values(Object.values(data)[0])[0];	
				var startDate = new Date();
				startDate.setDate(startDate.getDate() - 7);
				this.getAllIdsByRangerAndDate(startDate, new Date(), "identifications");
			},
				error => {
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);
			*/
	}
	getMostIdsByanimal() {
		/*const getMostQueryUrl = this.trackRootQueryUrl + '(token:"' + token + '"){spoorIdentificationID,animal{classification,animalID,groupID{groupName},' +
			'commonName,pictures{picturesID,URL,kindOfPicture},animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},' +
			'animal{animalID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},' +
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
			/*
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
			this.mostIdentifiedSource.next([{"name": mostTracked.mosotTrakedRanger.firstName + " " + mostTracked.mosotTrakedRanger.lastName,
				"value": mostTracked.AnimalTracked }]);
		  });
		  */
	}
	getAllIdsByanimalAndDate(startDate: any, endDate: any, dataType: string) {
	/*
		var allRangers = cloneDeep(this.rangersStore.rangers);
		var allTrackIdentifications = cloneDeep(this.trackIdentificationsStore.trackIdentifications);
		
		//Filter out identifications that do not fall within the time range
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
		
		//Compare data with global average score and num of identifications
		var globalData;
		switch(dataType) {
			case "identifications":
				globalData = this.getNumIdentificationsByDate(filteredIds, endDateTime, numDays);
			break;
			case "accuracy score":
				globalData = this.getAvgAccuracyScoreByDate(filteredIds, endDateTime, numDays);
			break;
		}				
		
		var graphData = [];
		var rangerData = [];
		
		allRangers.forEach(ranger => {
			rangerData = this.getIdsByRangerAndDate(ranger, filteredIds, endDateTime, numDays, dataType);
			rangerData = rangerData.concat(globalData);
			graphData.push({ranger: ranger, rangerGraphData: rangerData});
		});
		this.allIdsByRangerAndDateSource.next(graphData);	
		*/
	}
	getIdsByanimalAndDate(animal: User, trackList: Track[], endDateTime: any, numDays: number, dataType: string) {
/*
		//Count number of Identifications on a specific date per platform or level
		var fromDate = new Date(endDateTime);
		var rangerData = [];
		
		switch(dataType) {
			case "identifications":
				var rangerSeries = [];
				var numIds = 0;
				
				for (let i = 0; i < numDays; i++) {
					numIds = 0;
					fromDate = new Date(endDateTime);
					fromDate.setDate(fromDate.getDate() - i);
							
					trackList.forEach(track => {
						if (this.isSameDay(track.dateObj, fromDate)) {
							if (track.ranger.rangerID == ranger.rangerID) {
								numIds++;
							}
						}
					});
					rangerSeries.push({"value": numIds, "name": fromDate});
				}
				rangerData.push({"name": ranger.firstName + " " + ranger.lastName, "series": rangerSeries.reverse()});
			break;
			case "accuracy score":
				var avgScorePerDay = [];
				var tracksPerDay = [];
				var avgScore = 0;
				
				for (let i = 0; i < numDays; i++) {
					avgScore = 0;
					tracksPerDay = [];
					fromDate = new Date(endDateTime);
					fromDate.setDate(fromDate.getDate() - i);
					
					trackList.forEach(track => {
						if (this.isSameDay(track.dateObj, fromDate))  {
							if (track.ranger.rangerID == ranger.rangerID) {
								tracksPerDay.push(track);
							}
						}
					});
					avgScore = this.getAvgAccuracyScore(tracksPerDay);
					avgScorePerDay.push({"value": avgScore, "name": fromDate});
				}
				rangerData.push({"name": ranger.firstName + " " + ranger.lastName, "series": avgScorePerDay.reverse()});
			break;
		}				
		
		return rangerData;
		*/
	}
	
	//Other Functions
	isSameDay(date1: any, date2: any) {
		var isSameDay = false;
		if (date1.getDate() === date2.getDate() && date1.getMonth() === date2.getMonth() && date1.getFullYear() === date2.getFullYear())
			isSameDay = true;
		return isSameDay;
	}
	getAvgAccuracyScore(trackList: any[]) {
		var allTrackIdentifications = cloneDeep(trackList);
		var accuracyScore = 0;
		
		allTrackIdentifications.forEach(track => {
			accuracyScore += track.potentialMatches[track.potentialMatches.length - 1].confidence;
		});
		var avgScore = 0;
		if (accuracyScore != 0)
			avgScore =  Math.round(((accuracyScore/allTrackIdentifications.length) * 100));

		return avgScore;
	}

	private handleError<T>(operation = 'operation', result?: T) 
	{
		return (error: any): Observable<T> => {

			console.error(error);

			this.log(`${operation} failed: ${error.message}`, true);

			return of(result as T);
		};
	}

	private log(message: string, dismissible: boolean) 
	{
		this.messageService.show(`${message}`, dismissible);
	}
}
