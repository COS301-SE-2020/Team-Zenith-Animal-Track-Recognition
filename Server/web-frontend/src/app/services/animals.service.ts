import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, of, Subject } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { MessageService } from './message.service';
import { Track } from 'src/app/models/track';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { TRACKS_QUERY_STRING } from 'src/app/models/data';

@Injectable({
  providedIn: 'root'
})
export class AnimalsService {

	private activeTrackSource = new BehaviorSubject<Track>(null);
	activeTrack$ = this.activeTrackSource.asObservable();
	
	private trackRootQueryUrl = TRACKS_QUERY_STRING + '?query=query{spoorIdentification';
	private _similarTracks = new BehaviorSubject<Track[]>([]);
	readonly similarTracks = this._similarTracks.asObservable();
	//Store a local copy of all track identifications
	//private trackIdentificationsStore: { trackIdentifications: Track[] } = { trackIdentifications: null };
	
	constructor(private http: HttpClient, private messageService: MessageService) { }
	
	get identifications() {
		return this._similarTracks.asObservable();
	}
	
	changeActiveTrack(track: Track) {
		this.activeTrackSource.next(track);
	}
	
	//HTTPS Requests
	/*getTrackIdentifications(token: string)
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
	}*/

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
