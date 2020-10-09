import { Injectable } from '@angular/core';
import { clone, cloneDeep } from "lodash";
import { BehaviorSubject, Observable, of, Subject } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { MessageService } from './message.service';
import { Track } from 'src/app/models/track';
import { TRACKS_QUERY_STRING } from 'src/app/models/data';

/*
import { catchError, map, tap } from 'rxjs/operators';
*/

@Injectable({
  providedIn: 'root'
})
export class TracksService {
		private activeTrackSource = new BehaviorSubject<Track>(null);
	activeTrack$ = this.activeTrackSource.asObservable();
	
	private trackRootQueryUrl = TRACKS_QUERY_STRING + '?query=query{spoorIdentification';
	private reclassifyRootQueryUrl = TRACKS_QUERY_STRING + '?query=mutation{updateIdentification';
	private _displayedTracks = new BehaviorSubject<Track[]>([]);
	readonly displayedTracks = this._displayedTracks.asObservable();
	//Store a local copy of all track identifications
	private trackIdentificationsStore: { trackIdentifications: Track[] } = { trackIdentifications: null };
	
	//Determines which filter option is currently selected
	private trackFilterSource = new Subject<string[]>();
	trackFilter$ = this.trackFilterSource.asObservable();
	
	dummyLocations: any = [
		{//Red Hartebeest
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.988384, 
				longitude: 31.545741
			}
		},		
		{//Zebra
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.388384, 
				longitude: 31.545741
			}
		},
		{//Red Hartebeest
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.788384, 
				longitude: 31.645741
			}
		},		
		{//Buffalo
			dateObj: new Date("10/05/2020"),
			location: {
				latitude: -24.288384, 
				longitude: 31.550741
			}
		},		
		{//Zebra
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.088384, 
				longitude: 31.545741
			}
		},		
		{//Zebra
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.188384, 
				longitude: 31.445741
			}
		},		
		{//Hippo
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.088384, 
				longitude: 31.545741
			}
		},		
		{//Black Wildebeest
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.088384, 
				longitude: 31.545741
			}
		},		
		{//Buffalo
			dateObj: new Date("10/01/2020"),
			location: {
				latitude: -24.286384, 
				longitude: 31.544741
			}
		},		
		{//Black Backed Jackal
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.088384, 
				longitude: 31.545741
			}
		},		
		{//Black Backed Jacakl
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.088384, 
				longitude: 31.545741
			}
		},		
		{//Waterbuck
			dateObj: new Date("10/06/2020"),
			location: {
				latitude: -24.088384, 
				longitude: 31.545741
			}
		},		
		{//Buffalo
			dateObj: new Date("10/19/2019"),
			location: {
				latitude: -24.290384, 
				longitude: 31.540741
			}
		},		
		{//Buffalo
			dateObj: new Date("04/26/2020"),
			location: {
				latitude: -24.284384, 
				longitude: 31.536741
			}
		},		
		{//Buffalo
			dateObj: new Date("09/20/2020"),
			location: {
				latitude: -24.292384, 
				longitude: 31.532741
			}
		}
	];
	
	constructor(private http: HttpClient, private messageService: MessageService) { }
	
	get identifications() {
		return this._displayedTracks.asObservable();
	}
	
	changeActiveTrack(track: Track) {
		this.activeTrackSource.next(track);
	}
	
	changeTrackFilter(filterCategory: string, filterChoice: string) {
		//Make a copy of all the tracks to filter through
		var allTracks = cloneDeep(this.trackIdentificationsStore.trackIdentifications);
		var filteredTracks = [];
		if (filterChoice == "All") {
			this._displayedTracks.next(allTracks);
			this.trackFilterSource.next([filterCategory, filterChoice]);
			return;
		}
		
		for (let i = 0; i < allTracks.length; i++) {
			let groupName = false;
			if (filterCategory == "Group") {
				for (let j = 0; j < (allTracks[i]['animal']['groupID']).length; j++) {
					if (('' + ((allTracks[i]['animal']['groupID'])[j])['groupName'] == (filterChoice)) && filterChoice != '') {
						groupName = true;
					}
				}
			}
			if (filterChoice == '' || ('' + allTracks[i]['animal']['commonName']) == (filterChoice) || groupName ||
				(allTracks[i]['ranger']['firstName'] + ' ' + allTracks[i]['ranger']['lastName']) == (filterChoice)) {
					filteredTracks.push(allTracks[i]);
			}
		}
		this._displayedTracks.next(filteredTracks);
		this.trackFilterSource.next([filterCategory, filterChoice]);
	}
		
	//HTTPS Requests
	getTrackIdentifications(token: string, initParams: any)
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
				//DUMMY LOCATIONS TO SET MARKERS WITHIN KRUGER PARK
				/*for (let i = 0; i < this.dummyLocations.length; i++) {
					this.trackIdentificationsStore.trackIdentifications[i].location = this.dummyLocations[i].location;
					this.trackIdentificationsStore.trackIdentifications[i].dateObj = this.dummyLocations[i].dateObj;
					this.trackIdentificationsStore.trackIdentifications[i].recency = this.dummyLocations[i].dateObj.toISOString();
				}*/
				this._displayedTracks.next(Object.assign({}, this.trackIdentificationsStore).trackIdentifications);
				if (initParams.initWithFilter)
					this.changeTrackFilter(initParams.filterType, initParams.filter);
			},
				error => {
					this._displayedTracks.next([]);
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);
	}
	
	reclassifyTrack(token: any, track: any, newAnimal: any) {
		//var tags = ["Track", "Found near riverbed"];
		//console.log(tags.toString());
		const reclassifyTrackQueryUrl = this.reclassifyRootQueryUrl + '(token:"' + token + '", latitude:' + encodeURIComponent(track.location.latitude) + ', longitude:' + 
		encodeURIComponent(track.location.longitude) + ', spoorIdentificationID:"' + encodeURIComponent(track.spoorIdentificationID) + '", tags:"' + encodeURIComponent(track.tags.toString()) + 
		'"){spoorIdentificationID}}';
		this.http.post<Track[]>(reclassifyTrackQueryUrl, '')
			.subscribe( data => {
				//console.log("if data was returned it was:");
				//console.log(data);
			},
				error => {
					//this._displayedTracks.next([]);
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);
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