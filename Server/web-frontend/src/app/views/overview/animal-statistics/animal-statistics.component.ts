import { Component, OnInit, ViewChild } from '@angular/core';
import { EMPTY } from 'rxjs';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { Router, ActivatedRoute } from '@angular/router';
import { AnimalStatisticsService } from './../../../services/animal-statistics.service';

@Component({
  selector: 'app-animal-statistics',
  templateUrl: './animal-statistics.component.html',
  styleUrls: ['./animal-statistics.component.css'],
   providers: [AnimalStatisticsService]
})
export class AnimalStatisticsComponent implements OnInit {
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
	@ViewChild('animalStatsTab') animalStatsTab;
	activeAnimalStatsTabIndex = 0;
	
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
		domain: ['#5AA454', '#E44D25', '#509CD0']
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
	//Tracking Activity Variables - By animal
	idsByAnimalAndDateColorScheme = this.numIdsByDateColorScheme;
	idsByAnimalAndDateYLabel = "# of Identifications";
	allIdsByAnimalAndDate = [];
	mostIdentifications = [];
	idsByAnimalAndDateRangeForm: FormGroup;
	idsByAnimalAndDateStart;
	idsByAnimalAndDateEnd;
	idsByAnimalAndDateFilter = "identifications";

	constructor(private formBuilder: FormBuilder, private router: Router, private animalStatsService: AnimalStatisticsService) { 
		/*animalStatsService.loginsByApplication$.subscribe(
			logins => {
				this.loginsPerApp = logins;
			}
		);
		animalStatsService.loginsByDate$.subscribe(
			logins => {
				this.loginsPerDate = logins;
			}
		);		
		animalStatsService.loginsByLevel$.subscribe(
			logins => {
				this.loginsPerLevel = logins;
			}
		);
		animalStatsService.recentLogins$.subscribe(
			logins => {
				this.recentLogins = logins;
				this.recentLoginsDataSource.data = this.recentLogins;
			}
		);
		animalStatsService.allIdentificationsByDate$.subscribe(
			identifications => {
				this.allIdentifications = identifications;
			}
		);
		animalStatsService.allTimeNumAndScoreIds$.subscribe(
			allTimeIds => {
				this.alltime_numIdentifications = [allTimeIds[0]];
				this.alltime_avgAccuracyScore = [allTimeIds[1]];
			}
		);
		animalStatsService.allIdentificationsByLevel$.subscribe(
			allIdsByLevel => {
				this.allIdentificationsByLevel = allIdsByLevel;
			}
		);
		animalStatsService.mostIdentified$.subscribe(
			avgScore => {
				this.mostIdentifications = avgScore;
			}
		);*/
	}
	get loginsByDateRange() { return this.loginsByDateRangeForm.controls; }
	get allIdsByDateRange() { return this.allIdsByDateRangeForm.controls; }
	get idsByAnimalAndDateRange() { return this.idsByAnimalAndDateRangeForm.controls; }
	
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
		
		this.idsByAnimalAndDateEnd = new Date();
		this.idsByAnimalAndDateStart = new Date(this.idsByAnimalAndDateEnd.getTime());
		this.idsByAnimalAndDateStart.setDate(this.idsByAnimalAndDateStart.getDate() - 7);
		this.idsByAnimalAndDateRangeForm = this.formBuilder.group({
			idsByAnimalAndDateStartControl: ['', Validators.required],
			idsByAnimalAndDateEndControl: ['', Validators.required]
		});
		this.idsByAnimalAndDateRangeForm.controls['idsByAnimalAndDateEndControl'].valueChanges.subscribe(val => {
			if (val != null) {
				this.changeIdsByAnimalAndDateRange();
			}
		});
		  
		this.recentLoginsDataSource.paginator = this.recentLoginsPaginator;
			this.recentLoginsDataSource.sortingDataAccessor = (animal, property) => {
			switch (property) {
				case 'lastName': return animal.animalID.lastName;
				case 'level': return animal.animalID.accessLevel;
				case 'date': return animal.dateObj;
				case 'platform': return animal.platform;				
			};
		};			
		this.recentLoginsDataSource.sort = this.recentLoginsSort;
		this.loadStatistics();
		  /*
		this.mostTracked = { mosotTrakedanimal: '' };
		this.latest = { animal: { firstName: '', lastName: '' }, animal: { commonName: '' } };
		this.leastIdentified = { commonName: ''};
		this.animalPercentages = { commonName: ''};


		this.http.get<any>(ROOT_QUERY_STRING + '?query=query{spoorIdentification(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
		  '",sigil:"yes"){animal{commonName},animal{animalID,accessLevel,firstName,lastName},dateAndTime{year,month,day,hour,min,second}}}')
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

	loadStatistics() {
		//this.animalStatsService.getanimalLoginActivity(JSON.parse(localStorage.getItem('currentToken'))['value']);
		//this.animalStatsService.getAllTrackingActivity(JSON.parse(localStorage.getItem('currentToken'))['value']);	
	}
	
	
	changeLoginsByDateFilter(filter: any) {
		this.loginsByDateFilter = filter;
	//	this.animalStatsService.getLoginsByDate(this.loginsByDateStart, this.loginsByDateEnd, filter);
	}	
	changeLoginsByDateRange() {
		this.loginsByDateStart = this.loginsByDateRange.loginsByDateStartControl.value;
		this.loginsByDateEnd = this.loginsByDateRange.loginsByDateEndControl.value;
	//	this.animalStatsService.getLoginsByDate(this.loginsByDateStart, this.loginsByDateEnd, this.loginsByDateFilter);
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
		//this.animalStatsService.getAllIdentificationsByDate(this.allIdsByDateStart, this.allIdsByDateEnd, filter);
	}
	changeAllIdsByDateRange() {
		this.allIdsByDateStart = this.allIdsByDateRange.allIdsByDateStartControl.value;
		this.allIdsByDateEnd = this.allIdsByDateRange.allIdsByDateEndControl.value;
		//this.animalStatsService.getAllIdentificationsByDate(this.allIdsByDateStart, this.allIdsByDateEnd, this.allIdsByDateFilter);
	}
	
	changeIdsByAnimalAndDateFilter(filter: any) {
		switch (filter) {
			case "identifications":
				this.idsByAnimalAndDateYLabel = "# of Identifications";
				this.idsByAnimalAndDateColorScheme = this.numIdsByDateColorScheme;
			break;
			case "accuracy score":
				this.idsByAnimalAndDateYLabel = "Avg. Accuracy Score (%)";
				this.idsByAnimalAndDateColorScheme = this.avgScoreByDateColorScheme;
			break;
		}
		this.idsByAnimalAndDateFilter = filter;
		//this.animalStatsService.getAllIdsByanimalAndDate(this.idsByanimalAndDateStart, this.idsByanimalAndDateEnd, filter);
	}
	changeIdsByAnimalAndDateRange() {
		this.idsByAnimalAndDateStart = this.idsByAnimalAndDateRange.idsByAnimalAndDateStartControl.value;
		this.idsByAnimalAndDateEnd = this.idsByAnimalAndDateRange.idsByAnimalAndDateEndControl.value;
		//this.animalStatsService.getAllIdsByanimalAndDate(this.idsByanimalAndDateStart, this.idsByanimalAndDateEnd, this.idsByanimalAndDateFilter);
	}
	
	//Formatting functions
	formatAsPercentage(val: any) {
		return val.value + "%";
	}
	formatWithTimeFrame(val: any) {
		return val.label;
	}
	
	//Navigation functions
	changeAnimalStatsTab(index: number) {
		if (index == 0) {
			//this.animalStatsService.getanimalLoginActivity(JSON.parse(localStorage.getItem('currentToken'))['value']);
			this.loginsByDateFilter = "platform";
		}
		else if (index == 1) {
			//this.animalStatsService.getAllTrackingActivity(JSON.parse(localStorage.getItem('currentToken'))['value']);
			//this.animalStatsService.getAllTrackingActivityByanimal(JSON.parse(localStorage.getItem('currentToken'))['value']);
			this.identificationsByDateYLabel = "Number of Track Identifications";			
			this.allIdsByDateFilter = "identifications";
			this.identificationsByDateColorScheme = this.numIdsByDateColorScheme;
		}
		
		this.activeAnimalStatsTabIndex = index;
		this.animalStatsTab.selectedIndex  = index;
		this.closeSidenav();
	}
	route(temp: string) {
		this.router.navigate([temp]);
	}
	
	//animal Search sidenav
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
	
	viewanimalProfile(token: string) {
		this.router.navigate(['animals/profiles'], { queryParams: { animal: token } });
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
