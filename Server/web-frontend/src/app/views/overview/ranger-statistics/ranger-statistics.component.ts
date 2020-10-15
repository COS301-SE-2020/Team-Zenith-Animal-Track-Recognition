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
  styleUrls: ['./ranger-statistics.component.css'],
  providers: [RangerStatisticsService]
})
export class RangerStatisticsComponent implements OnInit {

	//Graph Colour Schemes
	redColorScheme = {
		domain: ['#E44D25']
	};
	blueColorScheme = {
		domain: ['#509CD0']
	};
	greenColorScheme = {
		domain: ['#19A020']
	};
	cardColor: string = '#FFF';
	numIdsByDateColorScheme = {
		domain: ['#E44D25', '#509CD0', '#19A020', '#BA66E8']
	};		
	avgScoreByDateColorScheme = {
		domain: ['#EECC6A', '#E44D25', '#509CD0', '#19A020', '#BA66E8']
	};	
	
	@ViewChild('statisticsSidenav') statsSidenav;
	@ViewChild('rangerStatsTab') rangerStatsTab;
	activeRangerStatsTabIndex = 0;
	
	loginsPerApp = [];
	loginsPerLevel = [];
	showLegend: boolean = true;
	showLabels: boolean = true;
	loginsPerAppColorScheme = {
		domain: ['#E44D25', '#509CD0']
	};
	loginsPerLevelColorScheme = {
		domain: ['#E44D25', '#509CD0', '#19A020']
	};
	
	recentLogins = [];
	@ViewChild(MatPaginator) set recentLoginsPaginator(value: MatPaginator) {
		this.recentLoginsDataSource.paginator = value;
	}
	@ViewChild(MatSort) set recentLoginsSort(value: MatSort) {
		this.recentLoginsDataSource.sort = value;
	}
	displayedColumns: string[] = ['lastName', 'level', 'date', 'platform'];
	recentLoginsDataSource = new MatTableDataSource<any>(this.recentLogins);
	
	@ViewChild('loginsByDateToggleGroup') loginsByDateToggleGroup;
	loginsPerDate = [];
	loginsPerDateColorScheme = {
		domain: ['#E44D25', '#509CD0', '#19A020']
	};
	loginsByDateRangeForm: FormGroup;
	loginsByDateStart;
	loginsByDateEnd;
	loginsByDateFilter = "platform";
	
	//Tracking Activity Variables - Overview
	identificationsByDateColorScheme = this.numIdsByDateColorScheme;
	identificationsByDateYLabel = "Number of Track Identifications";
	alltime_numIdentifications = [];
	alltime_avgAccuracyScore = [];
	allTimeNumAndScoreIds = [];
	allIdentifications = [];
	allIdentificationsByLevel = [];
	allIdsByDateRangeForm: FormGroup;
	allIdsByDateStart;
	allIdsByDateEnd;
	allIdsByDateFilter = "identifications";
	//Tracking Activity Variables - By Ranger
	idsByRangerAndDateColorScheme = this.numIdsByDateColorScheme;
	idsByRangerAndDateYLabel = "# of Identifications";
	allIdsByRangerAndDate = [];
	mostIdentifications = [];
	idsByRangerAndDateRangeForm: FormGroup;
	idsByRangerAndDateStart;
	idsByRangerAndDateEnd;
	idsByRangerAndDateFilter = "identifications";

	constructor(private formBuilder: FormBuilder, private router: Router, private rangerStatsService: RangerStatisticsService) { 
		//Login Activity
		rangerStatsService.loginsByApplication$.subscribe(
			logins => {
				this.loginsPerApp = logins;
			}
		);
		rangerStatsService.loginsByDate$.subscribe(
			logins => {
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
		
		//Tracking Activity Overview
		rangerStatsService.allIdentificationsByDate$.subscribe(
			identifications => {
				this.allIdentifications = identifications;
			}
		);
		rangerStatsService.allTimeNumAndScoreIds$.subscribe(
			allTimeIds => {
				this.alltime_numIdentifications = [allTimeIds[0]];
				this.alltime_avgAccuracyScore = [allTimeIds[1]];
			}
		);
		rangerStatsService.allIdentificationsByLevel$.subscribe(
			allIdsByLevel => {
				this.allIdentificationsByLevel = allIdsByLevel;
			}
		);
		rangerStatsService.mostIdentified$.subscribe(
			avgScore => {
				this.mostIdentifications = avgScore;
			}
		);
		
		//Tracking Activity By Ranger
		rangerStatsService.allIdsRangerAndDate$.subscribe(
			identifications => {
				this.allIdsByRangerAndDate = identifications;
			}
		);
	}
	get loginsByDateRange() { return this.loginsByDateRangeForm.controls; }
	get allIdsByDateRange() { return this.allIdsByDateRangeForm.controls; }
	get idsByRangerAndDateRange() { return this.idsByRangerAndDateRangeForm.controls; }
	
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
		
		this.allIdsByDateEnd = new Date();
		this.allIdsByDateStart = new Date(this.allIdsByDateEnd.getTime());
		this.allIdsByDateStart.setDate(this.allIdsByDateStart.getDate() - 7);
		this.allIdsByDateRangeForm = this.formBuilder.group({
			allIdsByDateStartControl: ['', Validators.required],
			allIdsByDateEndControl: ['', Validators.required]
		});
		this.allIdsByDateRangeForm.controls['allIdsByDateEndControl'].valueChanges.subscribe(val => {
			if (val != null) {
				this.changeAllIdsByDateRange();
			}
		});
		
		this.idsByRangerAndDateEnd = new Date();
		this.idsByRangerAndDateStart = new Date(this.idsByRangerAndDateEnd.getTime());
		this.idsByRangerAndDateStart.setDate(this.idsByRangerAndDateStart.getDate() - 7);
		this.idsByRangerAndDateRangeForm = this.formBuilder.group({
			idsByRangerAndDateStartControl: ['', Validators.required],
			idsByRangerAndDateEndControl: ['', Validators.required]
		});
		this.idsByRangerAndDateRangeForm.controls['idsByRangerAndDateEndControl'].valueChanges.subscribe(val => {
			if (val != null) {
				this.changeIdsByRangerAndDateRange();
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
	}

	loadStatistics() {
		this.rangerStatsService.getRangerLoginActivity(JSON.parse(localStorage.getItem('currentToken'))['value']);
		this.rangerStatsService.getAllTrackingActivity(JSON.parse(localStorage.getItem('currentToken'))['value']);	
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
	
	changeIdentificationsByDateFilter(filter: any) {
		switch (filter) {
			case "identifications":
				this.identificationsByDateYLabel = "Number of Track Identifications";
				this.identificationsByDateColorScheme = this.numIdsByDateColorScheme;
			break;
			case "accuracy score":
				this.identificationsByDateYLabel = "Avg. Accuracy Score (%)";
				this.identificationsByDateColorScheme = this.avgScoreByDateColorScheme;
			break;
		}
		this.allIdsByDateFilter = filter;
		this.rangerStatsService.getAllIdentificationsByDate(this.allIdsByDateStart, this.allIdsByDateEnd, filter);
	}
	changeAllIdsByDateRange() {
		this.allIdsByDateStart = this.allIdsByDateRange.allIdsByDateStartControl.value;
		this.allIdsByDateEnd = this.allIdsByDateRange.allIdsByDateEndControl.value;
		this.rangerStatsService.getAllIdentificationsByDate(this.allIdsByDateStart, this.allIdsByDateEnd, this.allIdsByDateFilter);
	}
	
	changeIdsByRangerAndDateFilter(filter: any) {
		switch (filter) {
			case "identifications":
				this.idsByRangerAndDateYLabel = "# of Identifications";
				this.idsByRangerAndDateColorScheme = this.numIdsByDateColorScheme;
			break;
			case "accuracy score":
				this.idsByRangerAndDateYLabel = "Avg. Accuracy Score (%)";
				this.idsByRangerAndDateColorScheme = this.avgScoreByDateColorScheme;
			break;
		}
		this.idsByRangerAndDateFilter = filter;
		this.rangerStatsService.getAllIdsByRangerAndDate(this.idsByRangerAndDateStart, this.idsByRangerAndDateEnd, filter);
	}
	changeIdsByRangerAndDateRange() {
		this.idsByRangerAndDateStart = this.idsByRangerAndDateRange.idsByRangerAndDateStartControl.value;
		this.idsByRangerAndDateEnd = this.idsByRangerAndDateRange.idsByRangerAndDateEndControl.value;
		this.rangerStatsService.getAllIdsByRangerAndDate(this.idsByRangerAndDateStart, this.idsByRangerAndDateEnd, this.idsByRangerAndDateFilter);
	}
	
	//Formatting functions
	formatAsPercentage(val: any) {
		return val.value + "%";
	}
	formatWithTimeFrame(val: any) {
		return val.label;
	}
	
	//Navigation functions
	changeRangerStatsTab(index: number) {
		if (index == 0) {
			this.rangerStatsService.getRangerLoginActivity(JSON.parse(localStorage.getItem('currentToken'))['value']);
			this.loginsByDateFilter = "platform";
		}
		else if (index == 1) {
			this.rangerStatsService.getAllTrackingActivity(JSON.parse(localStorage.getItem('currentToken'))['value']);
			this.rangerStatsService.getAllTrackingActivityByRanger(JSON.parse(localStorage.getItem('currentToken'))['value']);
			this.identificationsByDateYLabel = "Number of Track Identifications";			
			this.allIdsByDateFilter = "identifications";
			this.identificationsByDateColorScheme = this.numIdsByDateColorScheme;
		}
		
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
