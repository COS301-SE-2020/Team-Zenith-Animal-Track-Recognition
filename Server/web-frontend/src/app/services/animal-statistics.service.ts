import { Injectable } from '@angular/core';
import { clone, cloneDeep } from "lodash";
import { BehaviorSubject, Observable, of, Subject, EMPTY } from 'rxjs';
import { catchError, map, retry } from 'rxjs/operators';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { MessageService } from './message.service';
import { User } from 'src/app/models/user';
import { Animal } from 'src/app/models/animal';
import { Track } from 'src/app/models/track';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { TRACKS_QUERY_STRING } from 'src/app/models/data';

@Injectable({
  providedIn: 'root'
})
export class AnimalStatisticsService {
	private trackRootQueryUrl = TRACKS_QUERY_STRING + '?query=query{spoorIdentification';
	private animalsRootQueryUrl = ROOT_QUERY_STRING + '?query=query{animals';
	private loginsRootQueryUrl = ROOT_QUERY_STRING + '?query=query{recentLogins';
	
	//Animals
	private animalsStore: { animals: any[] } = { animals: null };
	private _animals = new BehaviorSubject<Animal[]>([]);
	readonly animals = this._animals.asObservable();	
	private numAnimalsSource = new Subject<any[]>();
	numAnimals$ = this.numAnimalsSource.asObservable();	
	private mostTrackedAnimalSource = new Subject<any>();
	mostTrackedAnimal$ = this.mostTrackedAnimalSource.asObservable();	
	private leastTrackedAnimalSource = new Subject<any>();
	leastTrackedAnimal$ = this.leastTrackedAnimalSource.asObservable();
	private numIdsByAnimalSource = new Subject<any[]>();
	numIdsByAnimal$ = this.numIdsByAnimalSource.asObservable();
	
	//Track Identifications
	//Tracking Activity Overview Variables
	private _displayedTracks = new BehaviorSubject<any[]>([]);
	readonly displayedTracks = this._displayedTracks.asObservable();
	//Store a local copy of all track identifications
	private trackIdentificationsStore: { trackIdentifications: Track[] } = { trackIdentifications: null };
	private numIdentificationsSource = new Subject<any[]>();
	numIdentifications$ = this.numIdentificationsSource.asObservable();
	
	/*private loginsByApplicationSource = new Subject<any[]>();
	loginsByApplication$ = this.loginsByApplicationSource.asObservable();	
	
	private loginsByDateSource = new Subject<any[]>();
	loginsByDate$ = this.loginsByDateSource.asObservable();	
	
	private loginsByLevelSource = new Subject<any[]>();
	loginsByLevel$ = this.loginsByLevelSource.asObservable();
	
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
	allIdsanimalAndDate$ = this.allIdsByanimalAndDateSource.asObservable();*/
	
	constructor(private http: HttpClient, private messageService: MessageService) { }
	
	get animalList() {
		return this._animals.asObservable();
	}
	get identifications() {
		return this._displayedTracks.asObservable();
	}
	
		
	//Login Activity functions
	getAllAnimals(token: string) {
		const getAnimalsQueryUrl = this.animalsRootQueryUrl + '(token:"' + token + '"){classification,animalID,commonName,groupID{groupName},heightM,heightF,weightM,weightF,habitats{habitatID},dietType,' +
			'lifeSpan,gestationPeriod,Offspring,typicalBehaviourM{behaviour,threatLevel},typicalBehaviourF{behaviour,threatLevel},animalOverview,animalDescription,pictures{URL}}}';
		this.http.get<Animal[]>(getAnimalsQueryUrl)
			.subscribe( data => {
				this.animalsStore.animals = Object.values(Object.values(data)[0])[0];	
				this._animals.next(Object.assign({}, this.animalsStore).animals);

				
				this.numAnimalsSource.next([{"name": "Animals on system", "value": this.animalsStore.animals.length}]);
			},
				error => {
					this._animals.next([]);
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);
	}
	getAnimalTrackingActivity(token: string)
	{
		this.getAllAnimals(token);
		this.getAllTrackingActivity(token);
	}
	getAllTrackingActivity(token: string)
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
				
				this.numIdentificationsSource.next([{"name": "Total Track Identifications", "value": this.trackIdentificationsStore.trackIdentifications.length}]);
				this.getMostTrackedAnimal(token);
				this.getLeastTrackedAnimal(token);
				this.getAnimalIdBreakdown("identifications");
				this._displayedTracks.next(Object.assign({}, this.trackIdentificationsStore).trackIdentifications);
			},
				error => {
					this._displayedTracks.next([]);
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);
	}	
	getMostTrackedAnimal(token: string) {
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsStats3(token:"' + token +
		  '"){commonName,NumberOfIdentifications}}')
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
				
				let animalName = temp[0].commonName;
				let animal;
				for (let i = 0; i < this.animalsStore.animals.length; i++) {
					if (animalName == this.animalsStore.animals[i].commonName) {
						animal = this.animalsStore.animals[i];
					}
				}
				this.mostTrackedAnimalSource.next({animal: animal, numIds: temp[0].NumberOfIdentifications});
		  });
	}
	getLeastTrackedAnimal(token: string) {
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{animalsStats4(token:"' + token +
		  '"){commonName,NumberOfIdentifications}}')
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
				
				let animalName = temp[0].commonName;
				let animal;
				for (let i = 0; i < this.animalsStore.animals.length; i++) {
					if (animalName == this.animalsStore.animals[i].commonName) {
						animal = this.animalsStore.animals[i];
					}
				}
				this.leastTrackedAnimalSource.next({animal: animal, numIds: temp[0].NumberOfIdentifications});
		  });		
	}
	
	
	
	//Tracking Activity Overview Statistics
	//HTTPS Requests
	getAnimalIdBreakdown(dataType: string) {
		var allTrackIdentifications = cloneDeep(this.trackIdentificationsStore.trackIdentifications);
		var allAnimals = cloneDeep(this.animalsStore.animals);
		
		var graphData = [];
		
		switch(dataType) {
			case "identifications":
				graphData = this.getNumIdsByAnimal(allTrackIdentifications, allAnimals);
			break;
			case "accuracy score":
				//graphData = this.getAvgAccuracyScoreByAnimal(allTrackIdentifications, allAnimals);
			break;
		}			
		console.log("graph data");
		console.log(graphData);

		this.numIdsByAnimalSource.next(graphData);			
	}
	getNumIdsByAnimal(trackList: Track[], animalList: Animal[]) {
		//Count number of Identifications on a specific date per platform or level
		var numIds = 0;
		var graphData = [];
		
		animalList.forEach(animal => {
			let numIds = 0;
			trackList.forEach(track => {
				if (track.animal.animalID == animal.animalID) {
					numIds++;
				}
			});
			if (numIds > 0)
				graphData.push({"name": animal.commonName, "value": numIds});
		});
		
		return graphData;
	}
	getAvgAccuracyScoreByAvg(trackList: Track[], animalList: Animal[]) {
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
