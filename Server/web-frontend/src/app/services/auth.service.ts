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
    return this.isAuthorized;
  }

  login(username, password) {
    // this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{login(User_Name:"' + username + '",Password:"' + password + '"){Token}}')
    // .subscribe(response => console.log(response.data));
    return this.http.get<any>('http://putch.dyndns.org:55555/graphql?query=query{login(User_Name:"' + username + '",Password:"' + password + '"){Token}}')
      .pipe(map(user => {
        if (null === user.data.login) {
          return null;
        }
        localStorage.setItem('currentUser', JSON.stringify(user));
        this.currentUserSubject.next(user);
        this.isAuthorized = true;

        return user;
      }));
  }

  logout() {
    localStorage.removeItem('currentUser');
    this.isAuthorized = false;
    this.currentUserSubject.next(null);
  }
}
