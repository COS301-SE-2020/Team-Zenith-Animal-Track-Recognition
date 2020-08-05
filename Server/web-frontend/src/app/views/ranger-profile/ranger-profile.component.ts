import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import {MatTabsModule} from '@angular/material/tabs'; 
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
  selector: 'app-ranger-profile',
  templateUrl: './ranger-profile.component.html',
  styleUrls: ['./ranger-profile.component.css']
})
export class RangerProfileComponent implements OnInit {

	user: any;
	userToken: string;
	constructor(private http: HttpClient, private router: Router, private activatedRoute: ActivatedRoute, public dialog: MatDialog) { }

	ngOnInit(): void {
		document.getElementById('rangers-route').classList.add('activeRoute');
		//Determine which user was navigated to and fetch their information
		this.userToken = this.activatedRoute.snapshot.paramMap.get("user");
		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{users(tokenIn:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
			'", tokenSearch:"' + this.userToken + '"){token,accessLevel,eMail,firstName,lastName,phoneNumber}}')
			.subscribe((data: any[]) => {
				let temp = [];
				temp = Object.values(Object.values(data)[0]);
				this.user = temp[0][0];
			});
	}

	route(temp: string) {
		this.router.navigate([temp]);
	}

}
