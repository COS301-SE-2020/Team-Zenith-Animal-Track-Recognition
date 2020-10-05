import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { logging } from 'protractor';
import { User } from './../models/user';
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, EMPTY, Observable } from 'rxjs';
import { catchError, map, retry } from 'rxjs/operators';
import { MatSnackBar } from '@angular/material/snack-bar';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private currentUserSubject: BehaviorSubject<User>;
  public currentUser: Observable<User>;
  private isAuthorized = false;

  constructor(private http: HttpClient, private snackBar: MatSnackBar) {
    this.currentUserSubject = new BehaviorSubject<User>(JSON.parse(localStorage.getItem('currentToken')));
    this.currentUser = this.currentUserSubject.asObservable();
  }

  public get currentUserValue(): User {
    return this.currentUserSubject.value;
  }

  isAuthenticated() {
    if (localStorage.getItem("currentToken") != null) {
      const item = JSON.parse(localStorage.getItem("currentToken"));
      const now = new Date();

      if (now.getTime() > item.expiry) {
        localStorage.clear();
      } else {
        this.isAuthorized = true;
      }
    }
    return this.isAuthorized;
  }

  login(username, password) {
    console.log(username);
    console.log(password);
    
    return this.http.get<any>(ROOT_QUERY_STRING + '?query=query{wdbLogin(eMail:"' + username + '",password:"' + password + '"){token, firstName, lastName, rangerID, accessLevel}}')
      .pipe(map(user => {
        if (null === user.data.wdbLogin) {
          this.isAuthorized = false;
          return null;
        }

        const now = new Date();

        const tkn = {
          value: user.data.wdbLogin.token,
          expiry: now.getTime() + 7200000,
          firstName: user.data.wdbLogin.firstName,
          currentID: user.data.wdbLogin.rangerID,
          level: user.data.wdbLogin.accessLevel
        };

        localStorage.setItem('currentToken', JSON.stringify(tkn));
        this.currentUserSubject.next(user);
        this.isAuthorized = true;

        return user;
      })).pipe(
        retry(3),
        catchError(() => {
          this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
          return EMPTY;
        })
      );
  }

  logout() {
    localStorage.removeItem('currentToken');
    document.location.href = '/';
    this.currentUserSubject.next(null);
  }
}
