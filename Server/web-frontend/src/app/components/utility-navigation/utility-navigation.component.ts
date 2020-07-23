import { User } from './../../models/user';
import { AuthService } from './../../services/auth.service';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-utility-navigation',
  templateUrl: './utility-navigation.component.html',
  styleUrls: ['./utility-navigation.component.css']
})
export class UtilityNavigationComponent implements OnInit {
  currentUser: User;
  username;

  constructor(
    private router: Router,
    private authService: AuthService
  ) {
    this.authService.currentUser.subscribe(x => this.currentUser = x);
  }

  ngOnInit(): void 
  {
	  //Show logged in user
	  this.username = localStorage.getItem("localStorageUsername");
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/login']);
  }
}
