import { Component, OnInit, ViewChild } from '@angular/core';
import { EMPTY } from 'rxjs';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { Router, ActivatedRoute } from '@angular/router';
import { RangerStatisticsService } from './../../../services/ranger-statistics.service';


@Component({
  selector: 'app-ranger-statistics',
  templateUrl: './ranger-statistics.component.html',
  styleUrls: ['./ranger-statistics.component.css']
})
export class RangerStatisticsComponent implements OnInit {
/*logins: any;
	mostTracked: any;
	rangers: any;
	latest: any;
	animalPercentages: any;
	leastIdentified: any;*/
	@ViewChild('statisticsSidenav') statsSidenav;
	@ViewChild('rangerStatsTab') rangerStatsTab;
	activeRangerStatsTabIndex = 0;
	
	loginsPerApp = [
		{
			"name": "Mobile Tracking",
			"value": 0
		},
		{
			"name": "Web Dashboard",
			"value": 0
		}
	];
	loginsPerLevel = [
		{
			"name": "Level 1 Logins",
			"value": 0
		},
		{
			"name": "Level 2 Logins",
			"value": 0
		},
		{
			"name": "Level 3 Logins",
			"value": 0
		}
	];
	showLegend: boolean = true;
	showLabels: boolean = true;
	loginsPerAppColorScheme = {
		domain: ['#E44D25', '#509CD0']
	};
	loginsPerLevelColorScheme = {
		domain: ['#E44D25', '#509CD0', '#5AA454']
	};
	
	//recentLogins = [{rangerID: 1, firstName: 'N/A', lastName: 'N/A', accessLevel: 'N/A', dateObj: new Date(), platform: 'N/A'}];
	recentLogins = [];
	@ViewChild(MatPaginator) set recentLoginsPaginator(value: MatPaginator) {
		this.recentLoginsDataSource.paginator = value;
	}
	//@ViewChild(MatPaginator) recentLoginsPaginator: MatPaginator;
	@ViewChild(MatSort) set recentLoginsSort(value: MatSort) {
		this.recentLoginsDataSource.sort = value;
	}
	displayedColumns: string[] = ['lastName', 'level', 'date', 'platform'];
	recentLoginsDataSource = new MatTableDataSource<any>(this.recentLogins);
	
	@ViewChild('loginsByDateToggleGroup') loginsByDateToggleGroup;
	loginsPerDate = [];
	loginsPerDateColorScheme = {
		domain: ['#5AA454', '#E44D25', '#509CD0']
	};
	loginsByDateRangeForm: FormGroup;
	loginsByDateStart;
	loginsByDateEnd;
	loginsByDateFilter = "platform";

	constructor(private formBuilder: FormBuilder, private router: Router, private rangerStatsService: RangerStatisticsService) { 
		rangerStatsService.loginsByApplication$.subscribe(
			logins => {
				this.loginsPerApp = logins;
			}
		);
		rangerStatsService.loginsByDate$.subscribe(
			logins => {
				console.log(logins);
				this.loginsPerDate = logins;
			}
		);		
		rangerStatsService.loginsByLevel$.subscribe(
			logins => {
				this.loginsPerLevel = logins;
			}
		);
		rangerStatsService.recentLogins$.subscribe(
			logins => {
				this.recentLogins = logins;
				this.recentLoginsDataSource.data = this.recentLogins;
			}
		);
	}
	get loginsByDateRange() { return this.loginsByDateRangeForm.controls; }

	ngOnInit(): void {
		document.getElementById("overview-route").classList.add("activeRoute");
		
		this.loginsByDateEnd = new Date();
		this.loginsByDateStart = new Date(this.loginsByDateEnd.getTime());
		this.loginsByDateStart.setDate(this.loginsByDateStart.getDate() - 7);
		this.loginsByDateRangeForm = this.formBuilder.group({
			loginsByDateStartControl: ['', Validators.required],
			loginsByDateEndControl: ['', Validators.required]
		});
		this.loginsByDateRangeForm.controls['loginsByDateEndControl'].valueChanges.subscribe(val => {
			if (val != null) {
				this.changeLoginsByDateRange();
			}
		});
		  
		this.recentLoginsDataSource.paginator = this.recentLoginsPaginator;
			this.recentLoginsDataSource.sortingDataAccessor = (ranger, property) => {
			switch (property) {
				case 'lastName': return ranger.rangerID.lastName;
				case 'level': return ranger.rangerID.accessLevel;
				case 'date': return ranger.dateObj;
				case 'platform': return ranger.platform;				
			};
		};			
		this.recentLoginsDataSource.sort = this.recentLoginsSort;
		this.loadStatistics();
		  /*
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
		*/
	}
	onChanges(): void {

	}
	loadStatistics() {
		this.rangerStatsService.getRangerLogins(JSON.parse(localStorage.getItem('currentToken'))['value']);
	}
	
	changeLoginsByDateFilter(filter: any) {
		this.loginsByDateFilter = filter;
		this.rangerStatsService.getLoginsByDate(this.loginsByDateStart, this.loginsByDateEnd, filter);
	}	
	changeLoginsByDateRange() {
		this.loginsByDateStart = this.loginsByDateRange.loginsByDateStartControl.value;
		this.loginsByDateEnd = this.loginsByDateRange.loginsByDateEndControl.value;
		this.rangerStatsService.getLoginsByDate(this.loginsByDateStart, this.loginsByDateEnd, this.loginsByDateFilter);
	}
	
	changeRangerStatsTab(index: number) {
		this.activeRangerStatsTabIndex = index;
		this.rangerStatsTab.selectedIndex  = index;
		this.closeSidenav();
	}
	route(temp: string) {
		this.router.navigate([temp]);
	}
	
	//Ranger Search sidenav
	openSidenav() {
		this.statsSidenav.open();
		document.getElementById('sidenav-open-btn-container').style.transitionDuration = '0.2s';
		document.getElementById('sidenav-open-btn-container').style.left = '-10%';
	}
	closeSidenav() {
		this.statsSidenav.close();
		document.getElementById('sidenav-open-btn-container').style.transitionDuration = '0.8s';
		document.getElementById('sidenav-open-btn-container').style.left = '0%';
	}
	showSidenavBtn() {
		document.getElementById('sidenav-open-btn-container').style.transitionDuration = '0.8s';
		document.getElementById('sidenav-open-btn-container').style.left = '0%';		
	}
	
	viewRangerProfile(token: string) {
		this.router.navigate(['rangers/profiles'], { queryParams: { ranger: token } });
	}

	startLoader() {
		document.getElementById('loader-container').style.visibility = 'visible';
	}
	stopLoader() {
		document.getElementById('loader-container').style.visibility = 'hidden';
	}		
	stopSidenavLoader() {
		//throw new Error('Method not implemented.');
	}
}
