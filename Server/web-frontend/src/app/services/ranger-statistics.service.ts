import { Injectable } from '@angular/core';
import { clone, cloneDeep } from "lodash";
import { BehaviorSubject, Observable, of, Subject } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { MessageService } from './message.service';
import { Track } from 'src/app/models/track';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { TRACKS_QUERY_STRING } from 'src/app/models/data';

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
	
	private loginsByLevelSource = new Subject<any[]>();
	loginsByLevel$ = this.loginsByLevelSource.asObservable();
	
	constructor(private http: HttpClient, private messageService: MessageService) { }
	
	get logins() {
		return this._rangerLogins.asObservable();
	}
	
	changeActiveTrack(track: Track) {
		//this.activeTrackSource.next(track);
	}
	
	changeTrackFilter(filterCategory: string, filterChoice: string) {
		//Make a copy of all the tracks to filter through
		/*
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
		*/
	}
		
	//HTTPS Requests
	getRangerLogins(token: string)
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
				this.getRecentLogins(this.defaultNumRecentLogins);
			},
				error => {
					this._rangerLogins.next([]);
					this.log('An error occurred when connecting to the server. Please refresh and try again.', true)
				}
			);
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
		//this._displayedTracks.next(filteredTracks);
		//this.trackFilterSource.next([filterCategory, filterChoice]);
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
