import { Component, OnInit, ViewChild } from '@angular/core';
import { EMPTY } from 'rxjs';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { MatSort } from '@angular/material/sort';
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
	
	
	//Tracking Activity Variables - Overview
	identificationsByDateColorScheme = this.numIdsByDateColorScheme;
	identificationsByDateYLabel = "Number of Track Identifications";
	numAnimals = [];
	alltime_numIdentifications = [];
	mostTrackedAnimal = null;
	leastTrackedAnimal = null;
	
	alltime_avgAccuracyScore = [];
	allTimeNumAndScoreIds = [];
	allIdentifications = [];
	allIdentificationsByLevel = [];
	allIdsByDateFilter = "identifications";


	constructor(private formBuilder: FormBuilder, private router: Router, private animalStatsService: AnimalStatisticsService) { 
		animalStatsService.numAnimals$.subscribe(
			num => {
				this.numAnimals = num;
			}
		);
		animalStatsService.numIdentifications$.subscribe(
			num => {
				this.alltime_numIdentifications = num;
			}
		);		
		animalStatsService.mostTrackedAnimal$.subscribe(
			animal => {
				this.mostTrackedAnimal = animal;
				console.log(this.mostTrackedAnimal);
			}
		);
		animalStatsService.leastTrackedAnimal$.subscribe(
			animal => {
				this.leastTrackedAnimal = animal;
			}
		);
	}
	
	ngOnInit(): void {
		document.getElementById("overview-route").classList.add("activeRoute");
		this.loadStatistics();
	}

	loadStatistics() {
		this.animalStatsService.getAnimalTrackingActivity(JSON.parse(localStorage.getItem('currentToken'))['value']);
	}
	
	//Formatting functions
	formatAsPercentage(val: any) {
		return val.value + "%";
	}
	formatWithTimeFrame(val: any) {
		return val.label;
	}
	
	//Navigation functions
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
	
	viewAnimalProfile(token: string) {
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
