import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { EMPTY } from 'rxjs';
import { retry, catchError } from 'rxjs/operators';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import * as CanvasJS from './canvasjs.min';

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

  constructor(private http: HttpClient, private snackBar: MatSnackBar) { }

  ngOnInit(): void {
    document.getElementById("overview-route").classList.add("activeRoute");
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

    this.http.get<any>(ROOT_QUERY_STRING + '?query=query{recentLogins(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
      '"){rangerID{firstName,lastName,accessLevel},time,platform}}')
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
        temp[0] = temp[0].reverse();
        this.logins = [];
        if (temp[0].length > 5) {
          for (let i = 0; i < 5; i++) {
            this.logins.push(temp[0][i]);
          }
        } else {
          this.logins = temp[0];
        }
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
  }

  startLoader() {
    document.getElementById('loader-container').style.visibility = 'visible';
  }
  stopLoader() {
    document.getElementById('loader-container').style.visibility = 'hidden';
  }
  stopSidenavLoader() {
    throw new Error('Method not implemented.');
  }
  timeToString(element) {
    let temp = element.dateAndTime;
    temp.month = temp.month < 10 ? '0' + temp.month : temp.month;
    temp.day = temp.day < 10 ? '0' + temp.day : temp.day;
    temp.hour = temp.hour < 10 ? '0' + temp.hour : temp.hour;
    temp.min = temp.min < 10 ? '0' + temp.min : temp.min;
    temp.second = temp.second < 10 ? '0' + temp.second : temp.second;
    const str: string = temp.year + "-" + temp.month + "-" + temp.day + "T" + temp.hour + ":" + temp.min + ":" + temp.second + ".000Z";
    element.timeAsString = str;
    element.dateObj = new Date(temp.year, temp.month, temp.day, temp.hour, temp.min, temp.second);

    return temp;
  }
}
