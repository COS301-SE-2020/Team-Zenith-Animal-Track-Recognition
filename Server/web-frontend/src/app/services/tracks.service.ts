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
	
	private _: any;
	private activeTrackSource = new BehaviorSubject<Track>(null);
	activeTrack$ = this.activeTrackSource.asObservable();
	
	private trackRootQueryUrl = TRACKS_QUERY_STRING + '?query=query{spoorIdentification';
	private _displayedTracks = new BehaviorSubject<Track[]>([]);
	readonly displayedTracks = this._displayedTracks.asObservable();
	//Store a local copy of all track identifications
	private trackIdentificationsStore: { trackIdentifications: Track[] } = { trackIdentifications: null };
	
	//Determines which filter option is currently selected
	private trackFilterSource = new Subject<string>();
	trackFilter$ = this.trackFilterSource.asObservable();
	
	dummyLocations: any = [
		{
			location: {
				latitude: -23.988384, 
				longitude: 31.554741
			}
		},		
		{
			location: {
				latitude: -23.939820, 
				longitude: 31.704810
			}
		},		
		{
			location: {
				latitude: -23.801680, 
				longitude: 31.491808
			}
		},		
		{
			location: {
				latitude: -23.732555,
				longitude: 31.869679
			}
		},		
		{
			location: {
				latitude: -24.042702, 
				longitude: 31.784478
			}
		},		
		{
			location: {
				latitude: -24.082828, 
				longitude: 31.502766
			}
		},		
		{
			location: {
				latitude: -24.021379, 
				longitude: 31.637438
			}
		},		
		{
			location: {
				latitude: -24.086589, 
				longitude: 31.587966
			}
		},		
		{
			location: {
				latitude: -24.196869, 
				longitude: 31.306254
			}
		},		
		{
			location: {
				latitude: -24.215657, 
				longitude: 31.517934
			}
		},		
		{
			location: {
				latitude: -23.908438, 
				longitude: 31.834002
			}
		},		
		{
			location: {
				latitude: -23.920992, 
				longitude: 31.739187
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
			this.trackFilterSource.next(filterChoice);
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
		this.trackFilterSource.next(filterChoice);
	}
		
	//HTTPS Requests
	getTrackIdentifications(token: string)
	{
		const getIdentificationsQueryUrl = this.trackRootQueryUrl + '(token:"' + token + '"){spoorIdentificationID,animal{classification,animalID,groupID{groupName},' +
			'commonName,pictures{picturesID,URL,kindOfPicture},animalMarkerColor},dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},' +
			'ranger{rangerID,accessLevel,firstName,lastName},potentialMatches{animal{classification,animalID,commonName,pictures{picturesID,URL,kindOfPicture}},' +
			'confidence},picture{picturesID,URL,kindOfPicture}}}';
		this.http.get<Track[]>(getIdentificationsQueryUrl)
			.subscribe( data => {
				this.trackIdentificationsStore.trackIdentifications = Object.values(Object.values(data)[0])[0];	
				this.trackIdentificationsStore.trackIdentifications.forEach(element => {
					let temp = element.dateAndTime;
					temp.month = temp.month < 10 ? '0' + temp.month : temp.month;
					temp.day = temp.day < 10 ? '0' + temp.day : temp.day;
					temp.hour = temp.hour < 10 ? '0' + temp.hour : temp.hour;
					temp.min = temp.min < 10 ? '0' + temp.min : temp.min;
					temp.second = temp.second < 10 ? '0' + temp.second : temp.second;
					const str: string = temp.year + "-" + temp.month + "-" + temp.day + "T" + temp.hour + ":" + temp.min + ":" + temp.second + ".000Z";
					element.recency = str;
					let t: number = parseInt(temp.month) - 1;
					element.dateObj = new Date(temp.year, t, temp.day, temp.hour, temp.min, temp.second);
				});
				//DUMMY LOCATIONS TO SET MARKERS WITHIN KRUGER PARK
				for (let i = 0; i < this.dummyLocations.length; i++) {
					this.trackIdentificationsStore.trackIdentifications[i].location = this.dummyLocations[i].location;
				}
				this._displayedTracks.next(Object.assign({}, this.trackIdentificationsStore).trackIdentifications);
			},
				error => {
					this._displayedTracks.next([]);
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