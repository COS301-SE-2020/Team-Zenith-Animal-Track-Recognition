import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { logging } from 'protractor';
import { User } from './../models/user';
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private currentUserSubject: BehaviorSubject<User>;
  public currentUser: Observable<User>;
  private isAuthorized = false;

  constructor(private http: HttpClient) {
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
    return this.http.get<any>(ROOT_QUERY_STRING + '?query=query{DASlogin(e_mail:"' + username + '",Password:"' + password + '"){Token, firstName, lastName}}')
      .pipe(map(user => {
        if (null === user.data.DASlogin) {
          this.isAuthorized = false;
          return null;
        }

        const now = new Date();
        const tkn = {
          value: user.data.DASlogin.Token,
          expiry: now.getTime() + 3600000,
          fullName: user.data.DASlogin.firstName + ' ' + user.data.DASlogin.lastName
        }

        localStorage.setItem('currentToken', JSON.stringify(tkn));
        this.currentUserSubject.next(user);
        this.isAuthorized = true;
		
		//Save last name to use for Profile name
		localStorage.setItem('userLastName', user.data.DASlogin.lastName);

        return user;
      }));
  }

  logout() {
    localStorage.removeItem('currentToken');
    this.currentUserSubject.next(null);
  }
}
