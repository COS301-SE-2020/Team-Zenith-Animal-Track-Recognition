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
    this.currentUserSubject = new BehaviorSubject<User>(JSON.parse(localStorage.getItem('currentUser')));
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
    return this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{login(User_Name:"' + username + '",Password:"' + password + '"){Token}}')
      .pipe(map(user => {
        if (null === user.data.login) {
          return null;
        }

        const now = new Date();
        const tkn = {
          value: user.data.login.Token,
          expiry: now.getTime() + 3600000
        }

        localStorage.setItem('currentToken', JSON.stringify(tkn));
        this.currentUserSubject.next(user);
        this.isAuthorized = true;

        return user;
      }));
  }

  logout() {
    localStorage.removeItem('currentToken');
    this.currentUserSubject.next(null);
  }
}
