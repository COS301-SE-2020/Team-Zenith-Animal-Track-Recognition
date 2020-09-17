import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { EMPTY } from 'rxjs';
import { retry, catchError } from 'rxjs/operators';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
  selector: 'app-overview',
  templateUrl: './overview.component.html',
  styleUrls: ['./overview.component.css']
})
export class OverviewComponent implements OnInit {
  logins: any;
  rangers: any;

  constructor(private http: HttpClient, private snackBar: MatSnackBar) { }

  ngOnInit(): void {
    document.getElementById("overview-route").classList.add("activeRoute");

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
        this.logins = temp[0];
        console.log(temp[0]);
      });
  }

  stopLoader() {
    throw new Error('Method not implemented.');
  }

  stopSidenavLoader() {
    throw new Error('Method not implemented.');
  }

}
